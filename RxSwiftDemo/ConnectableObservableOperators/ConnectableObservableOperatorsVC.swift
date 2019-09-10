//
//  ConnectableObservableOperatorsVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/26.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//
/*
 可连接的序列（Connectable Observable）：
 （1）可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect() 之后才会开始发送值。
 （2）可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息。
 */
import UIKit
import RxSwift
import RxCocoa

class ConnectableObservableOperatorsVC: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension ConnectableObservableOperatorsVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            demo()
        case 1:
            publish()
        case 2:
            replay()
        case 3:
            multicast()
        case 4:
            refCount()
        case 5:
            share_relay()
        default:
            break
        }
    }
}
// MARK: - 私有方法
extension ConnectableObservableOperatorsVC {
    private func demo() {
        // 在演示可连接序列之前，先看一个普通序列的样例：
        // 每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        // 第一个订阅者（立刻开始订阅）
        interval
            .subscribe(onNext: { print("订阅1: \($0)") }).disposed(by: disposeBag)
        
        // 第二个订阅者（延迟5秒开始订阅）
        delay(5) {[weak self] in
            guard let self = self else {return}
            interval
                .subscribe(onNext: { print("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
        // 可以看到第一个订阅者订阅后，每隔 1 秒会收到一个值。而第二个订阅者 5 秒后才收到第一个值 0，所以两个订阅者接收到的值是不同步的。
    }
    
    /**
     publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
     */
    private func publish() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
        
        //第一个订阅者（立刻开始订阅）
        interval
            .subscribe(onNext: { print("订阅1: \($0)") })
            .disposed(by: disposeBag)
        
        //相当于把事件消息推迟了两秒
        delay(2) {[weak self] in
            guard let self = self else {return}
            interval.connect().disposed(by: self.disposeBag)
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {[weak self] in
            guard let self = self else {return}
            interval
                .subscribe(onNext: { print("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    /**
     replay 同上面的 publish 方法相同之处在于：会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
     replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）。
     */
    private func replay() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .replay(5)
        
        //第一个订阅者（立刻开始订阅）
        interval
            .subscribe(onNext: { print("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //相当于把事件消息推迟了两秒
        delay(2) {[weak self] in
            guard let self = self else {return}
            interval.connect().disposed(by: self.disposeBag)
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {[weak self] in
            guard let self = self else {return}
            interval
                .subscribe(onNext: { print("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    /**
     multicast 方法同样是将一个正常的序列转换成一个可连接的序列。
     同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送。
     */
    private func multicast() {
        //创建一个Subject（后面的multicast()方法中传入）
        let subject = PublishSubject<Int>()
        
        //这个Subject的订阅
        subject
            .subscribe(onNext: { print("Subject: \($0)") })
            .disposed(by: disposeBag)
        
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .multicast(subject)
        
        //第一个订阅者（立刻开始订阅）
        interval
            .subscribe(onNext: { print("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //相当于把事件消息推迟了两秒
        delay(2) {[weak self] in
            guard let self = self else {return}
            interval.connect().disposed(by: self.disposeBag)
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {[weak self] in
            guard let self = self else {return}
            interval
                .subscribe(onNext: { print("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    /**
     refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
     即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的 Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接。
     */
    private func refCount() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
            .refCount()
        
        //第一个订阅者（立刻开始订阅）
        interval
            .subscribe(onNext: { print("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {[weak self] in
            guard let self = self else {return}
            interval
                .subscribe(onNext: { print("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    /**
     该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
     简单来说 shareReplay 就是 replay 和 refCount 的组合。
     */
    private func share_relay() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .share(replay: 5)
        
        //第一个订阅者（立刻开始订阅）
        interval
            .subscribe(onNext: { print("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {[weak self] in
            guard let self = self else {return}
            interval
                .subscribe(onNext: { print("订阅2: \($0)") })
                .disposed(by: self.disposeBag)
        }
    }
}
extension ConnectableObservableOperatorsVC {
    ///延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - closure: 延迟执行的闭包
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
