//
//  UIImageViewExtension.swift
//  DBProject
//
//  Created by mbApple on 2018/2/5.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
import Kingfisher

public typealias ImageCompletionBlock = (_ image:UIImage?,_ error: NSError?)->Void

@objc extension UIImageView {
    
    //使用CAShapeLayer和UIBezierPath设置圆角
    public func roundedRectImageViewWithCornerRadius(cornerRadius:CGFloat,imageViewSize:CGSize) {
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: imageViewSize.width, height: imageViewSize.height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = bezierPath.cgPath
        self.layer.mask = layer
    }
    
    /// Kingfisher设置image, 裁剪方法
    ///
    /// - Parameters:
    ///   - imageUrl: image地址(相对,或者全路径)
    ///   - imageSize: image裁剪的宽高参数
    ///   - place: 占位image
    ///   - completionBlock: 图片加载成功的回调
    public func setImageUrl(_ imageUrl:String?,imageSize:CGSize,place:UIImage?,completionBlock: ImageCompletionBlock?)  {
        if imageUrl == nil || imageUrl?.isEmpty == true { self.image = place; return }
        
        let imageWidth = Float(imageSize.width)
        let imageHeight = Float(imageSize.height)
        var imageURL = imageUrl
        if imageURL?.judgeStringisHttp() == true { //如果是全路径
            imageURL = imageURL! + self.image_crop(width: imageWidth, height: imageHeight)
        }else{
//            imageURL = BaseImgURL + "/" + imageURL! + self.image_crop(width: imageWidth, height: imageHeight)
        }
        self.kf.setImage(with: URL.init(string: imageURL!), placeholder: place, completionHandler: { (image, error, cacheType, imageUrl) in
            if completionBlock != nil{
                completionBlock!(image,error)
            }
        })
    }
    
    
    /// Kingfisher设置image, 裁剪方法
    ///
    /// - Parameters:
    ///   - imageUrl: image地址(相对,或者全路径)
    ///   - imageWidth: image以width等比缩放
    ///   - place: 占位image
    ///   - completionBlock: 图片加载成功的回调
    public func setImageUrl(_ imageUrl:String?,imageWidth:CGFloat,place:UIImage?,completionBlock: ImageCompletionBlock?) {
        if imageUrl == nil || imageUrl?.isEmpty == true {
            self.image = place
            return
        }
        
        var imageURL = imageUrl
        if imageUrl?.judgeStringisHttp() == true { // 全路径
            imageURL = imageURL! + self.image_resize(resizeValue: Float(imageWidth))
        }else{
//            imageURL = BaseImgURL + "/" + imageURL! + self.image_resize(resizeValue: Float(imageWidth))
        }
        self.kf.setImage(with: URL.init(string: imageURL!), placeholder: place, completionHandler: { (image, error, cacheType, imageUrl) in
            if completionBlock != nil{
                completionBlock!(image,error)
            }
        })
    }
    
    /// Kingfisher设置image, 原图
    ///
    /// - Parameters:
    ///   - imageUrl: image地址(相对,或者全路径)
    ///   - place: 占位image
    ///   - completionBlock: 图片加载成功的回调
    public func setyuanTuImageUrl(_ imageUrl:String?,place:UIImage?,completionBlock: ImageCompletionBlock?) {
        if imageUrl == nil || imageUrl?.isEmpty == true {
            self.image = place
            return
        }
        
        var imageURL = imageUrl
        if imageUrl?.judgeStringisHttp() == true { // 全路径
            imageURL = imageURL! + self.image_yuanTu()
        }else{
//            imageURL = BaseImgURL + "/" + imageURL! + self.image_yuanTu()
        }
        
        self.kf.setImage(with: URL.init(string: imageURL!), placeholder: place, completionHandler: { (image, error, cacheType, imageUrl) in
            if completionBlock != nil{
                completionBlock!(image,error)
            }
        })
    }
    
    
    
    // MARK: 原图
    private func image_yuanTu() -> String {
        return "?x-oss-process=image/format,png/sharpen,100/interlace,1/quality,q_90"
    }
    
    
    // MARK: 裁剪
    private func image_crop(width: Float, height: Float) -> String {
        return String(format: "?x-oss-process=image/crop,x_0,y_0,w_%.f,h_%.f,g_center/format,png/sharpen,100/interlace,1/quality,q_90", width * 3, height * 3)
    }
    
    
    // MARK: 缩放 - 等比情况 按长边优先
    private func image_resize(resizeValue: Float) -> String {
        return String(format: "?x-oss-process=image/resize,lfit,w_%.f,limit_1/format,png/sharpen,100/interlace,1/quality,q_90", resizeValue * 3)
    }
    
}

