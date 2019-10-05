//
//  BaseTableViewController.swift
//  HHUIBase_Swift_Example
//
//  Created by 王翔 on 2019/9/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MJExtension

open class BaseTableViewController: UITableViewController, DataSourcePath {
    public var dataList: [HHSectionModel] = [] {
        didSet{
            for(sectionIndex, sectionItem) in dataList.enumerated() {
                sectionItem.section = sectionIndex
                let sectionInfo = getSectionInfo(with: sectionIndex)
                if self.responds(to: sectionInfo.selector) {
                    sectionItem.operation = { [weak self] (tableview, section) in
                        if let self = self {
                            self.performSelector(onMainThread: self.getSectionInfo(with: section).selector, with: self.dataList[section], waitUntilDone: false)
                        }
                    }
                }else {
                    print("尚未实现方法:%@",sectionInfo.selectorName)
                }
                
                for(rowIndex, rowItem) in sectionItem.items.enumerated() {
                    if let title = rowItem.title, title.count > 0 {
                        let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                        rowItem.indexPath = indexPath
                        let rowInfo = getRowInfo(with: indexPath)
                        if self.responds(to: rowInfo.selector) {
                            rowItem.operation = { [weak self] (tableView, indexPath) in
                                if let self = self {
                                    self.performSelector(onMainThread: self.getRowInfo(with: indexPath).selector, with: self.dataList[indexPath.section].items[indexPath.row], waitUntilDone: false)
                                }
                            }
                        }else {
                            print("尚未实现方法:%@",rowInfo.selectorName)
                        }
                        
                    }else{
                        sectionItem.items.remove(at: rowIndex)
                    }
                }
            }
            tableView.reloadData()
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to \(type(of: self))")
        
        view.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        
        loadDataSource()
    }
    deinit {
        print("\(type(of: self)) is deinit")
    }
}
// MARK: - UITableViewDataSource
extension BaseTableViewController {
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = dataList[section]
        return sectionItem.isOpen ? sectionItem.items.count : 0
    }
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HHTableViewCell.cell(with: tableView)
        let sectionItem = dataList[indexPath.section]
        cell.data = sectionItem.items[indexPath.row]
        return cell
    }
}
// MARK: - UITableViewDelegate
extension BaseTableViewController {
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItem = dataList[indexPath.section]
        let rowItem = sectionItem.items[indexPath.row]
        if let destVcName = rowItem.destVC, destVcName.count > 0 {
            showDestVC(destVcName, title: rowItem.title)
        }else if let operation = rowItem.operation {
            operation(tableView, indexPath)
        }
    }
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = dataList[section]
        guard let header = sectionItem.header, header.count > 0 else {
            return nil
        }
        let headerView = HHTableViewHeaderFooterView.headerFooterView(with: tableView, in: section)
        headerView.content = header
        headerView.clickBlock = { [weak self] (tableView, section) in
            guard let self = self else {
                return
            }
            let sectionItem = self.dataList[section]
            if let destVcName = sectionItem.destVC, destVcName.count > 0 {
                self.showDestVC(destVcName, title: sectionItem.header)
            }else if let operation = sectionItem.operation {
                operation(tableView, section)
            }else{
                sectionItem.isOpen = !sectionItem.isOpen
                tableView.reloadData()
            }
        }
        return headerView
    }
    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionItem = dataList[section]
        guard let footer = sectionItem.footer, footer.count > 0 else {
            return nil
        }
        let footerView = HHTableViewHeaderFooterView.headerFooterView(with: tableView, in: section)
        footerView.content = footer
        return footerView
    }
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionItem = dataList[section]
        guard let header = sectionItem.header, header.count > 0 else {
            return CGFloat.leastNormalMagnitude
        }
        return 40
    }
    open override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionItem = dataList[section]
        guard let footer = sectionItem.footer, footer.count > 0 else {
            return CGFloat.leastNormalMagnitude
        }
        return 40
    }
}
extension BaseTableViewController {
    private func showDestVC(_ destVcName: String, title: String?){
        var destVC: UIViewController?
        if Bundle.main.path(forResource: destVcName, ofType: "storyboard") != nil {
            destVC = UIStoryboard(name: destVcName, bundle: nil).instantiateInitialViewController()
        } else if let nameSpace = Utils.getNameSpace(), let destVcType = NSClassFromString(nameSpace + "." +  destVcName) as? UIViewController.Type {
            destVC = destVcType.init()
        }
        if let destVC = destVC {
            destVC.title = title
            show(destVC, sender: nil)
        }
    }
    private func getSectionInfo(with section: NSInteger) -> (selectorName: String, selector: Selector) {
        let selectorName = String(format: "section_%02zd:", section)
        let selector = Selector(selectorName)
        return (selectorName, selector)
    }
    private func getRowInfo(with indexPath: IndexPath) -> (selectorName: String, selector: Selector) {
        let selectorName = String(format: "row_%02zd_%02zd:", indexPath.section, indexPath.row)
        let selector = Selector(selectorName)
        return (selectorName, selector)
    }
    
}
