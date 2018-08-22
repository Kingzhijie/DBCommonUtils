//
//  QRCodeView.swift
//  DBProject
//
//  Created by xiaoxiaoniuzai on 2018/1/8.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit

public protocol QRCodeViewDataSource: class {
    
    func viewForNavigation(_ codeView: QRCodeView) -> UIView?
    func viewForScan(_ codeView: QRCodeView) -> (scanView:UIView, scanBackView: UIView)
    func viewForFunction(_ codeView: QRCodeView) -> UIView?
    
}


public class QRCodeView: UIView {

    private(set) var navigationView: UIView!
    private(set) var functionView: UIView!
    private(set) var scanBackView: UIView!
    private(set) var scanView: UIView!
    
    public weak var dataSource: QRCodeViewDataSource? {
        didSet {
            if let dataSource = dataSource {
                
                navigationView = dataSource.viewForNavigation(self)
                addSubview(navigationView)
                
                scanView = dataSource.viewForScan(self).scanView
                scanBackView = dataSource.viewForScan(self).scanBackView
                addSubview(scanBackView)
                
                functionView = dataSource.viewForFunction(self)
                addSubview(functionView)
                
                addBackgroundView()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        dataSource = nil
    }
    
    
}


extension QRCodeView {
    
    fileprivate func addBackgroundView() {
        
        let topMargin = (scanBackView.frame.height - scanView.frame.height) * 0.5
        let topView = UIView(frame: CGRect(x: frame.minX, y: navigationView.frame.maxY, width: frame.width, height: topMargin))
        topView.backgroundColor = UIColor.rgb_Color(red: 0, green: 0, blue: 0, alpha: 0.55)
        insertSubview(topView, belowSubview: navigationView)
        
        let margin = (frame.width - scanView.frame.width) * 0.5
        let rightView = UIView(frame: CGRect(x: scanView.frame.maxX, y: topView.frame.maxY, width: margin, height: scanView.frame.height))
        rightView.backgroundColor = topView.backgroundColor
        insertSubview(rightView, belowSubview: navigationView)
        
        let leftView = UIView(frame: CGRect(x: topView.frame.minX, y: rightView.frame.minY, width: margin, height: rightView.frame.height))
        leftView.backgroundColor = topView.backgroundColor
        insertSubview(leftView, belowSubview: navigationView)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: leftView.frame.maxY, width: frame.width, height: topMargin))
        bottomView.backgroundColor = topView.backgroundColor
        insertSubview(bottomView, belowSubview: navigationView)
        
    }
}

