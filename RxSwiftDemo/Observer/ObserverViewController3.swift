//
//  ObserverViewController3.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//
/**
 基本介绍
 （1）相较于 AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
 不会处理错误事件
 确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
 （2）一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
 */
import UIKit
import RxSwift
import RxCocoa

class ObserverViewController3: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension ObserverViewController3 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1, indexPath.row == 0 {
            binder_01()
        }
        if indexPath.section == 2, indexPath.row == 0 {
            binder_02()
        }
        if indexPath.section == 2, indexPath.row == 1 {
            binder_03()
        }
    }
}
// MARK: - 私有方法
extension ObserverViewController3 {
    private func binder_01() {
        let observer: Binder<String> = Binder(navigationItem) { (navigationItem, title) in
            navigationItem.title = title
        }
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{"当前索引是\($0)"}.subscribe(observer).disposed(by: disposeBag)
    }
    private func binder_02() {
        var font: UIFont
        if let titleTextAttributes = navigationController?.navigationBar.titleTextAttributes  {
            font = NSMutableDictionary(dictionary: titleTextAttributes).value(forKey: NSAttributedString.Key.font.rawValue) as! UIFont
        }else {
            font = UIFont.systemFont(ofSize: 17)
        }
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{
            UIFont.systemFont(ofSize: CGFloat($0) + font.pointSize)
            }.bind(to: navigationController!.navigationBar.titleFont).disposed(by: disposeBag)
    }
    private func binder_03() {
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{
            [UIColor.red, UIColor.orange][$0 % 2]
            }.bind(to: navigationController!.navigationBar.rx.barTintColor).disposed(by: disposeBag)
    }
}

/// 自定义可绑定属性 (通过对 UI 类进行扩展)
extension UINavigationBar {
    public var titleFont: Binder<UIFont> {
        return Binder(self){
            (bar, font) in
            let titleTextAttributes: NSMutableDictionary
            if bar.titleTextAttributes == nil {
                titleTextAttributes = NSMutableDictionary()
            }else {
                titleTextAttributes = NSMutableDictionary(dictionary: bar.titleTextAttributes!)
            }
            titleTextAttributes.setValue(font, forKey: NSAttributedString.Key.font.rawValue)
            bar.titleTextAttributes = (titleTextAttributes as! [NSAttributedString.Key : Any])
        }
    }
}

/// 自定义可绑定属性 (通过对 Reactive 类进行扩展)
extension Reactive where Base: UINavigationBar {
    public var barTintColor: Binder<UIColor> {
        return Binder(self.base){
            (bar, color) in
            bar.barTintColor = color
        }
    }
}

