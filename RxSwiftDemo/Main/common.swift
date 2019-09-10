//
//  common.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/27.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import Foundation

/// 自定义LOG
func NSLog<T>(_ message: T, fileName: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
    print(" \(((fileName as NSString).components(separatedBy: "/").last! as NSString).components(separatedBy: ".").first!):\(method)[\(line)]:\(message)")
    #endif
}

/// 获取项目命名空间
func getNamespace() -> String {
    guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
        NSLog("获取命名空间失败")
        return ""
    }
    return name
}
