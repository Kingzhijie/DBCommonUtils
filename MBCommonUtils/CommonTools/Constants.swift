//
//  Constants.swift
//  MBCommonUtils
//
//  Created by nz on 2018/7/26.
//  Copyright © 2018年 xiaoxiaoniuzai. All rights reserved.
//

import UIKit

// MARK: 屏幕尺寸
public let KscreenWidth = UIScreen.main.bounds.size.width
public let KscreenHeight = UIScreen.main.bounds.size.height


// MARK: 当前APP版本号
public let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
// MARK: app名称
public let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "APP"
// MARK: Window
public let kAppWindow = UIApplication.shared.delegate?.window


// MARK: 服务器状态码
public let msgCode = "code"  // 状态码
public let successCode = "200"  // 成功
public let loginCode = "401" // 请登录


// MARK: UserDefault Keys
public let userDefaultKey_isLogin = "isLogin" // 是否登录
public let userDefaultKey_loginToken = "loginToken" // 用户token


// MARK: Notification Names
public let notiName_loginSuccess = "notiName_loginSuccess" // 登入
public let notiName_logoutSuccess = "notiName_logoutSuccess" // 登出


// iPhone X
public let iphoneX = (KscreenWidth == 375.0 && KscreenHeight == 812.0)
// Status bar height.
public let StatusBarHeight: CGFloat = (iphoneX ? 44.0 : 20.0)
// Navigation bar height.
public let NavigationBarHeight: CGFloat = 44.0
// Tabbar height.
public let TabbarHeight: CGFloat = (iphoneX ? (49.0 + 34.0) : 49.0)
// Tabbar safe bottom margin.
public let TabbarSafeBottomMargin: CGFloat = (iphoneX ? 34.0 : 0.01)
// Status bar & navigation bar height.
public let StatusBarAndNavigationBarHeight: CGFloat = (iphoneX ? 88.0 : 64.0)


// MARK: 延迟
public func delay(_ timeInterval: TimeInterval, _ block: @escaping ()->Void) {
    
    let after = DispatchTime.now() + timeInterval
    DispatchQueue.main.asyncAfter(deadline: after, execute: block)
}

// MARK: 通用蒙版
public class NZCoverView: UIView {
    
    public var coverViewDidTap: (()->())?
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        coverViewDidTap?()
    }
}
