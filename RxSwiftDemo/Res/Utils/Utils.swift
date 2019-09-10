//
//  Utils.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/25.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import Foundation

struct Utils {
    static func getBundleName() -> String? {
        return Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
    }
}
