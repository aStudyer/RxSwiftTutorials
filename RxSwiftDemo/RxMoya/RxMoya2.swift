//
//  RxMoya2.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import HHUIBase_Swift
import RxSwift
import RxCocoa

class RxMoya2: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Header Methods
extension RxMoya2 {
    
}

// MARK: - Cell Methods
extension RxMoya2 {
    @objc private func row_00_00(_ item: HHRowModel) {
        //获取数据
        DouBanProvider.rx.request(.channels)
            .subscribe(onSuccess: { response in
                //数据处理
                let json = try! response.mapJSON() as! [String: Any]
                print("--- 请求成功！返回的如下数据 ---")
                print(json)
            },onError: { error in
                print("数据请求失败!错误原因：", error)
                
            }).disposed(by: disposeBag)
    }
    @objc private func row_00_01(_ item: HHRowModel) {
        //获取数据
        DouBanProvider.rx.request(.channels)
            .mapJSON()
            .subscribe(onSuccess: { data in
                //数据处理
                let json = data as! [String: Any]
                print("--- 请求成功！返回的如下数据 ---")
                print(json)
            },onError: { error in
                print("数据请求失败!错误原因：", error)
                
            }).disposed(by: disposeBag)
    }
}
