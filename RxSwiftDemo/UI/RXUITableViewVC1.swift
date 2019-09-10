//
//  RXUITableViewVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RXUITableViewVC1: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        //创建一个重用的单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //初始化数据
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法"
            ])
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        items.bind(to: tableView.rx.items){ (tableView, row, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row)：\(element)"
            return cell
        }.disposed(by: disposeBag)
        
        //获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            NSLog("选中项的indexPath为1：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取选中项的内容
        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            NSLog("选中项的标题为1：\(item)")
        }).disposed(by: disposeBag)
        
        //同时获取选中项的索引及内容
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind { indexPath, item in
                NSLog("选中项的indexPath为2：\(indexPath)")
                NSLog("选中项的标题为2：\(item)")
            }
            .disposed(by: disposeBag)
        
        //获取被取消选中项的索引
        tableView.rx.itemDeselected.subscribe(onNext: { indexPath in
            NSLog("被取消选中项的indexPath为1：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取被取消选中项的内容
        tableView.rx.modelDeselected(String.self).subscribe(onNext: { item in
            NSLog("被取消选中项的的标题为1：\(item)")
        }).disposed(by: disposeBag)
        // 同时获取
        Observable.zip(tableView.rx.itemDeselected, tableView.rx.modelDeselected(String.self))
            .bind { indexPath, item in
                NSLog("被取消选中项的indexPath为2：\(indexPath)")
                NSLog("被取消选中项的的标题为2：\(item)")
            }
            .disposed(by: disposeBag)
        
        //获取删除项的索引
        tableView.rx.itemDeleted.subscribe(onNext: { indexPath in
            NSLog("删除项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取删除项的内容
        tableView.rx.modelDeleted(String.self).subscribe(onNext: { item in
            NSLog("删除项的的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        //获取移动项的索引
        tableView.rx.itemMoved.subscribe(onNext: {
            sourceIndexPath, destinationIndexPath in
            NSLog("移动项原来的indexPath为：\(sourceIndexPath)")
            NSLog("移动项现在的indexPath为：\(destinationIndexPath)")
        }).disposed(by: disposeBag)
        
        //获取插入项的索引
        tableView.rx.itemInserted.subscribe(onNext: { indexPath in
            NSLog("插入项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取点击的尾部图标的索引
        tableView.rx.itemAccessoryButtonTapped.subscribe(onNext: { indexPath in
            NSLog("尾部项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //单元格将要显示出来的事件响应
        tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
            NSLog("将要显示单元格indexPath为：\(indexPath)")
            NSLog("将要显示单元格cell为：\(cell)\n")
        }).disposed(by: disposeBag)
    }
}
