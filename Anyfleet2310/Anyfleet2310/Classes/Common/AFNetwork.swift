//
//  AFNetwork.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/3/27.
//

import Alamofire
import JGProgressHUD

// MARK: - Loading

/// 显示Loading
public func showLoading(_ text: String,
                        style: JGProgressHUDStyle = .dark,
                        dismissAfter: TimeInterval? = nil,
                        tag: Int = -1) {
    let hud: JGProgressHUD = JGProgressHUD()
    hud.textLabel.text = text
    hud.style = style
    hud.tag = tag
    //
    var keyWindow: UIWindow?
    if #available(iOS 13.0, *) {
        keyWindow = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
    } else {
        keyWindow = UIApplication.shared.keyWindow
    }
    //
    if let view = keyWindow {
        hud.show(in: view)
        if dismissAfter != nil {
            hud.dismiss(afterDelay: dismissAfter!)
        }
    }
}

/// 隐藏Loading
public func dismissLoading(tag: Int = -1) {
    var keyWindow: UIWindow?
    if #available(iOS 13.0, *) {
        keyWindow = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
    } else {
        keyWindow = UIApplication.shared.keyWindow
    }
    //
    if let view = keyWindow {
        if let hud: JGProgressHUD = view.viewWithTag(tag) as? JGProgressHUD {
            hud.dismiss()
        }
    }
}

// MARK: - AFNetwork

class AFNetwork {
    /// 单例
    static var shared: AFNetwork {
        struct Static {
            static var instance: AFNetwork?
        }
        if Static.instance == nil {
            Static.instance = AFNetwork()
            //
            AF.sessionConfiguration.timeoutIntervalForRequest = 30
            //
            if let model: AppNetworkModel = Static.instance!.getAppNetworkModel() {
                if model.isDevelopmentEnvironment {
                    Static.instance!.networkHost = "\(model.developmentEnvironment.domain)"
                } else {
                    Static.instance!.networkHost = "\(model.productionEnvironment.domain)"
                }
                //
                Static.instance!.networkModel = model
                // -------------------------- //
                let tempNetworkHost = Common.getHTTPS()
                if tempNetworkHost.count > 0 {
                    Static.instance!.networkHost = tempNetworkHost
                } else {
                    Common.saveHTTPS(host: Static.instance!.networkHost)
                }
            }
        }
        return Static.instance!
    }
    
    /// 完整url前缀
    public var networkHost: String = ""
    /// 是否打印网络请求数据
    public var isLog: Bool = true
    /// 网络配置
    public var networkModel: AppNetworkModel?
    
    /// 请求回调
    public typealias requestCallBack = (_ response: AFDataResponse<Any>, _ data: [String: Any]?, AFError?) -> Void
    
    /// 网络请求
    /// - Parameters:
    ///   - loading: 加载文案
    ///   - method: GET / POST
    ///   - url: URL
    ///   - parameters: 参数
    ///   - headers: 头部
    ///   - finished: 完成回调
    public func request(loading: String? = Common.loading,
                        method: HTTPMethod,
                        url: String,
                        parameters: [String: Any]? = nil,
                        headers: HTTPHeaders? = nil,
                        finished: @escaping requestCallBack) {
        let tag = String.randomIntString(length: 10)
        if loading != nil, (loading?.count ?? 0) > 0 {
            showLoading(loading!, tag: tag)
        }
        
        //
        let result = handleUrlAndParameters(method: method, url: url, parameters: parameters)
        let completedUrl = result.url
        let newParameters = result.parameters
        
        //
        AF.request(completedUrl, method: method, parameters: newParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if loading != nil, (loading?.count ?? 0) > 0 {
                dismissLoading(tag: tag)
            }
            // 打印日志
            AFNetwork.shared.log(method: method, url: completedUrl, parameters: newParameters, headers: headers, response: response)
            //
            switch response.result {
            case let .success(data):
                finished(response, data as? [String: Any], nil)
                break
            case let .failure(error):
                finished(response, nil, error)
                break
            }
        }
    }
    
    private func handleUrlAndParameters(method: HTTPMethod,
                                        url: String,
                                        parameters: [String: Any]? = nil) -> (url: String, parameters: [String: Any]?) {
        var completedUrl = ""
        if !url.contains("http"), AFNetwork.shared.networkHost.count > 0 {
            completedUrl = "\(AFNetwork.shared.networkHost)\(url)"
        } else {
            completedUrl = url
        }
        
        var newParameters = parameters
        if method == .get {
            if let param: [String: Any] = newParameters {
                completedUrl.append("?")
                for (index, key) in param.keys.enumerated() {
                    let obj = param[key]
                    var newValue: String = ""
                    if let value = obj as? Int {
                        newValue = String(format: "%d", value)
                    } else if let value = obj as? Float {
                        newValue = String(format: "%f", value)
                    } else if let value = obj as? Double {
                        newValue = String(format: "%f", value)
                    } else if let value = obj as? String {
                        newValue = value
                    } else {
                        print("AFNetwork GET parameters 存在既不是 String 也不是 (Int,Float,Double) 的数据类型！")
                    }
                    var temp = "\(key)=\(newValue)"
                    if index != param.keys.count - 1 {
                        temp.append("&")
                    }
                    completedUrl.append(temp)
                }
            }
            newParameters = nil
        }
        //
        return (completedUrl, newParameters)
    }
    
