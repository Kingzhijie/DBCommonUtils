//
//  UIButtonExtension.swift
//  SwiftRuntime
//
//  Created by charles on 2017/5/11.
//  Copyright © 2017年 charles. All rights reserved.
//

import UIKit

//MARK 快速创建button
extension UIButton{
    

    /// 一. 快速创建button
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - title: 标题
    ///   - textColor: 标题颜色
    ///   - backgroundColor: 背景颜色
    ///   - textFont: 字体大小
    ///   - target:  target对象
    ///   - action: action
    /// - Returns: UIButton
   public class func creatNormolButton(type:UIButtonType,title:String,textColor:UIColor,textFont:UIFont,target:Any?,action:Selector?) -> UIButton {
        let button = UIButton(type: type)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = textFont
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        return button
    }
    
    /// 二. 快速创建button
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - image: buttonImage
    ///   - target: target对象
    ///   - action: action
    /// - Returns: UIButton
    public class func creatImageButton(type:UIButtonType,image:UIImage,highImage:UIImage?,target:Any?,action:Selector) -> UIButton {
        let button = UIButton(type: type)
        button.setImage(image, for: .normal)
        button.setImage(highImage, for: .highlighted)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    /// 三. 快速创建button
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - title: 标题
    ///   - textColor: 字体颜色
    ///   - textFont: 字体大小
    ///   - target: target对象
    ///   - action: action
    /// - Returns: UIButton
    public class func creatLineButton(type:UIButtonType,title:String,textColor:UIColor,textFont:UIFont,target:Any?,action:Selector) -> UIButton {
        let btn = UIButton(type: type)
        let str1 = NSMutableAttributedString(string: title)
        let range1 = NSRange(location: 0, length: str1.length)
        let number = NSNumber(value:NSUnderlineStyle.styleSingle.rawValue)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
        str1.addAttribute(NSAttributedStringKey.underlineStyle, value: number, range: range1)
        str1.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: range1)
        str1.addAttribute(NSAttributedStringKey.font, value: textFont, range: range1)
        btn.setAttributedTitle(str1, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    
    //自定义button倒计时
    public func timerCount(_ time: NSInteger, _ title:String = "重新获取", _ ableTitleColor:UIColor = UIColor.hexColor("3791FF"), _ unableTitleColor:UIColor = UIColor.hexColor("999999"), completion: (() -> Swift.Void)? = nil) {
        
        var timeCount = time
        let codeTimer = DispatchSource.makeTimerSource(queue:      DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        codeTimer.setEventHandler(handler: {
            // 时间到了取消时间源
            if timeCount <= 0 {
                codeTimer.cancel()
                // 返回主线程处理一些事件，更新UI等等
                DispatchQueue.main.async {
                    self.isEnabled = true
                    self.isSelected = true
                    self.setTitleColor(ableTitleColor, for: .normal)
                    self.setTitle(title, for: .normal)
                    if let block = completion {
                        block()
                    }
                }
            } else {
                
                // 返回主线程处理一些事件，更新UI等等
                DispatchQueue.main.async {
                    self.isEnabled = false
                    self.isSelected = false
                    self.setTitleColor(unableTitleColor, for: .normal)
                    self.setTitle("\(timeCount)s", for: .normal)
                }
                // 每秒计时一次
                timeCount -= 1
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
    
}

