//
//  ObservableSubscribeVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift

class ObservableSubscribeVC: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension ObservableSubscribeVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            demo_01()
        case 1:
            demo_02()
        case 2:
            doOn()
        default:
            demo_01()
        }
    }
}
// MARK: - 私有方法
extension ObservableSubscribeVC {
    /**
     第一种用法：
     （1）我们使用 subscribe() 订阅了一个 Observable 对象，该方法的 block 的回调参数就是被发出的 event 事件，我们将其直接打印出来。
    */
    private func demo_01() {
        let observable = Observable.of("A", "B", "C")
        
        observable.subscribe { event in
            print("\(event) --- \(event.element ?? "")")
        }.disposed(by: disposeBag)
    }
    /**
     通过不同的 block 回调处理不同类型的 event。（其中 onDisposed 表示订阅行为被 dispose 后的回调，这个我后面会说）
     同时会把 event 携带的数据直接解包出来作为参数，方便我们使用。
    */
    private func demo_02() {
        let observable = Observable.of("A", "B", "C")
        
        observable.subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        }).disposed(by: disposeBag)
    }
    /**
     （1）我们可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用。
     （2）同时它和 subscribe 一样，可以通过不同的 block 回调处理不同类型的 event。比如：
     do(onNext:) 方法就是在 subscribe(onNext:) 前调用
     而 do(onCompleted:) 方法则会在 subscribe(onCompleted:) 前面调用。
    */
    private func doOn() {
        let observable = Observable.of("A", "B", "C")
        observable.do(onNext: { element in
            print("do.onNext: ", element)
        }, onError: { element in
            print("do.onError: ", element)
        }, onCompleted: {
            print("do.onCompleted")
        }, onSubscribe: {
            print("do.onSubscribe")
        }, onSubscribed: {
            print("do.onSubscribed")
        }).subscribe(onNext: { element in
                print("onNext", element)
            }, onError: { element in
                print("onError: ", element)
            }, onCompleted: {
                print("onCompleted")
            }) {
               print("disposed")
        }.disposed(by: disposeBag)
    }
}
