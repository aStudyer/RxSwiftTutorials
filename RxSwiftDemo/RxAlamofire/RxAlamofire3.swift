//
//  RxAlamofire3.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

class RxAlamofire3: BaseTableViewController {
    private lazy var progressView: UIProgressView = {
       let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10))
        progressView.progressTintColor = UIColor.red
        progressView.trackTintColor = UIColor.green
        progressView.backgroundColor = UIColor.lightGray
        return progressView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = progressView
    }
}
extension RxAlamofire3 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                demo_01()
            case 1:
                demo_02()
            case 2:
                demo_03()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                demo_04()
            case 1:
                demo_05()
            default:
                break
            }
        default:
            break
        }
    }
}
extension RxAlamofire3 {
    /// 使用文件流的形式上传文件
    private func demo_01() {
        //需要上传的文件路径
        let fileURL = Bundle.main.url(forResource: "一路惊喜", withExtension: "mp3")
        //服务器路径
        let uploadURL = URL(string: "http://www.hangge.com/upload.php")!
        
        //将文件上传到服务器
        upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL))
            .subscribe(onCompleted: {
                NSLog("上传完毕!")
            })
            .disposed(by: disposeBag)
    }
    /// 获得上传进度
    private func demo_02() {
        //需要上传的文件路径
        let fileURL = Bundle.main.url(forResource: "一路惊喜", withExtension: "mp3")
        //服务器路径
        let uploadURL = URL(string: "http://www.hangge.com/upload.php")!
        
        //将文件上传到服务器
        upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL))
            .subscribe(onNext: { element in
                NSLog("--- 开始上传 ---")
                element.uploadProgress(closure: { (progress) in
                    NSLog("当前进度：\(progress.fractionCompleted)")
                    NSLog("已上传载：\(progress.completedUnitCount/1024)KB")
                    NSLog("总大小：\(progress.totalUnitCount/1024)KB")
                })
            }, onError: { error in
                NSLog("上传失败! 失败原因：\(error)")
            }, onCompleted: {
                NSLog("上传完毕!")
            })
            .disposed(by: disposeBag)
    }
    /// 在进度条上显示进度
    private func demo_03() {
        //需要上传的文件路径
        let fileURL = Bundle.main.url(forResource: "一路惊喜", withExtension: "mp3")
        //服务器路径
        let uploadURL = URL(string: "http://www.hangge.com/upload.php")!
        
        //将文件上传到服务器
        upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL))
            .map{request in
                //返回一个关于进度的可观察序列
                Observable<Float>.create{observer in
                    request.uploadProgress(closure: { (progress) in
                        observer.onNext(Float(progress.fractionCompleted))
                        if progress.isFinished{
                            observer.onCompleted()
                        }
                    })
                    return Disposables.create()
                }
            }
            .flatMap{$0}
            .bind(to: progressView.rx.progress) //将进度绑定UIProgressView上
            .disposed(by: disposeBag)
    }
    /// 上传两个文件
    private func demo_04() {
        //需要上传的文件
        let fileURL1 = Bundle.main.url(forResource: "一路惊喜", withExtension: "mp3")
        let fileURL2 = Bundle.main.url(forResource: "girl", withExtension: "jpeg")
        //服务器路径
        let uploadURL = URL(string: "http://www.hangge.com/upload2.php")!
        //将文件上传到服务器
        upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL1!, withName: "file1")
                multipartFormData.append(fileURL2!, withName: "file2")
        },
            to: uploadURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        NSLog(response)
                    }
                case .failure(let encodingError):
                    NSLog(encodingError)
                }
        })
    }
    /// 文本参数与文件一起提交（文件除了可以使用 fileURL，还可以上传 Data 类型的文件数据）
    private func demo_05() {
        //字符串
        let strData = "hangge.com".data(using: String.Encoding.utf8)
        //数字
        let intData = String(10).data(using: String.Encoding.utf8)
        //文件1
        let path = Bundle.main.url(forResource: "一路惊喜", withExtension: "mp3")!
        let file1Data = try! Data(contentsOf: path)
        //文件2
        let file2URL = Bundle.main.url(forResource: "girl", withExtension: "jpeg")
        
        //服务器路径
        let uploadURL = URL(string: "http://www.hangge.com/upload2.php")!
        
        //将文件上传到服务器
        upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(strData!, withName: "value1")
                multipartFormData.append(intData!, withName: "value2")
                multipartFormData.append(file1Data, withName: "file1",
                                         fileName: "php.png", mimeType: "image/png")
                multipartFormData.append(file2URL!, withName: "file2")
        },
            to: uploadURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        NSLog(response)
                    }
                case .failure(let encodingError):
                    NSLog(encodingError)
                }
        })
    }
}
