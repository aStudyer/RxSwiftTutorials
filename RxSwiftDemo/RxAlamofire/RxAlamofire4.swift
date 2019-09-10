//
//  RxAlamofire4.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxAlamofire
import Alamofire

class RxAlamofire4: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

}

extension RxAlamofire4 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            demo_01()
        case 1:
            demo_02()
        case 2:
            demo_03()
        case 3:
            demo_04()
        default:
            break
        }
    }
}

extension RxAlamofire4 {
    /// 指定下载路径（文件名不变）
    private func demo_01() {
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //需要下载的文件
        let fileURL = URL(string: "https://c-ssl.duitang.com/uploads/item/201808/27/20180827043223_twunu.jpg")!
        
        //开始下载
        download(URLRequest(url: fileURL), to: destination)
            .subscribe(onNext: { element in
                NSLog("开始下载。")
            }, onError: { error in
                NSLog("下载失败! 失败原因：\(error)")
            }, onCompleted: {
                NSLog("下载完毕!")
            })
            .disposed(by: disposeBag)
    }
    /// 指定下载路径和保存文件名
    private func demo_02() {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("file1/myLogo.png")
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //需要下载的文件
        let fileURL = URL(string: "https://c-ssl.duitang.com/uploads/item/201808/27/20180827043223_twunu.jpg")!
        
        //开始下载
        download(URLRequest(url: fileURL), to: destination)
            .subscribe(onNext: { element in
                NSLog("开始下载。")
            }, onError: { error in
                NSLog("下载失败! 失败原因：\(error)")
            }, onCompleted: {
                NSLog("下载完毕!")
            })
            .disposed(by: disposeBag)
    }
    /// 使用默认提供的下载路径
    private func demo_03() {
        // Alamofire 内置的许多常用的下载路径方便我们使用，简化代码。注意的是，使用这种方式如果下载路径下有同名文件，不会覆盖原来的文件。
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        //需要下载的文件
        let fileURL = URL(string: "https://c-ssl.duitang.com/uploads/item/201808/27/20180827043223_twunu.jpg")!
        
        //开始下载
        download(URLRequest(url: fileURL), to: destination)
            .subscribe(onNext: { element in
                NSLog("开始下载。")
            }, onError: { error in
                NSLog("下载失败! 失败原因：\(error)")
            }, onCompleted: {
                NSLog("下载完毕!")
            })
            .disposed(by: disposeBag)
    }
    /// 下载进度
    private func demo_04() {
        //需要下载的文件
        let fileURL = URL(string: "https://c-ssl.duitang.com/uploads/item/201808/27/20180827043223_twunu.jpg")!
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        //开始下载
        download(URLRequest(url: fileURL), to: destination)
            .subscribe(onNext: { element in
                NSLog("开始下载。")
                element.downloadProgress(closure: { progress in
                    NSLog("当前进度: \(progress.fractionCompleted)")
                    NSLog("  已下载：\(progress.completedUnitCount/1024)KB")
                    NSLog("  总大小：\(progress.totalUnitCount/1024)KB")
                })
            }, onError: { error in
                NSLog("下载失败! 失败原因：\(error)")
            }, onCompleted: {
                NSLog("下载完毕!")
            }).disposed(by: disposeBag)
    }
}
