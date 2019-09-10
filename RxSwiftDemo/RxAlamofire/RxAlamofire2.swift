//
//  RxAlamofire2.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import ObjectMapper

class RxAlamofire2: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension RxAlamofire2 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                demo_01()
            case 1:
                demo_02()
            case 2:
                demo_03()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                demo_04()
            default:
                break
            }
        default:
            break
        }
    }
}
extension RxAlamofire2 {
    /// 如果服务器返回的数据是 json 格式的话，我们可以使用 iOS 内置的 JSONSerialization 将其转成 JSON 对象，方便我们使用
    private func demo_01() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        request(.get, url)
            .data()
            .subscribe(onNext: {
                data in
                let json = try? (JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    as! [String: Any])
                NSLog("请求成功:\(json!)")
            }).disposed(by: disposeBag)
    }
    /// 在订阅前使用 responseJSON() 进行转换
    private func demo_02() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        request(.get, url)
            .responseJSON()
            .subscribe(onNext: {
                dataResponse in
                NSLog("请求成功:\(dataResponse)")
            }).disposed(by: disposeBag)
    }
    /// 直接使用 requestJSON 方法获取 JSON 数据
    private func demo_03() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        requestJSON(.get, url)
            .subscribe(onNext: {
                response, data in
                NSLog("请求成功:\(data)")
            }).disposed(by: disposeBag)
    }
    /// 将结果映射成自定义对象
    private func demo_04() {
        navigationController?.pushViewController(R.storyboard.rxAlamofire2Detail.instantiateInitialViewController()!, animated: true)
    }
}
