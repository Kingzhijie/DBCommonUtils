//
//  UINavigationControllerExtension.swift
//  XJDProject
//
//  Created by mbApple on 2018/1/8.
//  Copyright © 2018年 panda誌. All rights reserved.
//

import UIKit

extension UINavigationController{
    
    public class func initializeOnceMethod() {
        let originalMethod = class_getInstanceMethod(self,#selector(pushViewController(_ :animated:)))
        let swizzledMethod = class_getInstanceMethod(self, #selector(mb_pushViewController(_ :animated:)))
        method_exchangeImplementations(originalMethod!,swizzledMethod!)
    }
 
    open override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = UINavigationBar.appearance()
        navBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:UIColor.black]
        
        
        let lineView = self.getLineViewInNavigationBar(barView: self.navigationBar)
        if lineView != nil && lineView?.frame != nil{
           lineView?.isHidden = true
        }
        
    }
    
    private func getLineViewInNavigationBar(barView:UIView) -> UIImageView? {
        if barView is UIImageView && barView.bounds.size.height <= 1.0 {
            return barView as? UIImageView
        }
        
        for subView in barView.subviews {
            let imgView = self.getLineViewInNavigationBar(barView: subView)
            if imgView != nil {
                return imgView
            }
        }
        return nil
    }
    
    @objc private func mb_pushViewController(_ viewController:UIViewController, animated:Bool) {
        if self.viewControllers.count > 0 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithNormalImage(normalImage: UIImage.imageWithIcon(iconCode: "\u{e611}", width: 20, color: UIColor.hexColor("333333")), highImage: nil, target: self, action: #selector(back), size: CGSize(width: 20, height: 20), adjust:true)
            viewController.hidesBottomBarWhenPushed = true
        }
        self.mb_pushViewController(viewController, animated: animated)
        // 适配 iPhone X Push 过程中 TabBar 位置上移
        if (iphoneX) {
            var frame = self.tabBarController?.tabBar.frame
            let tabheight = frame?.size.height ?? 83
            frame?.origin.y = UIScreen.main.bounds.size.height - tabheight
            self.tabBarController?.tabBar.frame = frame!
        }
    }
    @objc private func back() {
        self.popViewController(animated: true)
    }
    
    // MARK: - 解决ios9.0第三方右滑返回导航栏消失
    open override var childViewControllerForStatusBarStyle: UIViewController?{
        return self.visibleViewController
    }
    
}


