//
//  RXURLSessionVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//
/*
 如果不需要获取底层的 response，只需知道请求是否成功，以及成功时返回的结果，那么建议使用 rx.data。
 因为 rx.data 会自动对响应状态码进行判断，只有成功的响应（状态码为 200~300）才会进入到 onNext 这个回调，否则进入 onError 这个回调。
 */
import UIKit
import RxCocoa
import RxSwift
import ObjectMapper

class RXURLSessionVC: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消请求", style: .plain, target: nil, action: nil)
    }
}
extension RXURLSessionVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0://通过 rx.response 请求数据
                demo_01()
            case 1://通过 rx.data 请求数据
                demo_02()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0://发起请求
                demo_03()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0://使用JSONSerialization将结果转成JSON对象
                demo_04()
            case 1://在订阅前就进行转换
                demo_05()
            case 2://直接使用 RxSwift 提供的 rx.json 方法去获取数据，它会直接将结果转成 JSON 对象
                demo_06()
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0://将结果映射成自定义对象
                demo_07()
            default:
                break
            }
        default:
            break
        }
    }
}
extension RXURLSessionVC {
    /// 通过 rx.response 请求数据
    private func demo_01() {
        //创建URL对象
        //成功
        let urlString = "https://www.douban.com/j/app/radio/channels"
        //失败
//        let urlString = "https://www.douban.com/j/ap/p/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.response(request: request).subscribe(onNext: {
            (response, data) in
            //判断响应结果状态码
            if 200 ..< 300 ~= response.statusCode {
                let str = String(data: data, encoding: String.Encoding.utf8)
                NSLog("请求成功！返回的数据是：\(str ?? "")")
            }else{
                NSLog("请求失败！")
            }
        }).disposed(by: disposeBag)
    }
    /// 通过 rx.data 请求数据
    private func demo_02() {
        //创建URL对象
        //成功
//        let urlString = "https://www.douban.com/j/app/radio/channels"
        //失败
        let urlString = "https://www.douban.com/j/ap/p/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.data(request: request).subscribe(onNext: {
            data in
            let str = String(data: data, encoding: String.Encoding.utf8)
            NSLog("请求成功！返回的数据是：\(str ?? "")")
        }, onError: { error in
            NSLog("请求失败！错误原因：\(error)")
        }).disposed(by: disposeBag)
    }
    /// 发起请求
    private func demo_03() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        //发起请求按钮点击
        URLSession.shared.rx.data(request: request)
            .delaySubscription(3, scheduler: MainScheduler.instance)
            .takeUntil(navigationItem.rightBarButtonItem!.rx.tap) //如果“取消按钮”点击则停止请求
            .subscribe(onNext: {
                data in
                let str = String(data: data, encoding: String.Encoding.utf8)
                NSLog("请求成功！返回的数据是：\(str ?? "")")
            }, onError: { error in
                NSLog("请求失败！错误原因：\(error)")
            }).disposed(by: disposeBag)
    }
    /// 使用JSONSerialization将结果转成JSON对象
    private func demo_04() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.data(request: request).subscribe(onNext: {
            data in
            let json = try? (JSONSerialization.jsonObject(with: data, options: .allowFragments)
                as! [String: Any])
            NSLog("请求成功！返回的数据是：\(String(describing: json))")
        }).disposed(by: disposeBag)
    }
    /// 在订阅前就进行转换
    private func demo_05() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.data(request: request)
            .map {
                try JSONSerialization.jsonObject(with: $0, options: .allowFragments)
                    as! [String: Any]
            }
            .subscribe(onNext: {
                json in
                NSLog("请求成功！返回的数据是：\(String(describing: json))")
            }).disposed(by: disposeBag)
    }
    /// 直接使用 RxSwift 提供的 rx.json 方法去获取数据，它会直接将结果转成 JSON 对象
    private func demo_06() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.json(request: request).subscribe(onNext: {
            data in
            let json = data as! [String: Any]
            NSLog("请求成功！返回的数据是：\(String(describing: json))")
        }).disposed(by: disposeBag)
    }
    /// 将结果映射成自定义对象
    private func demo_07() {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.json(request: request)
            .mapObject(type: Douban.self)
            .subscribe(onNext: { (douban: Douban) in
                if let channels = douban.channels {
                    NSLog("--- 共\(channels.count)个频道 ---")
                    for channel in channels {
                        if let name = channel.name, let channelId = channel.channelId {
                            NSLog("\(name) （id:\(channelId)）")
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
}
//豆瓣接口模型
private class Douban: Mappable {
    //频道列表
    var channels: [Channel]?
    
    init(){
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        channels <- map["channels"]
    }
}

//频道模型
private class Channel: Mappable {
    var name: String?
    var nameEn:String?
    var channelId: String?
    var seqId: Int?
    var abbrEn: String?
    
    init(){
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }
}
