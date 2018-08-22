//
//  UIViewExtension.swift
//  BestProject
//
//  Created by mbApple on 2017/12/4.
//  Copyright © 2017年 mbApple. All rights reserved.
//

import UIKit


extension UIView {
    
    /// removes all subviews.
    public func removeAllSubviews(){
        while self.subviews.count != 0 {
            let child = self.subviews.last
            child?.removeFromSuperview()
        }
    }
    
    /// add subviews
    ///
    /// - Parameter views: [view 数组]
    public func addSubviews(views:[UIView]) {
        for childView in views {
            self.addSubview(childView)
        }
    }
    
    //设置阴影
    public func diffusionShadowForView(alpha: CGFloat = 0.2, color: UIColor, shadowRadius: CGFloat = 10.0, shadowOffset: CGSize = CGSize(width: 0, height: 0)) {
        // shadowColor阴影颜色
        self.layer.shadowColor = color.cgColor
        // shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOffset = CGSize(width: shadowOffset.width, height: shadowOffset.height)
        // 阴影透明度，默认0
        self.layer.shadowOpacity = Float(alpha)
        // 阴影半径，默认3
        self.layer.shadowRadius = shadowRadius
    }
    
    // 设置颜色渐变
    public class func setGradientColor(startColor: UIColor, endColor: UIColor, viewFrame: CGRect) ->(CAGradientLayer) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = viewFrame
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        return gradientLayer
    }
    //设置圆角
    public func addCorner(corners:UIRectCorner, cornerRadi:CGSize,viewSize:CGSize) {
        let maskPath = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: viewSize.width, height:viewSize.height), byRoundingCorners: corners, cornerRadii: cornerRadi)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect.init(x: 0, y: 0, width: viewSize.width, height:viewSize.height)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //设置控件的虚线
    public func setViewDottedLineBorder(lineColor:UIColor,corner:CGFloat,lineWidth:CGFloat) {
        let border = CAShapeLayer()
        border.strokeColor = lineColor.cgColor
        border.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: corner)
        border.path = path.cgPath
        border.frame = self.bounds
        border.lineWidth = lineWidth
        border.lineDashPattern = [1,1]
        self.layer.addSublayer(border)
    }
}



extension UIView {
    //左边界
    public var left:CGFloat{
        get{
            return self.frame.origin.x
        }
        set(newLeft){
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    //上边界
    public var top:CGFloat{
        get{
            return self.frame.origin.y
        }
        set(newTop){
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    //右边界
    public var right:CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set(newRight){
            var frame = self.frame
            frame.origin.x = newRight - frame.size.width
            self.frame = frame
        }
    }
    //下边界
    public var bottom:CGFloat{
        get{
            return self.frame.origin.y + self.frame.size.height
        }
        set(newBottom){
            var frame = self.frame
            frame.origin.y = newBottom - frame.size.height
            self.frame = frame
        }
    }
    //宽度
    public var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set(newWidth){
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    //高度
    public var height:CGFloat{
        get{
            return self.frame.size.height
        }
        set(newHeight){
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    //中心 (x)
    public var centerX:CGFloat{
        get{
            return self.center.x
        }
        set(newCenterX){
            self.center = CGPoint(x: newCenterX, y: self.center.y)
        }
    }
    //中心 (y)
    public var centerY:CGFloat{
        get{
            return self.center.y
        }
        set(newCenterY){
            self.center = CGPoint(x: self.center.x, y: newCenterY)
        }
    }
    
    public var origin:CGPoint{
        get{
            return self.frame.origin
        }
        set(newOrigin){
            var frame = self.frame
            frame.origin = newOrigin
            self.frame = frame
        }
    }
    
    public var size:CGSize{
        get{
            return self.frame.size
        }
        set(newSize){
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    }
    
    
}

// MARK: - UILabel
extension UILabel{
    /// 快速创建label
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - textColor: 文字颜色
    ///   - line: 行数
    ///   - textFont: 字体大小
    ///   - alignment: 对齐方式
    /// - Returns: label
    public class func creatNormolLabel(text:String,textColor:UIColor,line:NSInteger,textFont:UIFont,alignment:NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = textFont
        label.textAlignment = alignment
        label.numberOfLines = line
        return label
    }
    
}


// MARK: - UITextField
extension UITextField {
    /// 快速创建 UITextField
    ///
    /// - Parameters:
    ///   - place: 占位文字
    ///   - placeColor: 占位文字颜色
    ///   - font: 字体
    ///   - textColor: 文本颜色
    /// - Returns: UITextField
    public class func creatTextField(place:String,placeColor:UIColor,font:UIFont,textColor:UIColor) -> UITextField {
        let defaultFieid = UITextField()
        defaultFieid.font = font
        defaultFieid.textColor = textColor
        let Placeholder = NSAttributedString(string: place, attributes: [NSAttributedStringKey.foregroundColor:placeColor])
        defaultFieid.attributedPlaceholder = Placeholder
        return defaultFieid
    }
    
    
    /// 快速创建 UITextField
    ///
    /// - Parameters:
    ///   - place: 占位文字
    ///   - placeColor: 占位文字颜色
    ///   - font: 字体大小
    ///   - textColor: 文本颜色
    ///   - leftInset: 输入框文本  左边缩进
    ///   - cornerRadius: 输入框圆角弧度
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    /// - Returns: UITextField
    public class func creatTextField(place:String,placeColor:UIColor,font:CGFloat,textColor:UIColor,leftInset:CGFloat,cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor) -> UITextField {
        let defaultFieid = UITextField()
        defaultFieid.font = UIFont.systemFont(ofSize: font)
        defaultFieid.textColor = textColor
        defaultFieid.layer.cornerRadius = cornerRadius
        let Placeholder = NSAttributedString(string: place, attributes: [NSAttributedStringKey.foregroundColor:placeColor])
        defaultFieid.attributedPlaceholder = Placeholder
        if borderWidth > 0 {
            defaultFieid.layer.borderWidth = borderWidth
            defaultFieid.layer.borderColor = borderColor.cgColor
        }
        if leftInset > 0 {
            defaultFieid.leftViewMode = .always
            let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 25))
            leftLabel.backgroundColor = .clear
            defaultFieid.leftView = leftLabel
        }
        return defaultFieid
    }
    
    
}


