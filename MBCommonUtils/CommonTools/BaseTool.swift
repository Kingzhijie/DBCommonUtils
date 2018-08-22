//
//  BaseTool.swift
//  MBCommonUtils
//
//  Created by nz on 2018/7/25.
//  Copyright © 2018年 xiaoxiaoniuzai. All rights reserved.
//

import UIKit

public class BaseTool: NSObject {
    
    // MARK: 是否登录
    public static func isLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: userDefaultKey_isLogin)
    }
    
    
    // MARK: token
    public static func loginToken() -> String {
        return UserDefaults.standard.object(forKey: userDefaultKey_loginToken) as? String ?? ""
    }
    
    
    // MARK: 打电话
    public static func call(for phone: String) {
        let phoneNumber = "tel://\(phone)"
        if let url = URL.init(string: phoneNumber) {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    // MARK: html代码 适配屏幕
    public func stringFitToScreenWithHtml() -> String {
        let headStr = "<!DOCTYPE html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\" /><meta name=\"viewport\"content=\"width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\"/></head><body>"
        return String(format: "%@%@</body></html>", headStr, self)
    }
    
    
    // MARK: 数组转json串
    // 如: ["fdsjkfdskj", "fdsjkfdskj"] --> "[{url:"fdsjkfdskj"}, {url:"fdsjkfdskj"}]"
    public static func arrayTrasFormJsonString(strArray: [String]) -> String {
        var jsonArray = [Any]()
        for str in strArray {
            let dic = ["url":str]
            jsonArray.append(dic)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
            return jsonStr ?? ""
        } catch  {
        
        }
        
        return ""
    }
    
    
    // MARK: json转对象
    public static func stringJsonTransFormObject(jsonStr: String) -> Any? {
        let jsonData = jsonStr.data(using: String.Encoding.utf8)
        if jsonData != nil {
            do {
                let object = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers)
                return object
            } catch  {
                return nil
            }
        }
        return nil
    }
    
    //MARK:- 对象转json
    public static func objectTransFormJsonStr(object:Any) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
            return jsonStr ?? ""
        } catch  {
        }
        return ""
    }
    
    // caches路径
    public static func cachesPath() -> String? {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    
    // documents路径
    public static func documentsPath() -> String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
}
