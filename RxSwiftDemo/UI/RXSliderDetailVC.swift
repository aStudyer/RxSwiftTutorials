//
//  RXSliderDetailVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXSliderDetailVC: BaseViewController {
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    @IBOutlet weak var mySlider: UISlider!
    @IBOutlet weak var myStepper: UIStepper!
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "步长", style: .plain, target: self, action: #selector(log))
        switch indexPath.row {
        case 0:
            demo_01()
        case 1:
            demo_02()
            
        default:
            break
        }
    }
}
extension RXSliderDetailVC {
    /// UISlider（滑块）
    private func demo_01() {
        mySlider.rx.value.map{"当前值为：\($0)"}
            .bind(to: myLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    /// UIStepper（步进器）
    private func demo_02() {
        mySlider.rx.value
            .map{ Double($0) }  //由于slider值为Float类型，而stepper的stepValue为Double类型，因此需要转换
            .bind(to: myStepper.rx.stepValue)
            .disposed(by: disposeBag)
    }
    @objc func log() {
        NSLog("stepValue = \(myStepper.value)")
    }
}
