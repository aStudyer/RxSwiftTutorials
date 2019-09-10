//
//  RxAlamofire2Detail.swift
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

class RxAlamofire2Detail: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.tableFooterView = UIView()
        //创建一个重用的单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //获取列表数据
        let data = requestJSON(.get, url)
            .map{$1}
            .mapObject(type: Douban.self)
            .map{ $0.channels ?? []}
        
        //将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row)：\(element.name!)"
            return cell
            }.disposed(by: disposeBag)
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
