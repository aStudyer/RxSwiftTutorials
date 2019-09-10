//
//  TraitsObservableVC2.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/27.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//
/**
 1，基本介绍
 （1）Driver 可以说是最复杂的 trait，它的目标是提供一种简便的方式在 UI 层编写响应式代码。
 （2）如果我们的序列满足如下特征，就可以使用它：
 不会产生 error 事件
 一定在主线程监听（MainScheduler）
 共享状态变化（shareReplayLatestWhileConnected）
 
 2，为什么要使用 Driver?
 （1）Driver 最常使用的场景应该就是需要用序列来驱动应用程序的情况了，比如：
 通过 CoreData 模型驱动 UI
 使用一个 UI 元素值（绑定）来驱动另一个 UI 元素值
 （2）与普通的操作系统驱动程序一样，如果出现序列错误，应用程序将停止响应用户输入。
 （3）在主线程上观察到这些元素也是极其重要的，因为 UI 元素和应用程序逻辑通常不是线程安全的。
 （4）此外，使用构建 Driver 的可观察的序列，它是共享状态变化。
 */
import UIKit
import RxSwift
import RxCocoa

class TraitsObservableVC2: BaseViewController {
    @IBOutlet weak var query: UITextField!
    @IBOutlet weak var resultCount: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.tableFooterView = UIView()
        
        let results = query.rx.text.orEmpty.asDriver() //将普通序列转换为 Driver
            .throttle(0.3)
            .flatMapLatest { [weak self] (query) -> SharedSequence<DriverSharingStrategy, [String]> in
                return (self?.fetchAutoCompleteItems(query)
                    .asDriver(onErrorJustReturn: []))!  //仅仅提供发生错误时的备选返回值
        }
        //将返回的结果绑定到显示结果数量的label上
        results
            .map { "\($0.count)" }
            .drive(resultCount.rx.text) // 这里使用 drive 而不是 bindTo
            .disposed(by: disposeBag)
        
        //将返回的结果绑定到tableView上
        results
            .drive(resultsTableView.rx.items(cellIdentifier: "Cell")) { //  同样使用 drive 而不是 bindTo
                (_, result, cell) in
                cell.textLabel?.text = "\(result)"
            }
            .disposed(by: disposeBag)
    }
}
extension TraitsObservableVC2 {
    func fetchAutoCompleteItems(_ query: String) -> Observable<[String]> {
        return Observable<[String]>.create { observable in
            let url = "https://www.wanandroid.com/article/query/0/json"
            var request = URLRequest(url: URL(string: url)!)
            request.httpBody = "k=\(query)".data(using: .utf8)
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    observable.onError(error)
                    return
                }
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data,
                                                                 options: .mutableLeaves),
                    let result = json as? [String: Any],
                    let datas = (result["data"] as! [String: Any])["datas"] as? [[String: Any]]
                else {
                        observable.onError(DataError.cantParseJSON)
                        return
                }
                var results = [String]()
                for data in datas {
                    results.append(data["author"] as! String)
                }
                print("results = \(results)")
                observable.onNext(results)
                observable.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
    //与数据相关的错误类型
    enum DataError: Error {
        case cantParseJSON
    }
}
