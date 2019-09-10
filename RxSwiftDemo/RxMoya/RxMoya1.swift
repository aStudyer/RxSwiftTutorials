//
//  RxMoya1.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxMoya1: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension RxMoya1 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
extension RxMoya1 {
    private func demo_01() {
        //获取数据
        DouBanProvider.rx.request(.channels)
            .subscribe { event in
                switch event {
                case let .success(response):
                    //数据处理
                    let str = String(data: response.data, encoding: String.Encoding.utf8)
                    NSLog("返回的数据是：\(str ?? "")")
                case let .error(error):
                    NSLog("数据请求失败!错误原因：\(error)")
                }
            }.disposed(by: disposeBag)
    }
    private func demo_02() {
        //获取数据
        DouBanProvider.rx.request(.playlist("257")).subscribe(onSuccess: { (response) in
            //数据处理
            let str = String(data: response.data, encoding: String.Encoding.utf8)
            NSLog("返回的数据是：\(str ?? "")")
        }) { (error) in
            NSLog("数据请求失败!错误原因：\(error)")
        }.disposed(by: disposeBag)
    }
}
