//
//  RXActivityIndicatorViewDetailVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit

class RXActivityIndicatorViewDetailVC: BaseViewController {
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
extension RXActivityIndicatorViewDetailVC {
    private func demo_01() {
        mySwitch.rx.value
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    /// RxSwift 对 UIApplication 增加了一个名为 isNetworkActivityIndicatorVisible 绑定属性，我们通过它可以设置是否显示联网指示器（网络请求指示器）
    private func demo_02() {
        mySwitch.rx.value
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
    }
}
