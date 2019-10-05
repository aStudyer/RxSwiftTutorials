//
//  HHTableViewCell.swift
//  HHUIBase_Swift_Example
//
//  Created by 王翔 on 2019/9/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class HHTableViewCell: UITableViewCell {
    var data: HHRowModel?{
        didSet{
            if let data = data{
                lb_content.text = data.title
                
                if let destVc = data.destVC, destVc.count > 0 {
                    accessoryType = .disclosureIndicator
                }else{
                    accessoryType = .none
                }
            }
        }
    }
    private lazy var lb_content: UILabel = {
        var lb_content = UILabel()
        lb_content.font = UIFont.systemFont(ofSize: 16)
        lb_content.textColor = UIColor.black
        return lb_content
    }()
    static func cell(with tableView: UITableView) -> HHTableViewCell {
        let reuseIdentifier: String = NSStringFromClass(HHTableViewCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = HHTableViewCell.self.init(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! HHTableViewCell
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lb_content)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lb_content.frame = CGRect(x: 10, y: 0, width: frame.width, height: frame.height)
    }
}
