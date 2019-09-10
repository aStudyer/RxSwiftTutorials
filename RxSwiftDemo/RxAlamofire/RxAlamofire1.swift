//
//  RxAlamofire1.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class RxAlamofire1: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消请求", style: .plain, target: nil, action: nil)
    }
}
extension RxAlamofire1 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                demo_01()
            case 1:
                demo_02()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                demo_03()
            case 1:
                demo_04()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                demo_05()
            default:
                break
            }
        default:
            break
        }
    }
}
extension RxAlamofire1 {
    /// 使用 request 请求数据
    private func demo_01() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        request(.get, url)
            .data()
            .subscribe(onNext: {
                data in
                //数据处理
                let str = String(data: data, encoding: String.Encoding.utf8)
                NSLog("返回的数据是：\(str ?? "")")
            }, onError: { error in
                NSLog("请求失败！错误原因：\(error)")
            }).disposed(by: disposeBag)
    }
    /// 使用 requestData 请求数据
    private func demo_02() {
        /*
         使用 requestData 的话，不管请求成功与否都会进入到 onNext 这个回调中。如果我们想要根据响应状态进行一些相应操作，通过 response 参数即可实现。
        */
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
//        let urlString = "https://www.douban.com/jxxxxxxx/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        requestData(.get, url).subscribe(onNext: {
            response, data in
            //判断响应结果状态码
            if 200 ..< 300 ~= response.statusCode {
                let str = String(data: data, encoding: String.Encoding.utf8)
                NSLog("请求成功！返回的数据是：\(str ?? "")")
            }else{
                NSLog("请求失败！")
            }
        }).disposed(by: disposeBag)
    }
    /// 如果请求的数据是字符串类型的，我们可以在 request 请求时直接通过 responseString() 方法实现自动转换，省的在回调中还要手动将 data 转为 string
    private func demo_03() {
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        request(.get, url)
            .responseString()
            .subscribe(onNext: {
                response, data in
                //数据处理
                NSLog("返回的数据是：\(data)")
            }).disposed(by: disposeBag)
    }
    /// 更简单的方法就是直接使用 requestString 去获取数据
    private func demo_04() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        requestString(.get, url)
            .subscribe(onNext: {
                response, data in
                //数据处理
                NSLog("返回的数据是：\(data)")
            }).disposed(by: disposeBag)
    }
    /// 发起请求
    private func demo_05() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //发起请求按钮点击
        request(.get, url).responseString()
            .delaySubscription(3, scheduler: MainScheduler.instance)
            .takeUntil(navigationItem.rightBarButtonItem!.rx.tap) //如果“取消按钮”点击则停止请求
            .subscribe(onNext: {
                response, data in
                print("请求成功！返回的数据是：", data)
            }, onError: { error in
                print("请求失败！错误原因：", error)
            }).disposed(by: disposeBag)
    }
}
