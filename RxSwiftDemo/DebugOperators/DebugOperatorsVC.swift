//
//  DebugOperatorsVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/27.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift

class DebugOperatorsVC: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension DebugOperatorsVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            debug()
        case 1:
            total()
        default:
            break
        }
    }
}
// MARK: - 私有方法
extension DebugOperatorsVC {
    /**
     我们可以将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试。
     */
    private func debug() {
//        Observable.of("2", "3")
//            .startWith("1")
//            .debug()
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
        // debug() 方法还可以传入标记参数，这样当项目中存在多个 debug 时可以很方便地区分出来。
        Observable.of("2", "3")
            .startWith("1")
            .debug("调试1")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    /**
     通过将 RxSwift.Resources.total 打印出来，我们可以查看当前 RxSwift 申请的所有资源数量。这个在检查内存泄露的时候非常有用。
     */
    private func total() {
        print(RxSwift.Resources.total)
        
        Observable.of("BBB", "CCC")
            .startWith("AAA")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        print(RxSwift.Resources.total)
    }
}
