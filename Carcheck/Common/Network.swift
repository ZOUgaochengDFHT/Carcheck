//
//  Network.swift
//  LearningNSURLSession
//
//  Created by GaoCheng.Zou on 16/1/5.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import Foundation

/*
适配器模式是设计模式中的一种，很容易理解：我的 APP 需要一个获取某一个 URL 返回的字符串的功能，我现在选择的是 Alamofire，但是正在发展的 Pitaya 看起来不错，我以后想替换成 Pitaya，所以我封装了一层我自己的网络接口，用来屏蔽底层细节，到时候只需要修改这个类，不需要再深入项目中改那么多接口调用了。适配器模式听起来高大上，其实这是我们在日常编码中非常常用的设计模式。
*/
/// 封装多级接口
class Network {

    static func get(url:String, callback:(data:NSData!, response:NSURLResponse!, error:NSError!)->Void) {
        let manager = NetworkManager(url: url, method: "GET", callback: callback)
        manager.fire()
    }
    
    static func get(url:String, params:Dictionary<String, AnyObject>, callback:(data:NSData!, response:NSURLResponse!, error:NSError!) ->Void) {
        let manager = NetworkManager(url: url, method: "GET", params: params,  callback: callback)
        manager.fire()
    }
    
    static func post(url:String, callback:(data:NSData!, response:NSURLResponse!, error:NSError!)->Void) {
        let manager = NetworkManager(url: url, method: "POST", callback: callback)
        manager.fire()
    }
    
    static func post(url:String, params:Dictionary<String, AnyObject>, callback:(data:NSData!, response:NSURLResponse!, error:NSError!)->Void) {
        let manager = NetworkManager(url: url, method: "POST", callback: callback)
        manager.fire()
    }
    
    static func request(url:String, method:String, callback:(data:NSData!, response:NSURLResponse!, error:NSError!)->Void) {
        let manager = NetworkManager(url: url, method: method, callback: callback)
        manager.fire()
    }
    
    static func request(method:String, url:String , params:Dictionary<String, AnyObject>, callback:(data:NSData!, response:NSURLResponse!, error:NSError!)->Void) {
        
       let manager = NetworkManager(url: url, method: method, callback: callback)
        manager.fire()
    }
    
    static func request(url:String, method:String, files:Array<File>, callback:(data:NSData!, response:NSURLResponse!, error:NSError!)->Void){
        let manager = NetworkManager(url: url, method: method, files:files, callback: callback)
        manager.fire()
    }
    
    static func request(url:String, method:String, params:Dictionary<String, AnyObject>, files:Array<File>, callback:(data:NSData!, response:NSURLResponse!, error:NSError!)->Void) {
        let manager = NetworkManager(url: url, method: method, params: params, files: files, callback: callback)
        manager.fire()
    }
}

// MARK: - 扩展String，添加一个nsdata属性，nsdata属性返回编码后的NSData
extension String {
    var nsdata:NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}


struct File {
    let name:String!
    let url:NSURL!
    init(name:String, url:NSURL) {
        self.name = name
        self.url = url
    }

}

//// 在 Network 下另外新建一个 NetworkManager 类，将 URL、params、files 等设为成员变量，让他们在构造函数中初始化
/*
NSURLSession 的使用过程：

构造 NSURLRequest
确定 URL
确定 HTTP 方法（GET、POST 等）
添加特定的 HTTP 头
填充 HTTP Body
驱动 session.dataTaskWithRequest 方法，开始请求
前三步封装到一个 function 中，最后一步封装到一个 function 中，然后把驱动 session.dataTaskWithRequest 的代码封装到一个 function 中
*/
class NetworkManager:NSObject, NSURLSessionDelegate {
    let boundary = "PitayaUGl0YXlh"
    
    let method:String!
    let params:Dictionary<String, AnyObject>
    let callback:(data:NSData!, response:NSURLResponse!, error:NSError!) -> Void
 /// 定义存放结构体的数组
    var files:Array<File>
    
