//
//  TraitsObservableVC1.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/27.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift

class TraitsObservableVC1: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
extension TraitsObservableVC1 {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                createSingle()
            case 1:
                useSingle()
            case 2:
                asSingle()
            default:
                break
            }
        case 1:
            switch indexPath.row{
            case 0:
                createCompletable()
            case 1:
                useCompletable()
            default:
                break
            }
        case 2:
            switch indexPath.row{
            case 0:
                createMaybe()
            case 1:
                useMaybe()
            case 2:
                asMaybe()
            default:
                break
            }
        default:
            break
        }
    }
}
// MARK: - 私有方法
extension TraitsObservableVC1 {
    private func createSingle() {
        //获取第0个频道的歌曲信息
        getPlaylist("0")
            .subscribe { event in
                switch event {
                case .success(let json):
                    print("JSON结果: ", json)
                case .error(let error):
                    print("发生错误: ", error)
                }
            }
            .disposed(by: disposeBag)
    }
    private func useSingle() {
        //获取第0个频道的歌曲信息
        getPlaylist("0")
            .subscribe(onSuccess: { json in
                print("JSON结果: ", json)
            }, onError: { error in
                print("发生错误: ", error)
            })
            .disposed(by: disposeBag)
    }
    /// 我们可以通过调用 Observable 序列的 .asSingle() 方法，将它转换为 Single。
    private func asSingle() {
        Observable.of("1")
            .asSingle()
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
    }
    private func createCompletable() {
        cacheLocally()
            .subscribe { completable in
                switch completable {
                case .completed:
                    print("保存成功!")
                case .error(let error):
                    print("保存失败: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
    }
    private func useCompletable() {
        cacheLocally()
            .subscribe(onCompleted: {
                print("保存成功!")
            }, onError: { error in
                print("保存失败: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    private func createMaybe() {
        generateString()
            .subscribe { maybe in
                switch maybe {
                case .success(let element):
                    print("执行完毕，并获得元素：\(element)")
                case .completed:
                    print("执行完毕，且没有任何元素。")
                case .error(let error):
                    print("执行失败: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
    }
    private func useMaybe() {
        generateString()
            .subscribe(onSuccess: { element in
                print("执行完毕，并获得元素：\(element)")
            },
                       onError: { error in
                        print("执行失败: \(error.localizedDescription)")
            },
                       onCompleted: {
                        print("执行完毕，且没有任何元素。")
            })
            .disposed(by: disposeBag)
    }
    private func asMaybe() {
        Observable.of("1")
            .asMaybe()
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
    }
}

extension TraitsObservableVC1 {
    //获取豆瓣某频道下的歌曲信息
    func getPlaylist(_ channel: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { single in
            let url = "https://douban.fm/j/mine/playlist?"
                + "type=n&channel=\(channel)&from=mainsite"
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data,
                                                                 options: .mutableLeaves),
                    let result = json as? [String: Any] else {
                        single(.error(DataError.cantParseJSON))
                        return
                }
                
                single(.success(result))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
    //与数据相关的错误类型
    enum DataError: Error {
        case cantParseJSON
    }
    
    //将数据缓存到本地
    func cacheLocally() -> Completable {
        return Completable.create { completable in
            //将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
            let success = (arc4random() % 2 == 0)
            
            guard success else {
                completable(.error(CacheError.failedCaching))
                return Disposables.create {}
            }
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    
    //与缓存相关的错误类型
    enum CacheError: Error {
        case failedCaching
    }
    
    func generateString() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            
            //成功并发出一个元素
//            maybe(.success("成功了"))
            
            //成功但不发出任何元素
//            maybe(.completed)
            
            //失败
            maybe(.error(StringError.failedGenerate))
            
            return Disposables.create {}
        }
    }
    
    //与缓存相关的错误类型
    enum StringError: Error {
        case failedGenerate
    }
}
