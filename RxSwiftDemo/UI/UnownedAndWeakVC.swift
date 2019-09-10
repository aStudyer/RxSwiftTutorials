//
//  UnownedAndWeakVC.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit

class UnownedAndWeakVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "跳转", style: .plain, target: self, action: #selector(jump))
    }

    @objc private func jump() {
        navigationController?.pushViewController(R.storyboard.unownedAndWeakDetailVC.instantiateInitialViewController()!, animated: true)
    }
}
