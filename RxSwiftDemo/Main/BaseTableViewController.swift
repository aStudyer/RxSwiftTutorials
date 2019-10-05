//
//  BaseTableViewController.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import HHUIBase_Swift

class BaseTableViewController: HHUIBase_Swift.BaseTableViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }

}
