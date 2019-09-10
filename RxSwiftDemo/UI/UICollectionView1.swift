//
//  UICollectionView1.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UICollectionView1: BaseViewController {
    //定义布局方式以及单元格大小
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        return flowLayout
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建一个重用的单元格
        self.collectionView.register(MyCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(self.collectionView)
        
        //初始化数据
        let items = Observable.just([
            "Swift",
            "PHP",
            "Ruby",
            "Java",
            "C++",
            ])
        
        //设置单元格数据（其实就是对 cellForItemAt 的封装）
        items
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                              for: indexPath) as! MyCollectionViewCell
                cell.label.text = "\(row)：\(element)"
                return cell
            }
            .disposed(by: disposeBag)
        
        //获取选中项的索引
        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            NSLog("选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取选中项的内容
        collectionView.rx.modelSelected(String.self).subscribe(onNext: { item in
            NSLog("选中项的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        // 如果想要同时获取选中项的索引，以及内容可以这么写：
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(String.self))
            .bind { indexPath, item in
                NSLog("选中项的indexPath为：\(indexPath)")
                NSLog("选中项的标题为：\(item)")
            }
            .disposed(by: disposeBag)
        
        //获取被取消选中项的索引
        collectionView.rx.itemDeselected.subscribe(onNext: { indexPath in
            NSLog("被取消选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取被取消选中项的内容
        collectionView.rx.modelDeselected(String.self).subscribe(onNext: { item in
            NSLog("被取消选中项的的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        //获取选中并高亮完成后的索引
        collectionView.rx.itemHighlighted.subscribe(onNext: { indexPath in
            NSLog("高亮单元格的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取高亮转成非高亮完成后的索引
        collectionView.rx.itemUnhighlighted.subscribe(onNext: { indexPath in
            NSLog("失去高亮的单元格的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //分区头部、尾部将要显示出来的事件响应
        collectionView.rx.willDisplaySupplementaryView.subscribe(onNext: { view, kind, indexPath in
            NSLog("将要显示分区indexPath为：\(indexPath)")
            NSLog("将要显示的是头部还是尾部：\(kind)")
            NSLog("将要显示头部或尾部视图：\(view)\n")
        }).disposed(by: disposeBag)
    }
}

private class MyCollectionViewCell: UICollectionViewCell {
    var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //背景设为橙色
        self.backgroundColor = UIColor.orange
        
        //创建文本标签
        label = UILabel(frame: frame)
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