    /// 上传文件
    public func upload(loading: String? = "uploading...",
                       url: String,
                       data: Data,
                       name: String,
                       fileName: String = "",
                       parameters: [String: Any]?,
                       finished: @escaping requestCallBack) {
        if loading != nil, (loading?.count ?? 0) > 0 {
            showLoading(loading!)
        }
        //
        let parameter = parameters
        /**
         1. data 要上传文件的二进制
         2. name 是服务器定义的字段名称 - 后台接口文档会提示
         3. fileName 是保存在服务器的文件名，但是：现在通常可以随便写，后台会做一些处理
         - 根据上传的文件，生成 缩略图，中等图，高清图
         - 保存在不同路径，并且自动生成文件名
         - fileName 是 HTTP 协议定义的属性
         
         4. mimeType  / contentType: 客户端通知服务器，二进制数据的准确类型
         - 大类型 / 小类型
         * image/gif  image/jpg image/png
         * text/plain text/html
         * application/json
         - 服务器不准确的类型
         * application/octet-stream
         */
        
        AF.upload(multipartFormData: { multipartFormData in
            // 拼接上传文件的二进制数据
            multipartFormData.append(data, withName: name, fileName: fileName, mimeType: "application/octet-stream")
            // 遍历参数字典,生成对应的参数数据
            if let parameter = parameter {
                for (key, value) in parameter {
                    let str =  value as! String
                    let strData = str.data(using: .utf8)!
                    // data 是 value 的二进制数据 name 是 key
                    multipartFormData.append(strData, withName: key)
                }
            }
        }, to: url)
        .responseJSON { response in
            if loading != nil, (loading?.count ?? 0) > 0 {
                dismissLoading()
            }
            //
            //print(response.result)
            switch response.result{
            case let .success(data):
                // 完成回调
                finished(response, data as? [String : Any], nil)
                break
            case let .failure(error):
                // 在开发网络应用中的时候，错误不要提示给用户，但是错误一定要输出
                //print(error)
                finished(response, nil, error)
                break
            }
        }
    }
}

// MARK: - 从配置文件读取开发环境、生产环境的网络完整地址（前缀）
extension AFNetwork {
    struct AppNetworkModel: Decodable {
        var warning: String = ""
        var isDevelopmentEnvironment: Bool = true
        var developmentEnvironment: Environment = Environment()
        var productionEnvironment: Environment = Environment()
    }
    
    struct Environment: Decodable {
        var domain: String = ""
    }
    
    /// 通过配置文件获取 AppNetworkModel
    public func getAppNetworkModel() -> AppNetworkModel? {
        if let dict = BaseTools.getDictionaryFormFile(fileName: "NetworkConfig") {
            if let model: AppNetworkModel = try? String.performTransToModelObject(type: AppNetworkModel.self, dictionary: dict) {
                return model
            }
        }
        return nil
    }
    
    /// 打印网络请求
    public func log(method: HTTPMethod,
                    url: String,
                    parameters: [String: Any]? = nil,
                    headers: HTTPHeaders? = nil,
                    response: AFDataResponse<Any>) {
        if let model: AppNetworkModel = AFNetwork.shared.networkModel, isLog {
            let envType = model.isDevelopmentEnvironment ? "测试环境" : "正式环境"
            print("==============> \(envType) <==============")
            // Url:
            print("url:\n\(url)\n")
            // Body
            if let dict: NSDictionary = parameters as? NSDictionary {
                let json = String.dictionaryToJson(dictionary: dict)
                print("body:\n\(json)\n")
            } else {
                print("body:\nnil\n")
            }
            // Headers
            let headerJson: NSMutableString = ""
            if let headers: HTTPHeaders = headers {
                for (index, header) in headers.enumerated() {
                    headerJson.append("\(header.name) = \(header.value)")
                    if index != headers.count - 1 {
                        headerJson.append("\n")
                    }
                }
            }
            if headerJson.length > 0 {
                print("headers:\n\(headerJson)\n")
            } else {
                print("headers:\nnil\n")
            }
            // Response
            print("response:\n\(response)")
            print("================================ [\(url)] => End ================================")
        }
    }
    
}
