//
//  DouBanAPI..swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/9.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

/**
 首先定义一个 provider，即请求发起对象。往后我们如果要发起网络请求就使用这个 provider。
 接着声明一个 enum 来对请求进行明确分类，这里我们定义两个枚举值分别表示获取频道列表、获取歌曲信息。
 最后让这个 enum 实现 TargetType 协议，在这里面定义我们各个请求的 url、参数、header 等信息。
 */
import Foundation
import Moya

//初始化豆瓣FM请求的provider
let DouBanProvider = MoyaProvider<DouBanAPI>()

/** 下面定义豆瓣FM请求的endpoints（供provider使用）**/
//请求分类
enum DouBanAPI {
    case channels  //获取频道列表
    case playlist(String) //获取歌曲
}

//请求配置
extension DouBanAPI: TargetType {
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
        case .playlist(_):
            return URL(string: "https://douban.fm")!
        }
    }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
        case .playlist(_):
            return "/j/mine/playlist"
        }
    }
    
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .playlist(let channel):
            var params: [String: Any] = [:]
            params["channel"] = channel
            params["type"] = "n"
            params["from"] = "mainsite"
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String: String]? {
        return nil
    }
}
