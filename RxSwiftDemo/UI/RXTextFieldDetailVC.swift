//
//  RXTextFieldDetailVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXTextFieldDetailVC: BaseViewController {
    @IBOutlet weak var tf_1: UITextField!
    @IBOutlet weak var tf_2: UITextField!
    @IBOutlet weak var l_count: UILabel!
    @IBOutlet weak var b_commit: UIButton!
    @IBOutlet weak var textView: UITextView!
    
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
        case 3:
            demo04()
        case 4:
            demo05()
        default:
            break
        }
    }
}
// MARK: - 私有方法
extension RXTextFieldDetailVC {
    /// 监听单个 textField 内容的变化（textView 同理）
    /// 注意：.orEmpty 可以将 String? 类型的 ControlProperty 转成 String，省得我们再去解包。
    private func demo01() {
//        //当文本框内容改变时，将内容输出到控制台上
//        tf_1.rx.text.orEmpty.asObservable()
//            .subscribe(onNext: {
//                print("您输入的是：\($0)")
//            })
//            .disposed(by: disposeBag)
        //当然我们直接使用 change 事件效果也是一样的
        tf_1.rx.text.orEmpty.changed
            .subscribe(onNext: {
                print("您输入的是：\($0)")
            })
            .disposed(by: disposeBag)
    }
    /// 将内容绑定到其他控件上
    private func demo02() {
        //当文本框内容改变
        let input = tf_1.rx.text.orEmpty.asDriver() // 将普通序列转换为 Driver
            .throttle(0.3) //在主线程中操作，0.3秒内值若多次改变，取最后一次
        
        //内容绑定到另一个输入框中
        input.drive(tf_2.rx.text)
            .disposed(by: disposeBag)
        
        //内容绑定到文本标签中
        input.map{ "当前字数：\($0.count)" }
            .drive(l_count.rx.text)
            .disposed(by: disposeBag)
        
        //根据内容字数决定按钮是否可用
        input.map{ $0.count > 5 }
            .drive(b_commit.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    /// 同时监听多个 textField 内容的变化（textView 同理）
    private func demo03() {
        Observable.combineLatest(tf_1.rx.text.orEmpty, tf_2.rx.text.orEmpty) {
            textValue1, textValue2 -> String in
            return "你输入的内容是：\(textValue1)-\(textValue2)"
            }
            .bind(to: l_count.rx.text)
            .disposed(by: disposeBag)
    }
    /**
     通过 rx.controlEvent 可以监听输入框的各种事件，且多个事件状态可以自由组合。除了各种 UI 控件都有的 touch 事件外，输入框还有如下几个独有的事件：
     editingDidBegin：开始编辑（开始输入内容）
     editingChanged：输入内容发生改变
     editingDidEnd：结束编辑
     editingDidEndOnExit：按下 return 键结束编辑
     allEditingEvents：包含前面的所有编辑相关事件
     */
    private func demo04() {
        //在输入框1中按下 return 键 焦点自动转移到输入框2上
        tf_1.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            [weak self] (_) in
            self?.tf_2.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        //在输入框2中按下 return 键 自动移除焦点
        tf_2.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            [weak self] (_) in
            self?.tf_2.resignFirstResponder()
        }).disposed(by: disposeBag)
    }
    /// UITextView 独有的方法
    private func demo05() {
        //开始编辑响应
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
            })
            .disposed(by: disposeBag)
        
        //结束编辑响应
        textView.rx.didEndEditing
            .subscribe(onNext: {
                print("结束编辑")
            })
            .disposed(by: disposeBag)
        
        //内容发生变化响应
        textView.rx.didChange
            .subscribe(onNext: {
                print("内容发生改变")
            })
            .disposed(by: disposeBag)
        
        //选中部分变化响应
        textView.rx.didChangeSelection
            .subscribe(onNext: {
                print("选中部分发生变化")
            })
            .disposed(by: disposeBag)
    }
}
