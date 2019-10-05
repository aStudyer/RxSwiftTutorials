//
//  RxMoya2DetailVC.swift
//  RxSwiftDemo
//
//  Created by 王翔 on 2019/10/5.
//  Copyright © 2019 com.cc. All rights reserved.
//

import UIKit

class RxMoya2DetailVC1: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        
        //获取列表数据
        let data = DouBanProvider.rx.request(.channels)
            .mapJSON()
            .map{ data -> [[String: Any]] in
                if let json = data as? [String: Any],
                    let channels = json["channels"] as? [[String: Any]] {
                    return channels
                }else{
                    return []
                }
            }.asObservable()
        
        //将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element["name"]!)"
            cell.accessoryType = .disclosureIndicator
            return cell
            }.disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.modelSelected([String: Any].self)
            .map{
                "\($0["channel_id"] ?? "")"
            }
            .flatMap{
                DouBanProvider.rx.request(.playlist($0))
            }
            .mapJSON()
            .subscribe(onNext: {[weak self] data in
                //解析数据，获取歌曲信息
                if let json = data as? [String: Any],
                    let musics = json["song"] as? [[String: Any]]{
                    let artist = musics[0]["artist"]!
                    let title = musics[0]["title"]!
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
