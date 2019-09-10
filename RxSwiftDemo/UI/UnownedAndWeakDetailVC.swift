//
//  UnownedAndWeakDetailVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit

class UnownedAndWeakDetailVC: BaseViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.rx.text.orEmpty.asDriver().drive(onNext: { [weak self]
            text in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                NSLog("当前输入内容：\(String(describing: text))")
                self?.label.text = text
            }
        }).disposed(by: disposeBag)
    }

}
