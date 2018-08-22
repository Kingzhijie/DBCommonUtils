//
//  DB_CustomButton.swift
//  DBProject
//
//  Created by mbApple on 2018/2/9.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
public enum ButtonImagePosition {
    case top
    case right
    case left
    case bottom
}
public class DB_CustomButton: UIButton {
    public var position:ButtonImagePosition = .right
    public var space:CGFloat = 5

    /// 快速创建, 包含文字图片的button
    ///
    /// - Parameters:
    ///   - imagePosition: 图片所在的方向
    ///   - image: 图片
    ///   - space : 图片和文字的间距
    ///   - type: button类型
    ///   - title: 文字
    ///   - textColor: 文字颜
    ///   - textFont: 文字大小
    ///   - target: target对象
    ///   - action: 事件
    /// - Returns: button
    public class func creatButtonContainsImageAndTitle(image:UIImage,type:UIButtonType,title:String,textColor:UIColor,textFont:UIFont,target:Any?,action:Selector?) -> DB_CustomButton {
        let button = DB_CustomButton(type: type)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = textFont
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        return button
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        switch position {
        case .top:
            self.titleEdgeInsets = .zero
            self.titleLabel?.sizeToFit()
            self.imageView?.sizeToFit()
            var labelFrame:CGRect = self.titleLabel?.frame ?? CGRect()
            var imageFrame:CGRect = self.imageView?.frame ?? CGRect()
            imageFrame.origin.x = (self.frame.size.width - imageFrame.size.width) / 2
            imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height - labelFrame.size.height - space) / 2
            self.imageView?.frame = imageFrame
            labelFrame.origin.x = (self.frame.size.width - labelFrame.size.width) / 2
            labelFrame.origin.y = imageFrame.origin.y + imageFrame.size.height + space
            self.titleLabel?.frame = labelFrame
        case .left:
            self.titleLabel?.sizeToFit()
            self.imageView?.sizeToFit()
            var labelFrame:CGRect = self.titleLabel?.frame ?? CGRect()
            var imageFrame:CGRect = self.imageView?.frame ?? CGRect()
            imageFrame.origin.x = (self.frame.size.width - imageFrame.size.width - labelFrame.size.width - space) / 2
            imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height) / 2
            self.imageView?.frame = imageFrame
            labelFrame.origin.x = imageFrame.origin.x + imageFrame.size.width + space
            labelFrame.origin.y = (self.frame.size.height - labelFrame.size.height ) / 2
            self.titleLabel?.frame = labelFrame
        case .right:
            self.titleLabel?.sizeToFit()
            self.imageView?.sizeToFit()
            var labelFrame:CGRect = self.titleLabel?.frame ?? CGRect()
            var imageFrame:CGRect = self.imageView?.frame ?? CGRect()
            labelFrame.origin.x = (self.frame.size.width - imageFrame.size.width - labelFrame.size.width - space) / 2
            labelFrame.origin.y = (self.frame.size.height - labelFrame.size.height) / 2
            self.titleLabel?.frame = labelFrame
            imageFrame.origin.x = labelFrame.origin.x + labelFrame.size.width + space
            imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height) / 2
            self.imageView?.frame = imageFrame
        case .bottom:
            self.titleLabel?.sizeToFit()
            self.imageView?.sizeToFit()
            var labelFrame:CGRect = self.titleLabel?.frame ?? CGRect()
            var imageFrame:CGRect = self.imageView?.frame ?? CGRect()
            labelFrame.origin.x = (self.frame.size.width - labelFrame.size.width ) / 2
            labelFrame.origin.y = (self.frame.size.height - labelFrame.size.height - imageFrame.size.height - space)/2
            self.titleLabel?.frame = labelFrame
            imageFrame.origin.x = (self.frame.size.width - imageFrame.size.width) / 2
            imageFrame.origin.y = labelFrame.origin.y + labelFrame.size.height + space
            self.imageView?.frame = imageFrame
        }
        
        
    }

}
