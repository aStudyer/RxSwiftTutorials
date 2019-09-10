//
//  RXSwitchDetailVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXSwitchDetailVC: BaseViewController {
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    
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
extension RXSwitchDetailVC {
    /// UISwitch（开关按钮）
    private func demo_01() {
        switchView.rx.isOn.asObservable()
            .subscribe(onNext: {
                print("当前开关状态：\($0)")
            })
            .disposed(by: disposeBag)
    }
    /// UISegmentedControl（分段选择控件）
    private func demo_02() {
        segment.rx.selectedSegmentIndex.map{
            UIImage(named: $0 == 0 ? "dianzan" : "xingji")!
            }.bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
