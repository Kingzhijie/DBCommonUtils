//
//  UIFontExtension.swift
//  MBCommonUtils
//
//  Created by nz on 2018/7/25.
//  Copyright © 2018年 xiaoxiaoniuzai. All rights reserved.
//

import UIKit


extension UIFont{
    
    public enum FontStyle: String {
        case fontRegular = "PingFangSC-Regular"
        case fontMedium = "PingFangSC-Medium"
        case fontBold = "PingFangSC-Semibold"
        case fontLight = "PingFangSC-Light"
        case agency = "Agency FB"
    }
    
    
    /// 常用文本字体 默认的是常规体 Regular
    ///
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    public class func fontRegular(ofSize size:CGFloat) -> UIFont {
        return UIFont.init(name: FontStyle.fontRegular.rawValue, size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    
    /// 常用文本字体 默认的是常规体 Medium
    ///
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    public class func fontMedium(ofSize size:CGFloat) -> UIFont {
        return UIFont.init(name: FontStyle.fontMedium.rawValue, size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    
    /// 常用文本字体 默认的是常规体 Bold
    ///
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    public class func fontBold(ofSize size:CGFloat) -> UIFont {
        return UIFont.init(name: FontStyle.fontBold.rawValue, size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    
    /// 常用文本字体 默认的是常规体 Light
    ///
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    public class func fontLight(ofSize size:CGFloat) -> UIFont {
        return UIFont.init(name: FontStyle.fontLight.rawValue, size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    
    /// 特殊字体 数字
    ///
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    public class func fontAgency(ofSize size:CGFloat) -> UIFont {
        return UIFont.init(name: FontStyle.agency.rawValue, size: size) ?? UIFont.systemFont(ofSize:size)
    }
}
