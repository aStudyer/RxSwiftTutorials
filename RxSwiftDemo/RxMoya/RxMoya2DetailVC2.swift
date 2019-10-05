//
//  RxMoya2DetailVC2.swift
//  RxSwiftDemo
//
//  Created by 王翔 on 2019/10/5.
//  Copyright © 2019 com.cc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import Moya_ObjectMapper

class RxMoya2DetailVC2: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        
        //获取列表数据
        let data = DouBanProvider.rx.request(.channels)
            .mapObject(Douban.self)
            .map{ $0.channels ?? [] }
            .asObservable()
        
        //将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element.name!)"
            cell.accessoryType = .disclosureIndicator
            return cell
            }.disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.modelSelected(Channel.self)
            .map{ $0.channelId! }
            .flatMap{ DouBanProvider.rx.request(.playlist($0)) }
            .mapObject(Playlist.self)
            .subscribe(onNext: {[weak self] playlist in
                //解析数据，获取歌曲信息
                if playlist.song.count > 0 {
                    let artist = playlist.song[0].artist!
                    let title = playlist.song[0].title!
                    let message = "歌手：\(artist)\n歌曲：\(title)"
                    //将歌曲信息弹出显示
                    self?.showAlert(title: "歌曲信息", message: message)
                }
            }).disposed(by: disposeBag)
    }
    //显示消息
    private func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//豆瓣接口模型
fileprivate struct Douban: Mappable {
    //频道列表
    var channels: [Channel]?
    
    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map: Map) {
        channels <- map["channels"]
    }
}

//频道模型
fileprivate struct Channel: Mappable {
    var name: String?
    var nameEn:String?
    var channelId: String?
    var seqId: Int?
    var abbrEn: String?
    
    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }
}

//歌曲列表模型
fileprivate struct Playlist: Mappable {
    var r: Int!
    var isShowQuickStart: Int!
    var song:[Song]!
    
    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map: Map) {
        r <- map["r"]
        isShowQuickStart <- map["is_show_quick_start"]
        song <- map["song"]
    }
}

//歌曲模型
fileprivate struct Song: Mappable {
    var title: String!
    var artist: String!
    
    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map: Map) {
        title <- map["title"]
        artist <- map["artist"]
    }
}
