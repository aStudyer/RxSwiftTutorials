//
//  ObserverViewController2.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift

class ObserverViewController2: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension ObserverViewController2 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            subscribe()
        case 1:
            bindTo()
        default:
            break
        }
    }
}
// MARK: - 私有方法
extension ObserverViewController2 {
    private func subscribe() {
        let observer: AnyObserver<String> = AnyObserver{event in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        let observable = Observable.of("A", "B", "C")
        observable.subscribe(observer).disposed(by: disposeBag)
    }
    private func bindTo() {
        let observer: AnyObserver<String> = AnyObserver{[weak self] event in
            switch event {
            case .next(let text):
                self?.navigationItem.title = text
            default:
                break
            }
        }
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{"当前索引是\($0)"}
        observable.subscribe(observer).disposed(by: disposeBag)
    }
}
