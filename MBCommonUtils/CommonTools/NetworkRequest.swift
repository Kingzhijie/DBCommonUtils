//
//  NetworkRequest.swift
//  DBMerchantProject
//
//  Created by mbApple on 2018/2/9.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public protocol NetworkProcotol:MBProgressHUDProcotol {}

extension NetworkProcotol {
    
    //MARK: - 添加header
    fileprivate func getHeaders() -> HTTPHeaders {
        let headers:HTTPHeaders = ["token": BaseTool.loginToken(),
                                   "Device-type":"ios"]
        return headers
    }
    
    
    // MARK: - GET 请求
    ///
    /// - Parameters:
    ///   - urlString: 请求的地址
    ///   - toast: 是否需要弹出, message 错误提示 ----默认true
    ///   - success: 请求成功的回调
    ///   - failture: 失败的回调
    public func getRequest(urlString:String,
                    toast:Bool = true,
                    success: @escaping (_ respone : JSON)->Void,
                    failture: @escaping (_ error:Error)->Void){
        netRequest(urlString: urlString, parameters: nil, toast: toast, encoding: URLEncoding.default, method: .get, success: success, failture: failture)
    }
    
    
    // MARK: - POST 请求
    ///
    /// - Parameters:
    ///   - urlString: 请求的地址
    ///   - params: 请求的参数
    ///   - toast: 是否需要弹出, message 错误提示 ----默认true
    ///   - success: 请求成功的回调
    ///   - failture: 失败的回调
    public func postRequest(urlString:String,
                     params:[String:Any]?,
                     toast:Bool = true,
                     success:@escaping (_ respone : JSON)->Void,
                     failture: @escaping (_ error:Error)->Void) {
        netRequest(urlString: urlString, parameters: params, toast: toast, encoding: JSONEncoding.default, method: .post, success: success, failture: failture)
    }
    
    
    //MARK: - DELETE 请求
    ///
    /// - Parameters:
    ///   - urlString: 请求的地址
    ///   - params: 请求的参数
    ///   - toast: 是否需要弹出, message 错误提示 ----默认true
    ///   - success: 请求成功的回调
    ///   - failture: 失败的回调
    public func deleteRequest(urlString:String,
                       params:[String:Any]?,
                       toast:Bool = true,
                       success:@escaping (_ respone : JSON)->Void,
                       failture: @escaping (_ error:Error)->Void) {
        netRequest(urlString: urlString, parameters: params, toast: toast, encoding: URLEncoding.default, method: .delete, success: success, failture: failture)
    }
    
    
    //MARK: - PUT 请求
    ///
    /// - Parameters:
    ///   - urlString: 请求的地址
    ///   - params: 请求的参数
    ///   - toast: 是否需要弹出, message 错误提示 ----默认true
    ///   - success: 请求成功的回调
    ///   - failture: 失败的回调
    public func putRequest(urlString:String,
                    params:[String:Any]?,
                    toast:Bool = true,
                    success:@escaping (_ respone : JSON)->Void,
                    failture: @escaping (_ error:Error)->Void) {
        netRequest(urlString: urlString, parameters: params, toast: toast, encoding: JSONEncoding.default, method: .put, success: success, failture: failture)
    }
    
    //MARK: - Patch 请求
    ///
    /// - Parameters:
    ///   - urlString: 请求的地址
    ///   - params: 请求的参数
    ///   - toast: 是否需要弹出, message 错误提示 ----默认true
    ///   - success: 请求成功的回调
    ///   - failture: 失败的回调
    public func patchRequest(urlString:String,
                      params:[String:Any]?,
                      toast:Bool = true,
                      success:@escaping (_ respone : JSON)->Void,
                      failture: @escaping (_ error:Error)->Void) {
        netRequest(urlString: urlString, parameters: params, toast: toast, encoding: JSONEncoding.default, method: .patch, success: success, failture: failture)
    }
    
    
    /// 数据请求的方法
    ///
    /// - Parameters:
    ///   - urlString: 请求的地址
    ///   - parameters: 请求的参数
    ///   - toast: 是否需要弹出, message 错误提示
    ///   - encoding: ParameterEncoding
    ///   - method: 请求的方式(get,post ...)
    ///   - success: 请求成功的回调
    ///   - failture: 失败的回调
   fileprivate func netRequest(urlString:String,
                    parameters:Parameters?,
                    toast:Bool,
                    encoding:ParameterEncoding,
                    method:HTTPMethod,
                    success: @escaping (_ respone : JSON)->Void,
                    failture: @escaping (_ error:Error)->Void) {

        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    
        let headers = getHeaders()
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            //使用switch判断请求是否成功，也就是response的result
            switch response.result{
            case .success(let value):
                let dic = JSON(value)
                success(dic)
                let code = dic[msgCode].stringValue
                if toast == true {
                    if code != successCode {
                        self.showMessage(text: dic["message"].stringValue)
                    }
                }
                
                if code == loginCode { // 被注销
                    UserDefaults.standard.set(false, forKey: userDefaultKey_isLogin)
                    UserDefaults.standard.set("", forKey: userDefaultKey_loginToken)
                }
                
            case .failure(let error):
                print("error:\(error)")
                failture(error)
                self.dismiss()
            }
        }
    }
    
    
    
    /// 文件上传
    ///
    /// - Parameters:
    ///   - urlString: 上传服务器地址
    ///   - params: 参数
    ///   - images: image数组
    ///   - imageName: 图片名字
    ///   - success: 成功的回调
    ///   - failture: 失败的回调
    public func uploadFile(urlString: String,
                    params:[String:String]?,
                    images: [Any],
                    imageName: String,
                    success: @escaping (_ respone : JSON)->Void,
                    failture : @escaping (_ error:Error)->Void) {
        let headers = getHeaders()
        Alamofire.upload(multipartFormData: { (formData) in
            if params != nil {
                for (key, value) in params! {
                    //参数的上传
                    formData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }
            
            for (index, value) in images.enumerated() {
                var imgData = Data.init()
                
                if (value as AnyObject).isKind(of: UIImage.self) {
                    let imageData = UIImageJPEGRepresentation(value as! UIImage, 0.8)
                    imgData = imageData!
                } else {
                    imgData = value as! Data
                }
                
                let str = "\(DB_DateTool.getCurrentTimeStr())"
                let fileName = str+"\(index)"+".jpg"
                
                // 以文件流格式上传
                // 批量上传与单张上传，后台语言为java或.net等
                if images.count == 1 {
                    formData.append(imgData, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                    
                } else {
                    let name = imageName + "\(index + 1)"
                    formData.append(imgData, withName: name, fileName: fileName, mimeType: "image/jpeg")
                }
            }
        }, to: urlString,
           method: .post,
           headers: headers)
        { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    let result = response.result
                    if result.isSuccess {
                        if let value = response.result.value  {
                            let dic = JSON(value)
                            success(dic)
                        }
                    }
                }
            case .failure(let encodingError):
                failture(encodingError)
                self.dismiss()
            }
        }
    }
    
    
}
