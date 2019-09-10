//
//  RXDatePicker.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXDatePicker: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func btn1_click(_ sender: Any) {
        datePicker.rx.date
            .map { [weak self] in
                "当前选择时间: " + self!.dateFormatter.string(from: $0)
            }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    // 剩余时间
    let leftTime = BehaviorRelay<TimeInterval>(value: TimeInterval(60))
    //当前倒计时是否结束
    let countDownStopped = BehaviorRelay<Bool>(value: true)
    
    @IBAction func btn2_click(_ sender: UIButton) {
        //剩余时间与datepicker做双向绑定
        DispatchQueue.main.async{
            _ = self.datePicker.rx.countDownDuration <-> self.leftTime
        }
        
        //绑定button标题
        Observable.combineLatest(leftTime.asObservable(), countDownStopped.asObservable()) {
            leftTimeValue, countDownStoppedValue in
            //根据当前的状态设置按钮的标题
            if countDownStoppedValue {
                return "开始"
            }else{
                return "剩余\(Int(leftTimeValue))秒"
            }
            }.bind(to: sender.rx.title())
            .disposed(by: disposeBag)
        
        //绑定button和datepicker状态（在倒计过程中，按钮和时间选择组件不可用）
        countDownStopped.asDriver().drive(datePicker.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(sender.rx.isEnabled).disposed(by: disposeBag)
        
        //按钮点击响应
        sender.rx.tap
            .bind { [weak self] in
                self?.startClicked()
            }
            .disposed(by: disposeBag)
    }
    //开始倒计时
    func startClicked() {
        //开始倒计时
        self.countDownStopped.accept(false)
        
        //创建一个计时器
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(countDownStopped.asObservable().filter{ $0 }) //倒计时结束时停止计时器
            .subscribe {[weak self] event in
                //每次剩余时间减1
                self?.leftTime.accept((self?.leftTime.value ?? 1) - 1)
                // 如果剩余时间小于等于0
                if(self?.leftTime.value == 0) {
                    NSLog("倒计时结束！")
                    //结束倒计时
                    self?.countDownStopped.accept(true)
                    //重制时间
                    self?.leftTime.accept(60)
                }
            }.disposed(by: disposeBag)
    }
    
    // 日期格式化器
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
}
