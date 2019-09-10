//
//  RXGestureRecognizerDetail.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit

class RXGestureRecognizerDetail: BaseViewController {
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch indexPath.row {
        case 0:
            demo01()
        case 1:
            demo02()
        case 2:
            demo03()
            
        default:
            break
        }
    }
    
}

extension RXGestureRecognizerDetail {
    private func demo01() {
        //添加一个上滑手势
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        //手势响应
        swipe.rx.event
            .subscribe(onNext: { [weak self] recognizer in
                //这个点是滑动的起点
                let point = recognizer.location(in: recognizer.view)
                self?.showAlert(title: "向上划动", message: "\(point.x) \(point.y)")
            })
            .disposed(by: disposeBag)
    }
    
    private func demo02() {
        //添加一个上滑手势
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        //手势响应
        swipe.rx.event
            .bind { [weak self] recognizer in
                //这个点是滑动的起点
                let point = recognizer.location(in: recognizer.view)
                self?.showAlert(title: "向上划动", message: "\(point.x) \(point.y)")
            }
            .disposed(by: disposeBag)
    }
    
    private func demo03() {
        //添加一个点击手势
        let tapBackground = UITapGestureRecognizer()
        view.addGestureRecognizer(tapBackground)
        
        //页面上任意处点击，输入框便失去焦点
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}

extension RXGestureRecognizerDetail {
    //显示消息提示框
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alert, animated: true)
    }
}
