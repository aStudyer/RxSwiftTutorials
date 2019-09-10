//
//  RXTextFieldVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit

class RXTextFieldVC: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension RXTextFieldVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       let cell = tableView.cellForRow(at: indexPath)
       let vc = R.storyboard.rxTextFieldDetailVC.instantiateInitialViewController()!
        vc.indexPath = indexPath
        vc.title = cell?.textLabel?.text
        navigationController?.pushViewController(vc, animated: true)
    }
}
