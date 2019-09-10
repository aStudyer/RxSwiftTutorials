//
//  BaseViewController.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        print("welcome to \(self)")
    }
    
    deinit {
        print("\(self) --- deinit")
    }

}
