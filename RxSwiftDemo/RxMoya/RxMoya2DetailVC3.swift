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

fileprivate class DouBanNetworkService {
    
    //获取频道数据
    func loadChannels() -> Observable<[Channel]> {
        return DouBanProvider.rx.request(.channels)
            .mapObject(Douban.self)
            .map{ $0.channels ?? [] }
            .asObservable()
    }
    
    //获取歌曲列表数据
    func loadPlaylist(channelId:String) -> Observable<Playlist> {
        return DouBanProvider.rx.request(.playlist(channelId))
            .mapObject(Playlist.self)
            .asObservable()
    }
    
    //获取频道下第一首歌曲
    func loadFirstSong(channelId:String) -> Observable<Song> {
        return loadPlaylist(channelId: channelId)
            .filter{ $0.song.count > 0}
            .map{ $0.song[0] }
    }
}

class RxMoya2DetailVC3: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        
        //豆瓣网络请求服务
        let networkService = DouBanNetworkService()
        
        //获取列表数据
        let data = networkService.loadChannels()
        
        //将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element.name!)"
            cell.accessoryType = .disclosureIndicator
            return cell
            }.disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.modelSelected(Channel.self)
            .map{
                guard let channelId = $0.channelId else {
                    return "0"
                }
                return channelId
            }
            .flatMap(networkService.loadFirstSong)
            .subscribe(onNext: {[weak self] song in
                //将歌曲信息弹出显示
                let message = "歌手：\(song.artist!)\n歌曲：\(song.title!)"
                self?.showAlert(title: "歌曲信息", message: message)
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
    
    init?(map: Map) {}
    
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
