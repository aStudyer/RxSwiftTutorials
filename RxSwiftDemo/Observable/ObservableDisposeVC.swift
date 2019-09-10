//
//  ObservableDisposeVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//
/**
 1）一个 Observable 序列被创建出来后它不会马上就开始被激活从而发出 Event，而是要等到它被某个人订阅了才会激活它。
 （2）而 Observable 序列激活之后要一直等到它发出了 .error 或者 .completed 的 event 后，它才被终结。
 dispose() 方法
 （1）使用该方法我们可以手动取消一个订阅行为。
 （2）如果我们觉得这个订阅结束了不再需要了，就可以调用 dispose() 方法把这个订阅给销毁掉，防止内存泄漏。
 （2）当一个订阅行为被 dispose 了，那么之后 observable 如果再发出 event，这个已经 dispose 的订阅就收不到消息了。
 
 DisposeBag
 除了 dispose() 方法之外，我们更经常用到的是一个叫 DisposeBag 的对象来管理多个订阅行为的销毁：
 我们可以把一个 DisposeBag 对象看成一个垃圾袋，把用过的订阅行为都放进去。
 而这个 DisposeBag 就会在自己快要 dealloc 的时候，对它里面的所有订阅行为都调用 dispose() 方法。
 */
import UIKit
import RxSwift

class ObservableDisposeVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        demo_01()
        demo_02()
    }

}
// MARK: - 私有方法
extension ObservableDisposeVC {
    private func demo_01() {
        let observable = Observable.of("A", "B", "C")
        
        //使用subscription常量存储这个订阅方法
        let subscription = observable.subscribe { event in
            print(event)
        }
        
        //调用这个订阅的dispose()方法
        subscription.dispose()
    }
    private func demo_02() {
        //第1个Observable，及其订阅
        let observable1 = Observable.of("A", "B", "C")
        observable1.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
        
        //第2个Observable，及其订阅
        let observable2 = Observable.of(1, 2, 3)
        observable2.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
}
