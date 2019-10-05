//
//  Protocols.swift
//  HHUIBase_Swift
//
//  Created by aStudyer on 2019/9/30.
//

import UIKit

public protocol DataSourcePath {
    
}
extension DataSourcePath where Self : BaseTableViewController {
    public func loadDataSource(from fileName: String? = nil) {
        var file_name: String
        if let fileName = fileName {
            if fileName.contains(".plist") {
                file_name = fileName
            }else {
                file_name = fileName + ".plist"
            }
        }else{
            file_name = "\(type(of: self)).plist"
        }
        let path = Bundle.main.path(forResource: file_name, ofType: nil)
        if let path = path, FileManager.default.fileExists(atPath: path) {
            dataList = HHSectionModel.mj_objectArray(withFilename: file_name) as! [HHSectionModel]
        }
    }
}

