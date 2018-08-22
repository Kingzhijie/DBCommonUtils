//
//  DB_CustomTagsView.swift
//  DBMerchantProject
//
//  Created by mbApple on 2018/3/20.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
public enum TagsViewStyle {
    case multiSelection  //多选
    case singleSelection  //单选
    case noSelection  //不可点击
}
public enum TagsAlignStyle { //对齐方式
    case left
    case right
    case center
}
//定义闭包类型
typealias ReturnSelectedTagTitlesArray = ([String]) ->Void
public class DB_CustomTagsView: UIView {
    public var totalHeight: CGFloat = 0.0  //标签总高度
    //标签在试图中---靠左靠右显示,默认靠左
    public var alignStyle: TagsAlignStyle = .left
    
    //btn上文字字体
    public var btnTextFont: UIFont = .systemFont(ofSize: 17)
    
    //单个btn的圆角值
    public var btnCornerRadiusValue: CGFloat = 5.0
    //边框的宽度
    public var borderWidth: CGFloat = 0.5
    
    //单个btn 文字左右两边距离btn左右边界的值
    public var btnHorizontalPadding: CGFloat = 10.0
    
    //单个btn 文字上下两边距离btn上下边界的值
    public var btnVerticalPadding: CGFloat = 5.0
    
    //btn之间的距离 (左右)
    public var btnHorizontalMargin: CGFloat = 10.0
    
    //btn之间的距离 (上下)
    public var btnVerticalMargin: CGFloat = 10.0
    
    //一行中，第一个tag距离左边边界的距离
    public var btnLeftMargin: CGFloat = 10.0
    
    //一行中，最后一个tag距离右边边界的最小距离
    public var btnRightMargin: CGFloat = 10.0
    
    //设置默认状态样式
    public var btnNormalTextColor: UIColor = .gray     //正常状态下
    public var btnNormalBackgroundColor: UIColor = .white       //正常状态下
    public var btnNormalBorderColor: UIColor = .gray     //正常状态下
    
    //设置点击标签状态样式
    public var btnSelectedTextColor: UIColor = .white    //选中状态下
    public var btnSelectedBackgroundColor: UIColor = .blue     //选中状态下
    public var btnSelectedBorderColor: UIColor = .clear      //选中状态下
    
    //设置不可点击标签的样式
    public var btnDefaultTextColor: UIColor = .gray   //默认btn状态
    public var btnDefaultBackgroundColor: UIColor = .lightGray      //默认btn状态
    public var btnDefaultBorderColor: UIColor = .gray      //默认btn状态

    //设置 “多选” “单选” “不能点击” 状态
    public var tagsStyle: TagsViewStyle = .noSelection
    
    private var lastFrame: CGRect = CGRect()    //记录frame
    private var allBtnTagsArray: [UIButton] = [] //存放所有的btn
    private var selectedTagTitlesArray: [String] = [] //选中的数组
    private var returnSelectedTagTitlesArrayBlock: ReturnSelectedTagTitlesArray?
    
    //闭包回掉方法
    public func returnSelectedTagTitlesArrayMethod(ReturnSelectedTagTitlesArrayFunction: @escaping (_ attributeType :[String])-> Void){
        returnSelectedTagTitlesArrayBlock = ReturnSelectedTagTitlesArrayFunction
    }
    
    
    // MARK: - 传入数据源, 默认无选中标签
    public func setTagsArray(array: [String]) {
        //防止重用,
        for(_, view) in subviews.enumerated() {
            view.removeFromSuperview()
        }
        self.allBtnTagsArray.removeAll()
        self.totalHeight = 0.0
        var lastBtnRect: CGRect = CGRect(x: Int(self.btnLeftMargin), y: 0, width: 0, height: 0)
        
        if alignStyle == .right {
            lastBtnRect = CGRect(x: self.bounds.size.width - self.btnRightMargin, y: 0, width: 0, height: 0)
        } else if alignStyle == .left {
            lastBtnRect = CGRect(x: Int(self.btnLeftMargin), y: 0, width: 0, height: 0)
        }else if alignStyle == .center{
            lastBtnRect = CGRect(x: Int(self.btnLeftMargin), y: 0, width: 0, height: 0)
        }
        
        self.lastFrame = lastBtnRect
        
        for index in 0..<array.count {
            let contentStr = array[index]
            setTagBtnWithTagTitle(tagTitle: contentStr,index: index)
        }
    }
    
    
    // MARK: - 传入数据源, tagsArray:全部标签数组, selectedTags: 默认选中的标签数组
    public func setTagsArray(tagsArray: [String], selectedTags: [String]) {
        self.setTagsArray(array: tagsArray)
        self.setSomeTagBtnsSelected(tagTitles: selectedTags)
    }
    
