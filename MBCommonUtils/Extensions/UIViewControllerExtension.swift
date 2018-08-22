//
//  UIViewControllerExtension.swift
//  XJDProject
//
//  Created by mbApple on 2018/1/10.
//  Copyright © 2018年 panda誌. All rights reserved.
//

import UIKit

extension UIViewController {
    //获取当前的viewController
    public class func currentController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentController(base: presented)
        }
        return base
    }
}
