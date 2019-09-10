//
//  UICollectionView2Detail.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UICollectionView2Detail: BaseViewController {
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                demo_01()
            case 1:
                demo_02()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                demo_03()
            case 1:
                demo_04()
            default:
                break
            }
        default:
            break
        }
    }
}
extension UICollectionView2Detail {
    /// 单分区的 CollectionView 使用自带的 Section
    private func demo_01() {
        //初始化数据
        let items = Observable.just([
            SectionModel(model: "", items: [
                "Swift",
                "PHP",
                "Python",
                "Java",
                "javascript",
                "C#"
                ])
            ])
        
        //创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String, String>>(
                configureCell: { (dataSource, collectionView, indexPath, element) in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                                  for: indexPath) as! MyCollectionViewCell
                    cell.label.text = "\(element)"
                    return cell}
        )
        
        //绑定单元格数据
        items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    /// 单分区的 CollectionView 使用自定义的 Section
    private func demo_02() {
        //初始化数据
        let sections = Observable.just([
            MySection(header: "", items: [
                "Swift",
                "PHP",
                "Python",
                "Java",
                "javascript",
                "C#"
                ])
            ])
        
        //创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<MySection>(
            configureCell: { (dataSource, collectionView, indexPath, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                              for: indexPath) as! MyCollectionViewCell
                cell.label.text = "\(element)"
                return cell}
        )
        
        //绑定单元格数据
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
extension UICollectionView2Detail {
    /// 多分区的 CollectionView 使用自带的 Section
    private func demo_03() {
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
        //创建一个重用的分区头
        collectionView.register(MySectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "Section")
        //初始化数据
        let items = Observable.just([
            SectionModel(model: "脚本语言", items: [
                "Python",
                "javascript",
                "PHP",
                ]),
            SectionModel(model: "高级语言", items: [
                "Swift",
                "C++",
                "Java",
                "C#"
                ])
            ])
        
        //创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String, String>>(
                configureCell: { (dataSource, collectionView, indexPath, element) in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                                  for: indexPath) as! MyCollectionViewCell
                    cell.label.text = "\(element)"
                    return cell},
                configureSupplementaryView: {
                    (ds ,cv, kind, ip) in
                    let section = cv.dequeueReusableSupplementaryView(ofKind: kind,
                                                                      withReuseIdentifier: "Section", for: ip) as! MySectionHeader
                    section.label.text = "\(ds[ip.section].model)"
                    return section
            })
        
        //绑定单元格数据
        items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    /// 多分区的 CollectionView 使用自定义的 Section
    private func demo_04() {
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
        //创建一个重用的分区头
        collectionView.register(MySectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "Section")
        //初始化数据
        let sections = Observable.just([
            MySection(header: "脚本语言", items: [
                "Python",
                "javascript",
                "PHP",
                ]),
            MySection(header: "高级语言", items: [
                "Swift",
                "C++",
                "Java",
                "C#"
                ])
            ])
        
        //创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<MySection>(
            configureCell: { (dataSource, collectionView, indexPath, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                              for: indexPath) as! MyCollectionViewCell
                cell.label.text = "\(element)"
                return cell},
            configureSupplementaryView: {
                (ds ,cv, kind, ip) in
                let section = cv.dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: "Section", for: ip) as! MySectionHeader
                section.label.text = "\(ds[ip.section].header)"
                return section
        })
        
        //绑定单元格数据
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
class MySectionHeader: UICollectionReusableView {
    var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //背景设为黑色
        self.backgroundColor = UIColor.black
        
        //创建文本标签
        label = UILabel(frame: frame)
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
