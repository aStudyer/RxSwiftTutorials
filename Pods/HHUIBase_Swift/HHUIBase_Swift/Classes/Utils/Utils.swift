//
//  Utils.swift
//  HHUIBase_Swift_Example
//
//  Created by 王翔 on 2019/9/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class Utils {
    /// 获取命名空间
    static func getNameSpace() -> String? {
        return Bundle.main.infoDictionary![kCFBundleExecutableKey as String] as? String
    }
}
