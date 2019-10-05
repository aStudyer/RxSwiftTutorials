//
//  HHTableViewHeaderFooterView.swift
//  HHUIBase_Swift_Example
//
//  Created by 王翔 on 2019/9/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class HHTableViewHeaderFooterView: UITableViewHeaderFooterView {
    var content: String? {
        didSet {
            if let content = content {
                lb_content.setTitle(content, for: .normal)
            }
        }
    }
    var clickBlock: ((UITableView, NSInteger) -> (Void))?
    private lazy var lb_content: UIButton = {
        var lb_content = UIButton()
        lb_content.backgroundColor = UIColor.init(red:0.776 , green: 0.804, blue: 0.843, alpha: 1.00)
        lb_content.setTitleColor(UIColor.black, for: .normal)
        if #available(iOS 8.2, *) {
            lb_content.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        } else {
            // Fallback on earlier versions
        }
        lb_content.addTarget(self, action:#selector(lb_content_did_click) , for: .touchUpInside)
        lb_content.contentHorizontalAlignment = .left
        return lb_content
    }()
    private weak var tableView: UITableView?
    private var section: NSInteger = 0
    static func headerFooterView(with tableView: UITableView, in section: NSInteger) -> HHTableViewHeaderFooterView {
        let ID: String = NSStringFromClass(HHTableViewHeaderFooterView.self)
        var headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ID) as? HHTableViewHeaderFooterView
        if headerFooterView == nil {
            headerFooterView = HHTableViewHeaderFooterView.self.init(reuseIdentifier: ID)
        }
        headerFooterView!.tableView = tableView
        headerFooterView!.clickBlock = nil
        headerFooterView?.section = section
        return headerFooterView!
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lb_content)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lb_content.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height-1)
        lb_content.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    @objc func lb_content_did_click() {
        if let clickBlock = clickBlock {
            clickBlock(tableView!, section)
        }
    }
}

