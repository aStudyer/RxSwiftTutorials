//
//  BaseViewController.swift
//  HHUIBase_Swift_Example
//
//  Created by 王翔 on 2019/9/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to \(type(of: self))")
        view.backgroundColor = UIColor.white
    }
    deinit {
        print("\(type(of: self)) is deinit")
    }
}
