//
//  MainViewController.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/23.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    private let dataList: [SectionItem] = SectionItem.mj_objectArray(withFilename: R.file.datalistPlist.fullName) as! [SectionItem]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(resource: R.nib.mainHeaderFooterView), forHeaderFooterViewReuseIdentifier: R.nib.mainHeaderFooterView.name)
    }
}
// MARK: - UITableViewDataSource
extension MainViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = dataList[section]
        return sectionItem.isOpen ? sectionItem.units!.count : 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mainCell, for: indexPath)!
        let sectionItem = dataList[indexPath.section]
        let rowItem = sectionItem.units![indexPath.row]
        cell.textLabel?.text = rowItem.title
        return cell
    }
}
// MARK: - UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItem = dataList[indexPath.section]
        let rowItem = sectionItem.units![indexPath.row]
        if let destVc = rowItem.destVc, destVc.count > 0 {
            if let _ = Bundle.main.path(forResource: destVc, ofType: "storyboardc"), let destVc_obj = UIStoryboard(name: destVc, bundle: nil).instantiateInitialViewController() {
                destVc_obj.title = rowItem.title
                self.navigationController?.pushViewController(destVc_obj, animated: true)
            }else if let name = Utils.getBundleName() {
                let destVc_name = name + "." + destVc
                let destVc_obj = (NSClassFromString(destVc_name) as! UIViewController.Type).init()
                destVc_obj.title = rowItem.title
                self.navigationController?.pushViewController(destVc_obj, animated: true)
           }
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainHeaderFooterView.name) as! MainHeaderFooterView
        headerView.sectionItem = dataList[section]
        headerView.click = {[weak self] header in
            guard let self = self else { return }
            let count = header.sectionItem?.units?.count ?? 0
            if let destVc = header.sectionItem?.destVc, destVc.count > 0, 0 == count {
                if let _ = Bundle.main.path(forResource: destVc, ofType: "storyboardc"), let destVc_obj = UIStoryboard(name: destVc, bundle: nil).instantiateInitialViewController() {
                    destVc_obj.title = header.sectionItem?.title
                    self.navigationController?.pushViewController(destVc_obj, animated: true)
                }else if let name = Utils.getBundleName() {
                    let destVc_name = name + "." + destVc
                    let destVc_obj = (NSClassFromString(destVc_name) as! UIViewController.Type).init()
                    destVc_obj.title = header.sectionItem?.title
                    self.navigationController?.pushViewController(destVc_obj, animated: true)
                }
            }
            self.tableView.reloadData()
        }
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
