//
//  RXPickerView.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RXPickerView: BaseViewController {
     @IBOutlet weak var pickerView: UIPickerView!
    //单列
    private let stringPickerAdapter1 = RxPickerViewStringAdapter<[String]>(
        components: [],
        numberOfComponents: { _,_,_  in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count},
        titleForRow: { (_, _, items, row, _) -> String? in
            return items[row]}
    )
    //多列
    private let stringPickerAdapter2 = RxPickerViewStringAdapter<[[String]]>(
        components: [],
        numberOfComponents: { dataSource,pickerView,components  in components.count },
        numberOfRowsInComponent: { (_, _, components, component) -> Int in
            return components[component].count},
        titleForRow: { (_, _, components, row, component) -> String? in
            return components[component][row]}
    )
    //设置文字属性的pickerView适配器
    private let attrStringPickerAdapter = RxPickerViewAttributedStringAdapter<[String]>(
        components: [],
        numberOfComponents: { _,_,_  in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count}
    ){ (_, _, items, row, _) -> NSAttributedString? in
        return NSAttributedString(string: items[row],
                                  attributes: [
                                    NSAttributedString.Key.foregroundColor: UIColor.orange, //橙色文字
                                    NSAttributedString.Key.underlineStyle:
                                        NSUnderlineStyle.double.rawValue, //双下划线
                                    NSAttributedString.Key.textEffect:
                                        NSAttributedString.TextEffectStyle.letterpressStyle
            ])
    }
    //设置自定义视图的pickerView适配器
    private let viewPickerAdapter = RxPickerViewViewAdapter<[UIColor]>(
        components: [],
        numberOfComponents: { _,_,_  in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count}
    ){ (_, _, items, row, _, view) -> UIView in
        let componentView = view ?? UIView()
        componentView.backgroundColor = items[row]
        return componentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //触摸按钮时，获得被选中的索引
    @objc private func getPickerViewValue1(){
        let message = String(pickerView.selectedRow(inComponent: 0))
        let alertController = UIAlertController(title: "被选中的索引为",
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @objc private func getPickerViewValue2(){
        let message = String(pickerView.selectedRow(inComponent: 0)) + "-"
            + String(pickerView!.selectedRow(inComponent: 1))
        let alertController = UIAlertController(title: "被选中的索引为",
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    /// 基本用法:单列
    @IBAction func demo_01(_ sender: UIButton) {
        pickerView.dataSource = nil
        pickerView.delegate = nil
        //绑定pickerView数据
        Observable.just(["One", "Two", "Tree"])
            .bind(to: pickerView.rx.items(adapter: stringPickerAdapter1))
            .disposed(by: disposeBag)
        getPickerViewValue1()
    }
    /// 基本用法:多列
    @IBAction func demo_02(_ sender: UIButton) {
        pickerView.dataSource = nil
        pickerView.delegate = nil
        //绑定pickerView数据
        Observable.just([["One", "Two", "Tree"],
                         ["A", "B", "C", "D"]])
            .bind(to: pickerView.rx.items(adapter: stringPickerAdapter2))
            .disposed(by: disposeBag)
        getPickerViewValue2()
    }
    /// 修改默认的样式
    @IBAction func demo_03(_ sender: UIButton) {
        pickerView.dataSource = nil
        pickerView.delegate = nil
        //绑定pickerView数据
        Observable.just(["One", "Two", "Tree"])
            .bind(to: pickerView.rx.items(adapter: attrStringPickerAdapter))
            .disposed(by: disposeBag)
    }
    /// 使用自定义视图
    @IBAction func demo_04(_ sender: UIButton) {
        pickerView.dataSource = nil
        pickerView.delegate = nil
        //绑定pickerView数据
        Observable.just([UIColor.red, UIColor.orange, UIColor.yellow])
            .bind(to: pickerView.rx.items(adapter: viewPickerAdapter))
            .disposed(by: disposeBag)
    }
}
