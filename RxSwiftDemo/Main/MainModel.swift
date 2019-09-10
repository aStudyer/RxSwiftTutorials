//
//  Section.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/23.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import MJExtension

class SectionItem: NSObject {
    @objc var title: String?
    @objc var destVc: String?
    @objc var units: [RowItem]?
    var isOpen: Bool = false
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["units": RowItem.self]
    }
}

class RowItem: NSObject {
    @objc var title: String?
    @objc var destVc: String?
}
