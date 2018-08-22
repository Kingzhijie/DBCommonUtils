//
//  MBProgressHUDProcotol.swift
//  DBMerchantProject
//
//  Created by mbApple on 2018/2/9.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD


public protocol MBProgressHUDProcotol {}

extension MBProgressHUDProcotol {

    
    /// 弹出提醒框(默认 1.5S 消失)
    ///
    /// - Parameter text: 提醒的内容
    public func showMessage(text:String,delay:TimeInterval = 1.5) {
        DispatchQueue.main.async {
            let view = kAppWindow as? UIView ?? UIView()
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.top = 200.scale()
            hud.detailsLabel.text = text
            hud.mode = .text
            hud.detailsLabel.font = UIFont.systemFont(ofSize: 14)
            hud.detailsLabel.numberOfLines = 0
            hud.bezelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            hud.detailsLabel.textColor = UIColor.white
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: delay)
        }
    }
    
    
    /// 网络加载
    ///
    /// - Parameter text: 提醒的加载的内容(默认 无)
    public func showLoading(text:String = "") {
        DispatchQueue.main.async {
            let view = kAppWindow as? UIView ?? UIView()
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = text
            hud.bezelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            hud.label.textColor = UIColor.white
            hud.contentColor = UIColor.white
            hud.removeFromSuperViewOnHide = true
        }
    }
    
    /// 消失加载框
    public func dismiss() {
        DispatchQueue.main.async {
            let forView = kAppWindow as? UIView ?? UIView()
            MBProgressHUD.hide(for: forView, animated: true)
        }
    }
    
}


