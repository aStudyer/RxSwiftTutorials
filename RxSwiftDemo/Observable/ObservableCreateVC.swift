//
//  ObservableVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

class ObservableCreateVC: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
enum MyError: Error {
    case A
    case B
}
enum ObservableType {
    case just
    case of
    case from
    case empty
    case never
    case error
    case range
    case repeatElement
    case generate
    case create
    case deferred
    case interval
    case timer
}
extension Int {
    var type: ObservableType {
        switch self {
        case 0:
            return .just
        case 1:
            return .of
        case 2:
            return .from
        case 3:
            return .empty
        case 4:
            return .never
        case 5:
            return .error
        case 6:
            return .range
        case 7:
            return .repeatElement
        case 8:
            return .generate
        case 9:
            return .create
        case 10:
            return .deferred
        case 11:
            return .interval
        case 12:
            return .timer
        default:
            print("\(self)")
            return .just
        }
    }
}
extension ObservableCreateVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row.type {
        case .just:
            just()
            break
        case .of:
            of()
            break
        case .from:
            from()
            break
        case .empty:
            empty()
            break
        case .never:
            never()
            break
        case .error:
            error()
            break
        case .range:
            range()
            break
        case .repeatElement:
            repeatElement()
            break
        case .generate:
            generate()
            break
        case .create:
            create()
            break
        case .deferred:
            deferred()
            break
        case .interval:
            interval()
            break
        case .timer:
            timer()
            break
        }
    }
}

extension ObservableCreateVC {
    /**
     （1）该方法通过传入一个默认值来初始化。
     （2）下面样例我们显式地标注出了 observable 的类型为 Observable<Int>，即指定了这个 Observable 所发出的事件携带的数据类型必须是 Int 类型的。
     */
    private func just() {
        let _ = Observable<Int>.just(5)
    }
    /**
     （1）该方法可以接受可变数量的参数（必需要是同类型的）
     （2）下面样例中我没有显式地声明出 Observable 的泛型类型，Swift 也会自动推断类型。
     */
    private func of() {
        let _ = Observable.of("A", "B", "C")
    }
    /**
     （1）该方法需要一个数组参数。
     （2）下面样例中数据里的元素就会被当做这个 Observable 所发出 event 携带的数据内容，最终效果同上面饿 of() 样例是一样的。
    */
    private func from() {
        let _ = Observable.from(["A", "B", "C"])
    }
    /**
     该方法创建一个空内容的 Observable 序列。
    */
    private func empty() {
        let _ = Observable<Int>.empty()
    }
    /**
     该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
    */
    private func never() {
        let _ = Observable<Int>.never()
    }
    /**
     该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
    */
    private func error() {
        let _ = Observable<Int>.error(MyError.A)
    }
    /**
     （1）该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的 Observable 序列。
     （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
    */
    private func range() {
        //使用range()
        let _ = Observable.range(start: 1, count: 5)
        //使用of()
        let _ = Observable.of(1, 2, 3 ,4 ,5)
    }
    /**
     该方法创建一个可以无限发出给定元素的 Event 的 Observable 序列（永不终止）。
    */
    private func repeatElement() {
        let _ = Observable.repeatElement(1)
    }
    /**
     （1）该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
     （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
    */
    private func generate() {
        //使用generate()方法
        let _ = Observable.generate(
            initialState: 0,
            condition: { $0 <= 10 },
            iterate: { $0 + 2 }
        )
        
        //使用of()方法
        let _ = Observable.of(0 , 2 ,4 ,6 ,8 ,10)
    }
    /**
     （1）该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理。
     （2）下面是一个简单的样例。为方便演示，这里增加了订阅相关代码（关于订阅我之后会详细介绍的）。
    */
    private func create() {
        // 这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
        // 当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
        let observable = Observable<String>.create { observer -> Disposable in
            //对订阅者发出了.next事件，且携带了一个数据"Hello World!"
            observer.onNext("Hello World!")
            //对订阅者发出了.completed事件
            observer.onCompleted()
            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
            return Disposables.create()
        }
        //订阅测试
        observable.subscribe{
            print($0)
        }.dispose()
    }
    /**
     该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable 序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方。
    */
    private func deferred() {
        //用于标记是奇数、还是偶数
        var isOdd = true
        
        //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
        let factory: Observable<Int> = Observable.deferred {
            //让每次执行这个block时候都会让奇、偶数进行交替
            isOdd = !isOdd
            
            //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
            if isOdd {
                return Observable.of(1, 3, 5 ,7)
            }else {
                return Observable.of(2, 4, 6, 8)
            }
        }
        
        //第1次订阅测试
        factory.subscribe { event in
            print("\(isOdd)", event)
        }.dispose()
        
        //第2次订阅测试
        factory.subscribe { event in
            print("\(isOdd)", event)
        }.dispose()
    }
    /// 这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
    private func interval() {
        // 下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.subscribe { event in
            print(event)
        }
    }
    private func timer() {
        // （1）这个方法有两种用法，一种是创建的 Observable 序列在经过设定的一段时间后，产生唯一的一个元素。
        // 3秒种后发出唯一的一个元素0
//        let observable = Observable<Int>.timer(3, scheduler: MainScheduler.instance)
//        observable.subscribe{
//            print($0)
//        }
        
        //（2）另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
        // 延时5秒种后，每隔1秒钟发出一个元素
        let observable = Observable<Int>.timer(3, period: 1, scheduler: MainScheduler.instance)
        observable.subscribe{
            print($0)
        }
    }
}