    // MARK: - 传入数据源 array:全部标签数组, selectedTagsArray: 默认选中的标签数组, noSelectArray:不可选标签数组
    public func setTagsArray(array: [String], selectedTagsArray: [String], noSelectArray: [String]) {
        if array.count > 0 {
            self.setTagsArray(array: array)
        }
        if selectedTagsArray.count > 0 {
            self.setSomeTagBtnsSelected(tagTitles: selectedTagsArray)
        }
        if noSelectArray.count > 0 {
            self.setDefaultTagBtnsAttributes(defaultTagsArray: noSelectArray)
        }
    }
    
    private func setSomeTagBtnsSelected(tagTitles: [String]) {
        
        self.selectedTagTitlesArray.removeAll()
        
        let tagTitleArray: [String] = tagTitles
        
        for btn in self.allBtnTagsArray {
            if tagTitleArray.contains((btn.titleLabel?.text ?? "")!) {
                self.setBtnSelectedState(btn: btn)
                self.selectedTagTitlesArray.append((btn.titleLabel?.text ?? "")!)
            }
        }
    }
    
    private func setDefaultTagBtnsAttributes(defaultTagsArray: [String]) {
        
        for btn in self.allBtnTagsArray {
            if defaultTagsArray.contains((btn.titleLabel?.text ?? "")!) {
                self.setBtnDefaultState(btn: btn)
            }
        }
    }
    
