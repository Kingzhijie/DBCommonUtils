//
//  TableViewExtension.swift
//  DBMerchantProject
//
//  Created by mbApple on 2018/6/25.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
import MJRefresh

public let footerTitle = "—  宝贝虽有底线，生活无限可能  —"

extension UITableView{
    /** 开始刷新 header */
    public func beginHeaderRefreshing() {
        self.mj_header?.beginRefreshing()
    }
    
    // MARK: - 添加下拉刷新和上拉加载更多的方法
    public func addTableViewHeaderAndFooter(refreshingHeaderBlock:@escaping MJRefreshComponentRefreshingBlock,refreshingFooterBlock:@escaping MJRefreshComponentRefreshingBlock) {
        addTableViewHeaderRefresh(refreshingBlock:refreshingHeaderBlock)
        addTableViewFooterRefresh(refreshingBlock: refreshingFooterBlock)
    }
    
    // MARK: - 添加下拉刷新的方法＿
    public func addTableViewHeaderRefresh(refreshingBlock:@escaping MJRefreshComponentRefreshingBlock) {
        let mj_header = MJRefreshNormalHeader(refreshingBlock:refreshingBlock)
        mj_header?.lastUpdatedTimeLabel.isHidden = true
        self.mj_header = mj_header
    }
    
    // MARK: - 添加上拉加载更多的方法
    public func addTableViewFooterRefresh(refreshingBlock:@escaping MJRefreshComponentRefreshingBlock) {
        let tableFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
        tableFooter?.stateLabel.textColor = UIColor.lightGray
        tableFooter?.stateLabel.font = UIFont.systemFont(ofSize: 12)
        tableFooter?.setTitle(footerTitle, for: MJRefreshState.noMoreData)
        self.mj_footer = tableFooter
        self.mj_footer.isHidden = true
    }
    
    // MARK: - 添加下拉刷新的Gif方法
    public func addTableViewHeaderGif(refreshingBlock:@escaping MJRefreshComponentRefreshingBlock) {
        self.mj_header = RefreshGifHeader(refreshingBlock: refreshingBlock)
    }
    
    

    // MARK: - 刷新table 根据总数做是否隐藏footer
    ///
    /// - Parameters:
    ///   - isLastPage: 是否最后一页
    ///   - dataArray: 数据源
    public func reloadTableViewWithIsLastPage(isLastPage:Bool,dataArray:[Any]) {
        DispatchQueue.main.async {
            self.reloadData()
            if self.mj_header != nil{
                self.mj_header.endRefreshing()
            }
            if self.mj_footer != nil {
                self.mj_footer.endRefreshing()
                if dataArray.count > 0 {
                    self.mj_footer.isHidden = false
                    if isLastPage == true {
                        self.mj_footer.endRefreshingWithNoMoreData()
                    }else{
                        self.mj_footer.resetNoMoreData()
                    }
                }else{
                    self.mj_footer.isHidden = true
                }
            }
        }
    }
    
    // MARK: - 获取数据后, 添加页面, 空白占位图
    ///
    /// - Parameters:
    ///   - imageName: 占位图标的名字
    ///   - content: 占位文字
    ///   - type: 0代表图片, 1代表字体图片
    ///   - dataArray: 数据源
    public func addEmptyView(imageName:String,content:String,type:Int = 0,dataArray:[Any],tag:Int = 9999) {
        var emptyView = self.viewWithTag(tag) as? EmptyPlaceView
        if dataArray.count == 0 { //添加
            if emptyView == nil{
                emptyView = EmptyPlaceView(frame: CGRect(x: 0, y: 0, width: 200, height: 20), imageName: imageName, message: content,type:type)
                emptyView?.tag = tag
                emptyView?.centerX = self.width / 2
                emptyView?.centerY = self.centerY - 50.scale()
                self.addSubview(emptyView!)
            }
        }else{ //移除
            if emptyView != nil{
                emptyView?.removeFromSuperview()
                emptyView = nil
            }
        }
    }
    
}


//MARK:- 空白占位图
class EmptyPlaceView: UIView {
    private lazy var placeImage: UIImageView = {
        let placeImage = UIImageView()
        placeImage.contentMode = .scaleAspectFit
        return placeImage
    }()
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    init(frame: CGRect,imageName:String,message:String,type:Int = 0) {
        super.init(frame: frame)
        self.addSubview(placeImage)
        if type == 0 {
            placeImage.image = UIImage.init(named: imageName)
        }else if type == 1{
            placeImage.image = UIImage.imageWithIcon(iconCode: imageName, width: 117.scale(), color: UIColor.hexColor("ECECEC"))
        }
        placeImage.frame = CGRect(x: 0, y: 0, width: 110.scale(), height: 110.scale())
        placeImage.centerX = self.centerX
        
        self.addSubview(messageLabel)
        messageLabel.attributedText = NSMutableAttributedString.setAttributedString(string: message, textSpace: 5.scale(), textAlignment: .center, textColor: UIColor.hexColor("999999"), textFont: UIFont.fontRegular(ofSize: 14.scale()))
        messageLabel.frame = CGRect(x: 0, y: placeImage.bottom + 20.scale(), width: frame.size.width, height: 20)
        messageLabel.sizeToFit()
        messageLabel.centerX = self.centerX
        self.height = 110.scale() + 20.scale() + messageLabel.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- 自定义刷新gif图的工具类
class RefreshGifHeader: MJRefreshGifHeader {
    private var normolImages = [UIImage]()
    private var refreshingImages = [UIImage]()
    //MARK: - 重写父类的方法
    override func prepare() {
        super.prepare()
        //设置普通状态 gif
        for i in 1..<60 {
            let normalImage = UIImage.init(named: "dropdown_anim__000\(i)")
            if normalImage != nil{
                normolImages.append(normalImage!)
            }
        }
        self.setImages(normolImages,for: .idle)
        
        //设置正在刷新中的 gif
        for i in 1...3 {
            let normalImage = UIImage.init(named: "dropdown_loading_0\(i)")
            if normalImage != nil{
                refreshingImages.append(normalImage!)
            }
        }
        self.setImages(refreshingImages,for: .pulling)
        self.setImages(refreshingImages,for: .refreshing)
        
        self.lastUpdatedTimeLabel.isHidden = true
        self.stateLabel.isHidden = true
    }
}


