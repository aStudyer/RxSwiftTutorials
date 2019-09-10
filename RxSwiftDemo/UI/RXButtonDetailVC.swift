
//
//  RXButtonDetailVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RXButtonDetailVC: BaseViewController {
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        switch indexPath.row {
        case 0:
            demo_01()
        case 1:
            demo_02()
        case 2:
            demo_03()
        case 3:
            demo_04()
        case 4:
            demo_05()
        case 5:
            demo_06()
            
        default:
            break
        }
    }
}
// MARK: - 私有方法
extension RXButtonDetailVC {
    /// 按钮点击响应
    private func demo_01() {
        //按钮点击响应
//        button.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.showMessage("按钮被点击")
//            })
//            .disposed(by: disposeBag)
        button.rx.tap
            .bind {[weak self] in
                self?.showMessage("按钮被点击了")
            }
            .disposed(by: disposeBag)
    }
    /// 按钮标题（title）的绑定
    private func demo_02() {
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //根据索引数拼接最新的标题，并绑定到button上
        timer.map{"计数\($0)"}
            .bind(to: button.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    /// 按钮富文本标题（attributedTitle）的绑定
    private func demo_03() {
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //将已过去的时间格式化成想要的字符串，并绑定到button上
        timer.map{ [weak self] in
            return self?.formatTimeInterval(ms: $0)
            }
            .bind(to: button.rx.attributedTitle())
            .disposed(by: disposeBag)
    }
    /// 按钮图标（image）的绑定
    private func demo_04() {
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //将已过去的时间格式化成想要的字符串，并绑定到button上
        timer.map{
            let name = $0 % 2 == 0 ? "dianzan" : "xingji"
            return UIImage(named: name)!
            }
            .bind(to: button.rx.image())
            .disposed(by: disposeBag)
    }
    /// 按钮背景颜色的绑定
    private func demo_05() {
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //将已过去的时间格式化成想要的字符串，并绑定到button上
        timer.map{
            return $0 % 2 == 0 ? UIColor.red : UIColor.orange
            }
            .bind(to: button.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    /// 按钮是否选中（isSelected）的绑定
    private func demo_06() {
        //默认选中第一个按钮
        button1.isSelected = true
        
        //强制解包，避免后面还需要处理可选类型
        let buttons = [button1, button2, button3].map { $0! }
        
        //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selectedButton = Observable.from(
            buttons.map { button in button.rx.tap.map { button } }
            ).merge()
        //对于每一个按钮都对selectedButton进行订阅，根据它是否是当前选中的按钮绑定isSelected属性
        for button in buttons {
            selectedButton.map { $0 == button }
                .bind(to: button.rx.isSelected)
                .disposed(by: disposeBag)
        }
    }
}
// MARK: - 其他方法
extension RXButtonDetailVC {
    //显示消息提示框
    private func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //将数字转成对应的富文本
    private func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
}
