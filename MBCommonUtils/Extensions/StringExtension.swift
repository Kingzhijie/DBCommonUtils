//
//  StringExtension.swift
//  BestProject
//
//  Created by mbApple on 2017/12/4.
//  Copyright © 2017年 mbApple. All rights reserved.
//

import UIKit


// MARK: - String
extension String {
    
    // 计算文本高度
    public func calculateTextHeight(maxWidth: CGFloat, textFont: UIFont, maxHeight: CGFloat = 0) -> CGFloat {
        
        let text = self as NSString
        return text.boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : textFont], context: nil).size.height
    }
    
    
    // 前几个子串
    public func substring(to:Int) -> String {
        if self.isEmpty == false {
            return String(self[..<self.index(self.startIndex, offsetBy: to)])
        }
        return self
    }
    
    
    // 后几个子串
    public func substring(from:Int) -> String {
        if self.isEmpty == false {
            return String(self[self.index(self.endIndex, offsetBy: -from)...])
        }
        return self
    }

    
    // 范围子串
    public func substring(with range: NSRange) -> String {
        if self.isEmpty {
            return ""
        }
        return (self as NSString).substring(with: range)
    }
    
    
    public func rangeOfString(searchString:String) -> NSRange {
        return (self as NSString).range(of: searchString)
    }
    
    
    public func rangeOfString(searchString:String,options:NSString.CompareOptions) -> NSRange {
        return (self as NSString).range(of: searchString,options: options)
    }
    
    
    
    // 判断url地址是否为全路径(http.....或者file)
    public func judgeStringisHttp() -> Bool {
        let range = self.rangeOfString(searchString: "^(http|https|file)://[/]?(([\\w-]+\\.)+)?[\\w-]+(/[\\w-./?%&=,@!~`#$%^&*,./]*)?$", options: .regularExpression)
        if range.location != NSNotFound {
            return true
        }
        return false
    }
    
    
    // Encode转码
    public func stringUsingUTF8Encoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    // Decond解码
    public func stringUsingDeconding() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    //获取字符串中的url地址
    public static func getUrls(str:String) -> [String] {
        var urls = [String]()
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:
                NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            // 匹配字符串，返回结果集
            let res = dataDetector.matches(in: str,
                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                           range: NSMakeRange(0, str.count))
            // 取出结果
            for checkingRes in res {
                urls.append((str as NSString).substring(with: checkingRes.range))
            }
        }
        catch {
            print(error)
        }
        return urls
    }
    
    // 从url中截取出参数
    public func urlParameters() -> [String: Any]? {
        // 判断是否有参数
        if !self.contains("?") { return nil }
        
        var params = [String: Any]()
        // 截取参数
        guard let paramsString = self.components(separatedBy: "?").last  else {
            return nil
        }
        
        if paramsString.contains("&") {
            //多个参数，分割参数
            let urlComponents = paramsString.components(separatedBy: "&")
            for keyValuePair in urlComponents {
                let pairComponents = keyValuePair.components(separatedBy: "=")
                if let key = pairComponents.first?.removingPercentEncoding, let value = pairComponents.last?.removingPercentEncoding {
                    params[key] = value
                }
            }
        } else {
            let pairComponents = paramsString.components(separatedBy: "=")
            
            if pairComponents.count == 1 {
                return nil
            }
            
            if let key = pairComponents.first?.removingPercentEncoding, let value = pairComponents.last?.removingPercentEncoding {
                params[key] = value
            }
            
        }
        
        return params
    }
    
    
    
    // 获取两个字串(subOne,subTwo)之间的 字符串
    public func getTwoSubstringFrom(subOne:String,subTwo:String) -> String {
        let searchString = String(format: "(?<=%@)([.[^ \\f\n\r\t\\v][ \\f\n\r\t\\v]]*)(?=%@)", subOne, subTwo)
        
        let range = self.rangeOfString(searchString: searchString, options: .regularExpression)
        if range.location != NSNotFound {
            return self.substring(with: range)
        }
        return ""
    }
    
    
    // 获取"="号后边的值
    public func getEqualAfterValue(string:String) -> String {
        let range = self.rangeOfString(searchString: String(format: "(?i)[^\\?&]?%@=[^&]+", string), options: .regularExpression)
        if range.location != NSNotFound {
            let str = self.substring(with: range)
            let array = str.components(separatedBy: "=")
            if array.count > 1{
                return array[1]
            }
            return ""
        }
        return ""
    }
    
    // 汉字首字符转拼音, 并且区首字母大写
    public func transformMandarinToLatin() -> String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        let sub = string.replacingOccurrences(of: " ", with: "")
        return sub.substring(to: 1).uppercased()
    }
    
    
}



// MARK: - NSMutableAttributedString
extension NSMutableAttributedString {
    
    /// 设置富文本
    ///
    /// - Parameters:
    ///   - string: 文本内容
    ///   - textSpace: 文本行间距
    ///   - textAlignment: 文本对齐方式
    ///   - textColor: 文本颜色
    ///   - textFont: 文本大小
    /// - Returns: attributedString
    public class func setAttributedString(string:String,textSpace:CGFloat,textAlignment:NSTextAlignment,textColor:UIColor,textFont:UIFont) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textSpace
        paragraphStyle.alignment = textAlignment
        let range = NSMakeRange(0, string.count)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor:textColor,NSAttributedStringKey.font:textFont,NSAttributedStringKey.paragraphStyle:paragraphStyle], range: range)
        
        return attributedString
    }
    
    ///设置富文本
    ///
    /// - Parameters:
    ///   - string: 文本内容
    ///   - textSpace: 文本行间距
    ///   - textAlignment: 文本对齐方式
    ///   - textColor: 文本颜色
    ///   - textFont: 文本大小
    ///   - subText: 子文本
    ///   - subTextFont: 子文本 大小
    ///   - subTextColor: 子文本颜色
    /// - Returns: attributedString
    public class func setAttributedString(string:String,textSpace:CGFloat,textAlignment:NSTextAlignment,textColor:UIColor,textFont:UIFont,subText:String,subTextFont:UIFont,subTextColor:UIColor) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textSpace
        paragraphStyle.alignment = textAlignment
        let range = NSMakeRange(0, string.count)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor:textColor,NSAttributedStringKey.font:textFont,NSAttributedStringKey.paragraphStyle:paragraphStyle], range: range)
        
        attributedString.setAttributes([.foregroundColor:subTextColor,.font:subTextFont,NSAttributedStringKey.paragraphStyle:paragraphStyle], range: string.rangeOfString(searchString: subText))
        
        return attributedString
        
    }
    
}

