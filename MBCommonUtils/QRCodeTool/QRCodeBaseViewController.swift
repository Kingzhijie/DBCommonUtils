//
//  QRCodeBaseViewController.swift
//  DBProject
//
//  Created by xiaoxiaoniuzai on 2018/1/8.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
import Photos

public class QRCodeBaseViewController: UIViewController, QRCodeViewDataSource {

    // MARK: - 可配置属性
    /// 是否开启本地相册扫码
    public var isOpenPhotoAlbum = false
    /// 是否需要照明
    public var isOpenFlashLight = false
    /// 扫描框宽度
    public var scanViewWidth = 240.scale()
    /// 扫描框高度
    public var scanViewHeight = 240.scale()
    /// 扫描框到顶部的高度
    public var scanViewTopHeight = 120.scale()
    /// 导航标题
    public var navigationTitle: String?
    /// 扫描提示语
    public var message: String?
    /// 四角颜色
    public var cornerColor = UIColor.rgb_Color(red: 55, green: 145, blue: 255, alpha: 1.0)
    /// 扫描类型---默认二维码
    public var scanType: QRCodeScanType = .qrcode
    /// 扫描/识别结果
    public var scanResult: ((String)->())?
    /// 扫描/识别工具
    private(set) var qrcodeTool: QRCodeTool = QRCodeTool()
    
    fileprivate var scanImageView: UIImageView!
    fileprivate var isStop = false
    
    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()

        setup()
        let codeView = QRCodeView(frame: self.view.frame)
        codeView.dataSource = self
        startAnimating()
        view.addSubview(codeView)