    var session:NSURLSession!
    var url:String!
    var mutableRequest:NSMutableURLRequest!
    var task:NSURLSessionTask!
    
    var localCertData:NSData!
    var sSLvalidateErrorCallback:(()->Void)?
    
    /// 在构造函数中初始化
    init(url:String, method:String, params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), files:Array<File> = Array<File>(), callback:(data:NSData!, response:NSURLResponse!, error:NSError!)-> Void) {
        /// 定义存放结构体的数组

        self.url = url
        self.mutableRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.method = method
        self.params = params
        self.callback = callback
        self.files = files
        
        super.init()
        
        /**设定回调的delegate（注意这个回调delegate会被强引用），并且可以设定delegate在哪个OperationQueue回调，如果我们将其设置为[NSOperationQueue mainQueue]就能在主线程进行回调非常的方便
        */

        self.session = NSURLSession(configuration: NSURLSession.sharedSession().configuration, delegate: self, delegateQueue: NSURLSession.sharedSession().delegateQueue)

    }
    
    // 添加证书
    func addSSLPinning(LocalCertData data:NSData, SSLValidateErrorCallBack:(()->Void)? = nil) {
        self.localCertData = data
        self.sSLvalidateErrorCallback = SSLValidateErrorCallBack
    }
    
    /**
     NSURLSessionDelegate
     */
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        if let localCertificateData = self.localCertData {
            if let serverTrust = challenge.protectionSpace.serverTrust, certificte = SecTrustGetCertificateAtIndex(serverTrust, 0), remoteCertificateData:NSData = SecCertificateCopyData(certificte) {
                if localCertificateData.isEqualToData(remoteCertificateData) {
                    let credential = NSURLCredential(forTrust: serverTrust)
                    challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
                    completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
                }else {
                    challenge.sender?.cancelAuthenticationChallenge(challenge)
                    completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
                }
            }else {
                NSLog("Get RemoteCertificateData or LocalCertificateData error!")
            }
        }else {
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, nil)
        }
    }
    
    /**
     之后使用一个统一的方法来驱动上面三个 function，完成请求：
     */
    func fire() {
        buildRequest()
        buildBody()
        fireTask()
    }
    
    /**
     构造 NSURLRequest
     确定 URL
     确定 HTTP 方法（GET、POST 等）
     */
    func buildRequest() {
        if self.method == "GET" && self.params.count > 0 {
            self.mutableRequest = NSMutableURLRequest(URL: NSURL(string: url + "?" + buildParams(self.params))!)
        }
        
        mutableRequest.HTTPMethod = self.method
        
        if self.files.count > 0 {
            mutableRequest.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        } else if self.params.count > 0 {
            mutableRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

    }
    
    /**
     添加特定的 HTTP 头
     */
    
    func buildBody() {
        let data = NSMutableData()
        
        if self.files.count > 0 {
            if self.method == "GET" {
               NSLog("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Pitaya will send it anyway.\n------------------------\n\n")
            }
            
            for (key, value) in self.params {
                data.appendData("--\(self.boundary)\r\n".nsdata)
                data.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                data.appendData("\(value.description)\r\n".nsdata)
            }
            
            for file in self.files {
                data.appendData("--\(self.boundary)\r\n".nsdata)
                data.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(NSString(string: file.url.description).lastPathComponent)\"\r\n\r\n".nsdata)
                if let a = NSData(contentsOfURL: file.url) {
                    data.appendData(a)
                    data.appendData("\r\n".nsdata)
                }

            }
        }else if self.params.count > 0 && self.method != "GET" {
            data.appendData(buildParams(self.params).nsdata)
        }
        
        mutableRequest.HTTPBody = data
    }
    
    func fireTask () {
        task = session.dataTaskWithRequest(mutableRequest, completionHandler: { (data, response, error) -> Void in
            self.callback(data: data, response: response, error: error)
        })
        task.resume()
    }
    
//从 Alamofire 偷了三个函数
    func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joinWithSeparator("&")
    }
    
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.appendContentsOf([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    
}

