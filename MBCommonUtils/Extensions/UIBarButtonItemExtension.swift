//
//  UIBarButtonItemExtension.swift
//  BestProject
//
//  Created by mbApple on 2017/12/4.
//  Copyright © 2017年 mbApple. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 自定义, 导航左右按钮(图标)
    ///
    /// - Parameters:
    ///   - normalImage: 正常图片
    ///   - highImage: 高亮图片
    ///   - target: target
    ///   - action: Selector
    ///   - size: size图标的尺寸
    ///   - adjust: adjust调整图标的位置
    /// - Returns: 对应的UIBarButtonItem
    public class func itemWithNormalImage(normalImage:UIImage?,highImage:UIImage?,target:Any,action:Selector,size:CGSize, adjust:Bool = false) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        if adjust {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 26)
        }
        button.setImage(normalImage, for: .normal)
        button.setImage(highImage, for: .highlighted)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem.init(customView: button)
    }
    
    /// 自定义, 导航左右按钮(文本)
    ///
    /// - Parameters:
    ///   - title: 文字
    ///   - titleColor: 文字颜色
    ///   - fontSize: 文字大小
    ///   - target: target
    ///   - action: action
    ///   - size: 大小尺寸
    /// - Returns: 对应的UIBarButtonItem
    public class func itemWithTitle(title:String,titleColor:UIColor,fontSize:CGFloat,target:Any,action:Selector,size:CGSize) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem.init(customView: button)
    }
    

}
