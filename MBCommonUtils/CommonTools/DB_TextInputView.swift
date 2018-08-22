//
//  DB_TextInputView.swift
//  DBMerchantProject
//
//  Created by mbApple on 2018/5/17.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

public class DB_TextInputView: UIView ,UITextViewDelegate{
    
    public var maxCount:Int?{
        didSet{
            if maxCount != nil {
                countLabel.isHidden = false
                countLabel.attributedText = NSMutableAttributedString.setAttributedString(string: "0/\(maxCount!)", textSpace: 1, textAlignment: .right, textColor: UIColor.hexColor("9B9B9B"), textFont: UIFont.fontRegular(ofSize: 12.scale()), subText: "0", subTextFont: UIFont.fontRegular(ofSize: 12.scale()), subTextColor: UIColor.hexColor("555555"))
            }else{
                countLabel.isHidden = true
            }
        }
    }
    
    public var placeStr = ""{
        didSet{
            placeLabel.text = placeStr
        }
    }
    
    public var titleName = "标题"{
        didSet{
            titleLabel.text = titleName
        }
    }
    
    
    public var inputContentResultBlock:((_ content:String)->Void)?
    
    
    private lazy var backView: UIView = {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: KscreenWidth, height: KscreenHeight))
        backView.backgroundColor = UIColor.hexColor("111111")
        backView.alpha = 0.3
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(tap:)))
        backView.addGestureRecognizer(tap)
        return backView
    }()
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.hexColor("3791FF")
        return lineView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel.creatNormolLabel(text: "标题", textColor: UIColor.hexColor("041D29"), line: 1, textFont: UIFont.fontMedium(ofSize: 16.scale()), alignment: .left)
        return label
    }()
    private lazy var sureBtn: UIButton = {
        let btn = UIButton.creatNormolButton(type: .custom, title: "确认", textColor: UIColor.hexColor("3791FF"), textFont: UIFont.fontRegular(ofSize: 14.scale()), target: self, action: #selector(sureAction(btn:)))
        return btn
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.hexColor("F9FAFB")
        textView.textColor = UIColor.hexColor("333333")
        textView.font = UIFont.fontRegular(ofSize: 14.scale())
        textView.delegate = self
        textView.returnKeyType = .done
        textView.contentInset = UIEdgeInsetsMake(0, 5.scale(), 5.scale(), 5.scale())
        return textView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel.creatNormolLabel(text: "请输入内容", textColor: UIColor.hexColor("9B9B9B"), line: 1, textFont: UIFont.fontRegular(ofSize: 14.scale()), alignment: .left)
        return label
    }()
    
    private var content = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: KscreenHeight, width: KscreenWidth, height: 176.scale())
        self.layer.cornerRadius = 6.scale()
        self.backgroundColor = UIColor.white
        self.addSubviews(views: [lineView,titleLabel,sureBtn,textView,countLabel])
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(15.scale())
            make.top.equalTo(19.scale())
            make.width.equalTo(2.scale())
            make.height.equalTo(17.scale())
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(8.scale())
            make.centerY.equalTo(lineView)
        }
        sureBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15.scale())
            make.centerY.equalTo(lineView)
            make.width.equalTo(30.scale())
            make.height.equalTo(25.scale())
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(15.scale())
            make.right.equalTo(-15.scale())
            make.top.equalTo(55.scale())
            make.height.equalTo(104.scale())
        }
        textView.addSubview(placeLabel)
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-21.scale())
            make.bottom.equalTo(-18.scale())
        }
        placeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10.scale())
            make.top.equalTo(7.scale())
        }
        
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: textView delegate方法
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
           placeLabel.isHidden = false
        }else{
            placeLabel.isHidden = true
        }
        
        if maxCount != nil && textView.text.count > maxCount! {
            textView.text = textView.text.substring(to: maxCount!)
        }
        let count = (maxCount ?? 0) - textView.text.count
        countLabel.attributedText = NSMutableAttributedString.setAttributedString(string: "\(count)/\(maxCount!)", textSpace: 1, textAlignment: .right, textColor: UIColor.hexColor("9B9B9B"), textFont: UIFont.fontRegular(ofSize: 12.scale()), subText: "\(count)", subTextFont: UIFont.fontRegular(ofSize: 12.scale()), subTextColor: UIColor.hexColor("555555"))
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        content = textView.text
        if content.count > 0 {
            inputContentResultBlock?(content)
        }
    }
   
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        if text == "\n" { //回收键盘
            return dismissViewAction()
        }
        if maxCount != nil && textView.text.count >= maxCount!{
            return false
        }
        return true
    }
    
    @objc private func sureAction(btn:UIButton) {
        _ = dismissViewAction()
    }
    
    public func show() {
        kAppWindow??.addSubviews(views: [backView,self])
        self.textView.becomeFirstResponder()
    }
    
    // MARK: - 键盘事件
    @objc fileprivate func keyboardWillShow(_ noti: Notification) {
        keyboardStatu(noti, isShow: true)
    }
    
    @objc fileprivate func keyboardWillHide(_ noti: Notification) {
        keyboardStatu(noti, isShow: false)
    }
    
    fileprivate func keyboardStatu(_ noti: Notification, isShow: Bool) {
        let keyboardRect = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, animations: {
            if isShow{
                self.top = KscreenHeight - keyboardRect.height - 170.scale()
            }else{
                self.backView.removeFromSuperview()
                self.top = KscreenHeight
            }
        }) { (finish) in
            if !isShow{
                self.removeFromSuperview()
            }
        }
    }
    
    @objc private func tapView(tap:UITapGestureRecognizer) {
       _ = dismissViewAction()
    }
    
    private func dismissViewAction() ->Bool{
        return textView.resignFirstResponder()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
