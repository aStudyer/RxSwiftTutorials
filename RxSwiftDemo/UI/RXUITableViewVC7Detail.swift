//
//  RXUITableViewVC7Detail.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RXUITableViewVC7Detail: BaseViewController {
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var dataSource:RxTableViewSectionedAnimatedDataSource<MySection2>?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
extension RXUITableViewVC7Detail {
    private func demo_01() {
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //初始化数据
        let sections = Observable.just([
            MySection2(header: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            MySection2(header: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        //创建数据源
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection2>(
            //设置单元格
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")
                    ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(ip.row)：\(item)"
                
                return cell
        },
            //设置分区头标题
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        }
        )
        
        self.dataSource = dataSource
        
        //绑定单元格数据
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //设置代理
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    private func demo_02() {
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //初始化数据
        let sections = Observable.just([
            MySection2(header: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            MySection2(header: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        //创建数据源
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection2>(
            //设置单元格
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")
                    ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(ip.row)：\(item)"
                
                return cell
        },
            //设置分区尾部标题
            titleForFooterInSection: { ds, index in
                return "共有\(ds.sectionModels[index].items.count)个控件"
        }
        )
        
        self.dataSource = dataSource
        
        //绑定单元格数据
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //设置代理
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}
// tableView代理实现
extension RXUITableViewVC7Detail: UITableViewDelegate {
    //设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            guard let _ = dataSource?[indexPath],
                let _ = dataSource?[indexPath.section]
                else {
                    return 0.0
            }
            return 100
    }
    
    //返回分区头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int)
        -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.black
            let titleLabel = UILabel()
            titleLabel.text = self.dataSource?[section].header
            titleLabel.textColor = UIColor.white
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
            headerView.addSubview(titleLabel)
            return headerView
    }
    
    //返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
        -> CGFloat {
            return 40
    }
}

//自定义Section
struct MySection2 {
    var header: String
    var items: [Item]
}

extension MySection2: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection2, items: [Item]) {
        self = original
        self.items = items
    }
}
