//
//  ObserverViewController1.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ObserverViewController1: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension ObserverViewController1 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            subscribe()
        case 1:
            bind()
        default:
            subscribe()
        }
    }
}
// MARK: - 私有方法
extension ObserverViewController1 {
    /// 在 subscribe 方法中创建
    private func subscribe() {
        /**
         （1）创建观察者最直接的方法就是在 Observable 的 subscribe 方法后面描述当事件发生时，需要如何做出响应。
         （2）比如下面的样例，观察者就是由后面的 onNext，onError，onCompleted 这些闭包构建出来的。
        */
        let observable = Observable.of("A", "B", "C")
        
        observable.subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }).disposed(by: disposeBag)
    }
    /// 在 bind 方法中创建
    private func bind() {
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map{"当前索引是\($0)"}.bind{
            [weak self] text in
            self?.navigationItem.title = text
            }.disposed(by: disposeBag)
    }
}
