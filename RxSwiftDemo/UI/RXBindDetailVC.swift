//
//  RXBindDetailVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXBindDetailVC: BaseViewController {
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    var userVM = UserViewModel()
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch indexPath.row {
        case 0:
            demo_01()
        case 1:
            demo_02()
            
        default:
            break
        }
    }
}
extension RXBindDetailVC {
    /// 简单的双向绑定
    private func demo_01() {
        //将用户名与textField做双向绑定
        userVM.username.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag)
        textField.rx.text.orEmpty.bind(to: userVM.username).disposed(by: disposeBag)
        
        //将用户信息绑定到label上
        userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)
    }
    /// 自定义双向绑定操作符（operator）
    private func demo_02() {
        //将用户名与textField做双向绑定
        _ = self.textField.rx.textInput <-> self.userVM.username
        
        //将用户信息绑定到label上
        userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)
    }
}
struct UserViewModel {
    //用户名
//    let username = Variable("guest")
    let username = BehaviorRelay(value: "guest")
    
    //用户信息
    lazy var userinfo = {
        return self.username.asObservable()
            .map{ $0 == "cc" ? "您是管理员" : "您是普通访客" }
            .share(replay: 1)
    }()
}
