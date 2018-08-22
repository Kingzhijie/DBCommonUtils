//
//  UIImageExtension.swift
//  BestProject
//
//  Created by mbApple on 2017/12/5.
//  Copyright © 2017年 mbApple. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    /// 设置字体图标
    ///
    /// - Parameters:
    ///   - iconCode: icon名字
    ///   - fontName: 图标库名字--默认
    ///   - width: 图标宽度
    ///   - color: 图标颜色
    /// - Returns: image
    public class func imageWithIcon(iconCode: String, fontName: String = "iconfont", width: CGFloat, color: UIColor) -> UIImage {
        let imageSize = CGSize(width: width, height: width)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: width))
        label.font = UIFont.init(name: fontName, size: width)
        label.text = iconCode
        label.textColor = color
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let retImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return retImg
    }
    
    //设置图片圆角
    public func circleImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        // 方形变圆形
        ctx?.addEllipse(in: rect)
        ctx?.clip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 生成图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 尺寸
    /// - Returns: image
    public static func imageWithColor(color:UIColor,size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public static func colorToImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    

    public func addImageFront(image:UIImage) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        image.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    
    // MARK: 压缩图片
    public func compressImage(_ newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