    private func setTagBtnWithTagTitle(tagTitle: String,index:Int) {
        let tagBtn: UIButton = UIButton(type: .custom)
        tagBtn.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        tagBtn.contentHorizontalAlignment = .center
        tagBtn.setTitle(tagTitle as String, for: .normal)
        tagBtn.titleLabel?.font = self.btnTextFont
        tagBtn.layer.cornerRadius = CGFloat(self.btnCornerRadiusValue)
        tagBtn.addTarget(self, action: #selector(tagBtnClickedAction(btn:)), for: .touchUpInside)
        tagBtn.tag = 1000 + index
        let attribute = [NSAttributedStringKey.font : self.btnTextFont]
        var tagTitleSize: CGSize = (tagTitle as NSString).size(withAttributes: attribute)
        tagTitleSize.width += CGFloat(self.btnHorizontalPadding * 2)
        tagTitleSize.height += CGFloat(self.btnVerticalPadding * 2)
        
        var tagNewRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        if alignStyle == .right {
            if (self.lastFrame.origin.x - tagTitleSize.width - self.btnHorizontalMargin - self.btnRightMargin < 0) {
                tagNewRect.origin = CGPoint(x: self.bounds.size.width - self.btnRightMargin - tagTitleSize.width, y: self.lastFrame.origin.y + tagTitleSize.height + self.btnVerticalMargin)
            } else {
                let magin: CGFloat = self.lastFrame.size.width > 0 ? self.btnHorizontalMargin : 0
                tagNewRect.origin = CGPoint(x: self.lastFrame.origin.x - tagTitleSize.width - magin, y: self.lastFrame.origin.y)
            }
        } else if alignStyle == .left {
            if CGFloat(self.lastFrame.origin.x) + CGFloat(self.lastFrame.size.width) + CGFloat(tagTitleSize.width) + CGFloat(self.btnHorizontalMargin) > CGFloat(self.bounds.size.width) - CGFloat(self.btnRightMargin) {
                tagNewRect.origin = CGPoint(x: CGFloat(self.btnLeftMargin), y: CGFloat(self.lastFrame.origin.y) + CGFloat(tagTitleSize.height) + CGFloat(self.btnVerticalMargin))
            } else {
                let magin: CGFloat = self.lastFrame.size.width > 0 ? self.btnHorizontalMargin : 0
                tagNewRect.origin = CGPoint(x: CGFloat(self.lastFrame.origin.x) + CGFloat(self.lastFrame.size.width) + magin, y: CGFloat(self.lastFrame.origin.y))
            }
        }else{ //居中暂时有问题
            if index > 0{
                let oldBtn = self.viewWithTag(1000 + index - 1) as? UIButton
                let magin: CGFloat = self.lastFrame.size.width > 0 ? self.btnHorizontalMargin : 0
                self.lastFrame.origin.x = self.lastFrame.size.width > 0 ? (self.lastFrame.origin.x - (oldBtn?.width ?? 0) / 2 - magin / 2) : self.lastFrame.origin.x
                if CGFloat(self.lastFrame.origin.x) + CGFloat(self.lastFrame.size.width) + CGFloat(tagTitleSize.width) + CGFloat(self.btnHorizontalMargin) > CGFloat(self.bounds.size.width) - CGFloat(self.btnRightMargin)  {
                    tagNewRect.origin = CGPoint(x: self.bounds.size.width/2 - self.btnRightMargin/2 - tagTitleSize.width/2, y: self.lastFrame.origin.y + tagTitleSize.height + self.btnVerticalMargin)
                }else{
                    oldBtn?.frame.origin.x = self.lastFrame.origin.x
                    tagNewRect.origin = CGPoint(x: self.lastFrame.origin.x + (oldBtn?.width ?? 0) + magin, y: self.lastFrame.origin.y)
                }
            }else{
                tagNewRect.origin = CGPoint(x: self.bounds.size.width/2 - self.btnRightMargin/2 - tagTitleSize.width/2, y: self.lastFrame.origin.y)
            }
        }
        
        tagNewRect.size = tagTitleSize
        tagBtn.frame = tagNewRect
        self.lastFrame = tagBtn.frame
        
        self.totalHeight = self.lastFrame.origin.y + self.lastFrame.height
        setHeight(view: self, height: self.totalHeight)
        setBtnNormalState(btn: tagBtn)
        self.allBtnTagsArray.append(tagBtn)
        self.addSubview(tagBtn)
    }
    
    
    @objc private func tagBtnClickedAction(btn: UIButton) {
        if self.tagsStyle == .noSelection {
            return
        } else if self.tagsStyle == .singleSelection {
            if self.selectedTagTitlesArray.contains((btn.titleLabel?.text)!) {
                
                let index = self.selectedTagTitlesArray.index(of: (btn.titleLabel?.text)!)
                self.selectedTagTitlesArray.remove(at: index!)
                setBtnNormalState(btn: btn)
                if self.returnSelectedTagTitlesArrayBlock != nil{
                    self.returnSelectedTagTitlesArrayBlock!(self.selectedTagTitlesArray)
                }
            } else {
                for btn in self.allBtnTagsArray {
                    if self.selectedTagTitlesArray.contains((btn.titleLabel?.text)!) {
                        
                        let index = self.selectedTagTitlesArray.index(of: (btn.titleLabel?.text)!)
                        self.selectedTagTitlesArray.remove(at: index!)
                        setBtnNormalState(btn: btn)
                    }
                }
                self.selectedTagTitlesArray.append((btn.titleLabel?.text)!)
                self.setBtnSelectedState(btn: btn)
                if self.returnSelectedTagTitlesArrayBlock != nil{
                    self.returnSelectedTagTitlesArrayBlock!(self.selectedTagTitlesArray)
                }
            }
        } else if self.tagsStyle == .multiSelection {
            if self.selectedTagTitlesArray.contains((btn.titleLabel?.text)!) {
                let index = self.selectedTagTitlesArray.index(of: (btn.titleLabel?.text)!)
                self.selectedTagTitlesArray.remove(at: index!)
                self.setBtnNormalState(btn: btn)
            } else {
                self.selectedTagTitlesArray.append((btn.titleLabel?.text)!)
                self.setBtnSelectedState(btn: btn)
            }
            if self.returnSelectedTagTitlesArrayBlock != nil {
                self.returnSelectedTagTitlesArrayBlock!(self.selectedTagTitlesArray)
            }
        } else {
            return
        }
        
    }
    //改变控件高度
    private func setHeight(view: UIView, height: CGFloat) {
        var tempFrame: CGRect = view.frame
        tempFrame.size.height = height
        view.frame = tempFrame
    }
    //设置btn正常展示属性
    private func setBtnNormalState(btn: UIButton) {
        btn.layer.borderColor = self.btnNormalBorderColor.cgColor
        btn.layer.borderWidth = borderWidth
        btn.setTitleColor(self.btnNormalTextColor, for: .normal)
        btn.backgroundColor = self.btnNormalBackgroundColor
        btn.isUserInteractionEnabled = true
    }
    //设置btn选中btn属性
    private func setBtnSelectedState(btn: UIButton) {
        btn.layer.borderColor = self.btnSelectedBorderColor.cgColor
        btn.layer.borderWidth = borderWidth
        btn.setTitleColor(self.btnSelectedTextColor, for: .normal)
        btn.backgroundColor = self.btnSelectedBackgroundColor
        btn.isUserInteractionEnabled = true
    }
    //设置默认btn属性
    private func setBtnDefaultState(btn: UIButton) {
        btn.layer.borderColor = self.btnDefaultBorderColor.cgColor
        btn.layer.borderWidth = borderWidth
        btn.setTitleColor(self.btnDefaultTextColor, for: .normal)
        btn.backgroundColor = self.btnDefaultBackgroundColor
        btn.isUserInteractionEnabled = false
    }
    
    

}
