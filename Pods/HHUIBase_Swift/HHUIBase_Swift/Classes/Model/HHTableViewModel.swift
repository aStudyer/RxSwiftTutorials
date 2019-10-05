//
//  HHSectionModel.swift
//  HHUIBase_Swift_Example
//
//  Created by 王翔 on 2019/9/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class HHSectionModel: NSObject {
    @objc public var header: String?
    
    @objc public var footer: String?
    
    @objc public var isOpen: Bool = false
    
    @objc public var destVC: String?
    
    @objc public var section: NSInteger = 0
    
    @objc public var items: [HHRowModel] = []
    
    @objc public var operation: ((UITableView, NSInteger) -> Void)?
    
    @objc public override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["items": HHRowModel.self]
    }
}

public class HHRowModel: NSObject {
    @objc public var title: String?
    @objc public var destVC: String?
    @objc public var indexPath: IndexPath?
    @objc public var operation: ((UITableView, IndexPath) -> Void)?
}