        qrcodeTool.checkAuthorization(authored: { [weak self] in
            
                self?.qrcodeTool.setRectOfInterest(originRect: CGRect(x: codeView.scanView.frame.minX, y: codeView.navigationView.frame.maxY + codeView.scanView.frame.minY, width: codeView.scanView.frame.width, height: codeView.scanView.frame.height))
            
            self?.qrcodeTool.scanQRCode(inView: codeView, scanType: (self?.scanType)!, scanCompletion: { [weak self] (resultStr: String) in
                    self?.navigationController?.popToRootViewController(animated: false)
                    self?.scanResult?(resultStr)
                })
            
            }, unauthored: {
             
                
                let title = "请前往”设置-隐私-相机“选项中，允许\(appName)访问你的相机"
                self.unAuthorizedHud(with: title)
                
            })
        

    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        controlAnimating(true)
    }
    
    deinit {
        qrcodeTool.setTorch(isOn: false)
    }

    
    // MARK: - Public Methods
    public func setup() {
        
        view.backgroundColor = UIColor.rgb_Color(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    // MARK: - QRCodeViewDataSource
    public func viewForNavigation(_ codeView: QRCodeView) -> UIView? {
        return createInitializeNavigationView(codeView)
    }
    
    public func viewForScan(_ codeView: QRCodeView) -> (scanView: UIView, scanBackView: UIView) {
        return createInitializeScanView(codeView)
    }

    public func viewForFunction(_ codeView: QRCodeView) -> UIView? {
        return createInitializeFunctionView(codeView)
    }
    
    public func startScanning() {
        qrcodeTool.startScan()
    }
    
    public func stopScanning() {
        qrcodeTool.stopScan()
    }
    
    @objc public func startAnimating() {
        
        if isStop {
            return
        }
        
        UIView.animate(withDuration: 2.5, animations: {
            self.scanImageView.origin.y = (self.scanImageView.superview?.frame.height)!
        }) { (finished) in
            self.scanImageView.origin.y = -self.scanImageView.frame.height
            self.perform(#selector(self.startAnimating), with: nil, afterDelay: 0.3)
        }
    }
    
    
    public func controlAnimating(_ isStop: Bool = false) {
        self.isStop = isStop
    }
}

 // MARK: - Private Methods
extension QRCodeBaseViewController {
    
    fileprivate func createInitializeNavigationView(_ codeView: QRCodeView) -> UIView {
        
        let commonView = UIView(frame: CGRect(x: 0, y: 0, width: codeView.frame.width, height: StatusBarAndNavigationBarHeight))
        commonView.backgroundColor = UIColor.rgb_Color(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        let backBtn = UIButton(frame: CGRect(x: 22, y: StatusBarHeight + 15, width: 11, height: 20))
        backBtn.setImage(#imageLiteral(resourceName: "whiteReturn"), for: .normal)
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        commonView.addSubview(backBtn)
        
        let titleLabelW = 120.scale()
        let titleLabel = UILabel(frame: CGRect(x: (codeView.frame.width - titleLabelW) * 0.5, y: 0, width: titleLabelW, height: 30.scale()))
        titleLabel.center.y = backBtn.center.y
        titleLabel.font = UIFont.fontRegular(ofSize: 18.scale())
        
        if let navigationTitle = self.navigationTitle, !navigationTitle.isEmpty {
            titleLabel.text = navigationTitle
        }
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        commonView.addSubview(titleLabel)
        
        if isOpenPhotoAlbum {
            
            let photoAlbumBtnW = 40.scale()
            let photoAlbumBtn = UIButton(frame: CGRect(x: codeView.frame.width - 22 - photoAlbumBtnW, y: 0, width: photoAlbumBtnW, height: titleLabel.frame.height))
            photoAlbumBtn.center.y = titleLabel.center.y
            photoAlbumBtn.titleLabel?.font = titleLabel.font
            photoAlbumBtn.titleLabel?.textAlignment = .right
            photoAlbumBtn.setTitle("相册", for: .normal)
            photoAlbumBtn.setTitleColor(titleLabel.textColor, for: .normal)
            photoAlbumBtn.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)
            commonView.addSubview(photoAlbumBtn)
        }
        
        return commonView
    }
    
    fileprivate func createInitializeScanView(_ codeView: QRCodeView) -> (UIView, UIView) {
        
        let cornerLineW = 25.scale()
        let cornerLineH = 4.scale()
        
        let scanBackView = UIView(frame: CGRect(x: 0, y: codeView.navigationView.frame.maxY, width: codeView.frame.width, height: 2 * scanViewTopHeight + scanViewHeight))

        
        let scanView = UIView(frame: CGRect(x: (codeView.frame.width - scanViewWidth) * 0.5, y: scanViewTopHeight, width: scanViewWidth, height: scanViewHeight))
        scanView.layer.borderWidth = 0.5
        scanView.layer.borderColor = cornerColor.cgColor
        scanView.backgroundColor = UIColor.clear
        scanView.clipsToBounds = true
        scanBackView.addSubview(scanView)

        
        scanImageView = UIImageView(image: #imageLiteral(resourceName: "scan_blue_line"))
        scanImageView.frame = CGRect(x: 0, y: 0, width: scanView.frame.width, height: 10)
        scanView.addSubview(scanImageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: scanView.frame.maxY + 8, width: scanBackView.frame.width, height: 30.scale()))
        titleLabel.font = UIFont.fontRegular(ofSize: 14.scale())
        var message = "将二维码/条形码放入框内，即可自动扫描"
        if scanType == .qrcode {
            message = "将二维码放入框内，即可自动扫描"
        }else if scanType == .barcode{
            message = "将条形码放入框内，即可自动扫描"
            
        }
        if self.message?.isEmpty == false {
            message = self.message!
        }
        titleLabel.text = message
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        scanBackView.addSubview(titleLabel)
        
        let topLeftView = UIView(frame: CGRect(x: scanView.frame.minX + scanView.layer.borderWidth , y: scanView.frame.minY + scanView.layer.borderWidth, width: cornerLineW, height: cornerLineH))
        topLeftView.backgroundColor = cornerColor
        scanBackView.addSubview(topLeftView)
        
        let topRightView = UIView(frame: CGRect(x: scanView.frame.maxX - scanView.layer.borderWidth - cornerLineW, y: topLeftView.frame.minY, width: cornerLineW, height: cornerLineH))
        topRightView.backgroundColor = topLeftView.backgroundColor
        scanBackView.addSubview(topRightView)
        
        let rightTopView = UIView(frame: CGRect(x: scanView.frame.maxX - scanView.layer.borderWidth - cornerLineH, y: topRightView.frame.minY, width: cornerLineH, height: cornerLineW))
        rightTopView.backgroundColor = topLeftView.backgroundColor
        scanBackView.addSubview(rightTopView)

        let rightBottomView = UIView(frame: CGRect(x: rightTopView.frame.minX, y: scanView.frame.maxY - scanView.layer.borderWidth - cornerLineW, width: cornerLineH, height: cornerLineW))
        rightBottomView.backgroundColor = topLeftView.backgroundColor
        scanBackView.addSubview(rightBottomView)

        let leftTopView = UIView(frame: CGRect(x: scanView.frame.minX + scanView.layer.borderWidth, y: rightTopView.frame.minY, width: cornerLineH, height: cornerLineW))
        leftTopView.backgroundColor = topLeftView.backgroundColor
        scanBackView.addSubview(leftTopView)

        let leftBottomView = UIView(frame: CGRect(x: leftTopView.frame.minX, y: rightBottomView.frame.minY, width: cornerLineH, height: cornerLineW))
        leftBottomView.backgroundColor = topLeftView.backgroundColor
        scanBackView.addSubview(leftBottomView)

        let bottomLeftView = UIView(frame: CGRect(x: topLeftView.frame.minX, y: scanView.frame.maxY - scanView.layer.borderWidth - cornerLineH, width: cornerLineW, height: cornerLineH))
        bottomLeftView.backgroundColor = topLeftView.backgroundColor
        scanBackView.addSubview(bottomLeftView)

        let bottomRightView = UIView(frame: CGRect(x: topRightView.frame.minX, y: bottomLeftView.frame.minY, width: cornerLineW, height: cornerLineH))
        bottomRightView.backgroundColor = topLeftView.backgroundColor
        scanBackView.addSubview(bottomRightView)
        
        return (scanView, scanBackView)
    }
    
    fileprivate func createInitializeFunctionView(_ codeView: QRCodeView) -> UIView {
        
        let backView = UIView(frame: CGRect(x: 0, y: codeView.scanBackView.frame.maxY, width: codeView.frame.width, height: KscreenHeight - codeView.navigationView.frame.height - codeView.scanBackView.frame.height))
        backView.backgroundColor = codeView.navigationView.backgroundColor
        
        if isOpenFlashLight {
            
//            let flashLightBtnWH = 50.scale()
//            let flashLightBtn = ImageTitleButton(frame: CGRect(x: (backView.frame.width - flashLightBtnWH) * 0.5, y: (backView.frame.height - flashLightBtnWH) * 0.5, width: flashLightBtnWH, height: flashLightBtnWH))
//            flashLightBtn.titleLabel?.font = UIFont.fontRegular(ofSize: 14.scale())
//            flashLightBtn.titleLabel?.textAlignment = .center
//            flashLightBtn.setTitle("照明", for: .normal)
//            flashLightBtn.setTitleColor(UIColor.white, for: .normal)
//            flashLightBtn.setImage(#imageLiteral(resourceName: "home_setting"), for: .normal)
//            flashLightBtn.addTarget(self, action: #selector(openFlashLight(btn:)), for: .touchUpInside)
//            backView.addSubview(flashLightBtn)
        }
        
        return backView
    }
    
    // MARK: - 返回
    @objc fileprivate func back() {
        
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - 打开相册
    @objc fileprivate func openPhotoAlbum() {

        PHPhotoLibrary.requestAuthorization { statu in
            
            if statu == .authorized {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    DispatchQueue.main.async {
                        self.present(picker, animated: true, completion: nil)
                    }
                } else {
                    
                }
            } else {

                let title = "请前往”设置-隐私-照片“选项中，允许\(appName)访问你的相册"
                self.unAuthorizedHud(with: title)

            }
        }

    }
    
    
    
    private func unAuthorizedHud(with title: String) {
        
        DispatchQueue.main.async {
           
            
            let alertVc = UIAlertController(title: "", message: title, preferredStyle: .alert)
        
            let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
            alertVc.addAction(cancel)
            
            let goSetting = UIAlertAction(title: "设置", style: .default, handler: { (_) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            alertVc.addAction(goSetting)
            
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    // MARK: - 打开照明
    @objc fileprivate func openFlashLight(btn: UIButton) {

        btn.isSelected = !btn.isSelected
        qrcodeTool.setTorch(isOn: btn.isSelected)
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension QRCodeBaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resultStr = QRCodeTool.detectorQRCode(qrImage: image)
        navigationController?.popToRootViewController(animated: false)
        scanResult?(resultStr)
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        isStop = false
        startAnimating()
    }
    
}
