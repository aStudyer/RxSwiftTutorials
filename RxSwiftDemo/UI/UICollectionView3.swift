//
//  UICollectionView3.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
/*
 防止集合视图多次刷新的说明
 （1）flatMapLatest 的作用是：当在短时间内（上一个请求还没回来）连续点击多次“刷新”按钮，虽然仍会发起多次请求，但 collectionView 只会接收并显示最后一次请求。避免集合视图出现连续刷新的现象。

 //随机的表格数据
 let randomResult = refreshButton.rx.tap.asObservable()
 .startWith(()) //加这个为了让一开始就能自动请求一次数据
 .flatMapLatest(getRandomResult) //连续请求时只取最后一次数据
 .share(replay: 1)
 
 （2）也可以改用 flatMapFirst 来防止表格多次刷新，它与 flatMapLatest 刚好相反，如果连续发起多次请求，表格只会接收并显示第一次请求。

 //随机的表格数据
 let randomResult = refreshButton.rx.tap.asObservable()
 .startWith(()) //加这个为了让一开始就能自动请求一次数据
 .flatMapFirst(getRandomResult)  //连续请求时只取第一次数据
 .share(replay: 1)
 
 （3）我们还可以在源头进行限制下。即通过 throttle 设置个阀值（比如 1 秒），如果在 1 秒内有多次点击则只取最后一次，那么自然也就只发送一次数据请求。

 //随机的表格数据
 let randomResult = refreshButton.rx.tap.asObservable()
 .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
 .startWith(()) //加这个为了让一开始就能自动请求一次数据
 .flatMapLatest(getRandomResult)
 .share(replay: 1)
 */
class UICollectionView3: BaseViewController {
    //刷新按钮
    let refreshButton: UIBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: nil, action: nil)
    //停止按钮
    let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "停止", style: .plain, target: nil, action: nil)
    
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
        
        navigationItem.rightBarButtonItems = [refreshButton, cancelButton]
        
        //随机的表格数据
        let randomResult = refreshButton.rx.tap.asObservable()
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest{
                self.getRandomResult().takeUntil(self.cancelButton.rx.tap)
            }
            .share(replay: 1)
        
        //创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String, Int>>(
                configureCell: { (dataSource, collectionView, indexPath, element) in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                                  for: indexPath) as! MyCollectionViewCell
                    cell.label.text = "\(element)"
                    return cell}
        )
        
        //绑定单元格数据
        randomResult
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    //获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map {_ in
            Int(arc4random_uniform(100000))
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
}
//自定义单元格
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
