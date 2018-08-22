
//
//  QRCodeTool.swift
//  PhotoQueen
//
//  Created by Edward on 2017/7/24.
//  Copyright © 2017年 Edward. All rights reserved.
//

import AVFoundation
import UIKit

public enum QRCodeScanType {
    case all
    case qrcode
    case barcode
}

public class QRCodeTool: NSObject {
    
    private(set) var scanType: QRCodeScanType!
    private(set) var isAuthored = false
    static private(set) var failureMessage = "未识别到内容"
    
    /// input
    private lazy var input: AVCaptureDeviceInput? = {
        
        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
            
            let input = try? AVCaptureDeviceInput(device: device)
            return input
        } else {
           return nil
        }
    }()

    /// output
    private lazy var output: AVCaptureMetadataOutput = {
        
        $0.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return $0
    }(AVCaptureMetadataOutput())
    
    /// session
    private lazy var session: AVCaptureSession = {
        return $0
    }(AVCaptureSession())
    
    /// previewLayer
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        
        return AVCaptureVideoPreviewLayer(session: self.session)
    }()
    
    fileprivate var scanCompletion: ((String) -> Void)?
    
    /// 生成二维码
    ///
    /// - parameter text :  输入的文本内容
    /// - parameter value:  比例
    /// - parameter addMiddleImage: 中间自定义小图
    ///
    /// - returns: 二维码图片
    public static func createQRCode(input text: String, scale value: CGFloat, middleImage: UIImage?) -> UIImage? {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        
        // 设置滤镜内容
        let inputData = text.data(using: String.Encoding.utf8)
        filter?.setValue(inputData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        // (w: 23.0, h: 23.0)
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let resultImage = createHighDefinitionImage(image: outputImage, size: value)
        
        if middleImage != nil {
            return addMiddleImage(smallImage: middleImage!, to: resultImage)
        }
        return resultImage
    }
    
    
    
    /// 识别二维码
    ///
    /// - parameter qrImage :  二维码图片
    ///
    /// - returns: 识别结果 & 绘制好边框的二维码图片
    public static func detectorQRCode(qrImage: UIImage) -> (String) {
        
        let decetor = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        // 扫描特征
        let ciImage = CIImage(image: qrImage)
        guard let features = decetor?.features(in: ciImage!) else {
            return ("")
        }
        
        // 处理特征
        if features.count == 0 {
            return (QRCodeTool.failureMessage)
        }

        let codeFeature = features.first as! CIQRCodeFeature
        let resultStr = codeFeature.messageString ?? QRCodeTool.failureMessage
        
        return (resultStr)
    }
    
    
    /// 扫描二维码
    ///
    /// - parameter inView:      视频预览图层
    /// - parameter isDrawFrame: 是否需要绘制边框
    /// - parameter scanResultBlock: 扫描到的结果集
    public func scanQRCode(inView: UIView, scanType: QRCodeScanType,  scanCompletion: ((String) -> Void)?) {
        
        self.scanType = scanType
        self.scanCompletion = scanCompletion
        
        guard let input = input else {
            return
        }
        
        if session.canAddInput(input) && session.canAddOutput(output) {
            
            session.addInput(input)
            session.addOutput(output)
        }

        // 设置输出对象可以处理的数据类型
        if scanType == .all {
            output.metadataObjectTypes = [.qr, .ean8, .ean13, .upce, .code39, .code93, .code128, .code39Mod43, .pdf417]
        } else if scanType == .qrcode {
            output.metadataObjectTypes = [.qr]
        } else {
            output.metadataObjectTypes = [.ean8, .ean13, .upce, .code39, .code93, .code128, .code39Mod43, .pdf417]
        }
        
        if let layer = previewLayer {
            layer.frame = UIScreen.main.bounds
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            inView.layer.insertSublayer(layer, at: 0)
        }
        
        startScan()
    }
    
    /// 开始扫描
    public func startScan() {
        session.startRunning()
    }
    
    /// 停止扫描
    public func stopScan() {
        session.stopRunning()
    }
    
    /// 扫描区域
    public func setRectOfInterest(originRect: CGRect) {
        
        let screenSize = UIScreen.main.bounds.size
        let x = originRect.origin.x / screenSize.width
        let y = originRect.origin.y / screenSize.height
        let w = originRect.size.width / screenSize.width
        let h = originRect.size.height / screenSize.height
        
        output.rectOfInterest = CGRect(x: y, y: x, width: h, height: w)
    }
    
    /// 是否开启手电筒
    public func setTorch(isOn: Bool) {
        
        let device = input?.device
        if device?.hasTorch ?? false {
            
            try? device?.lockForConfiguration()
            device?.torchMode = isOn ? .on : .off
            device?.unlockForConfiguration()
        }
    }

    /// 检测是否授权
    public func checkAuthorization(authored: (()->())?, unauthored: (()->())?) {
        
        AVCaptureDevice.requestAccess(for: .video) { authoredStatu in
            self.isAuthored = authoredStatu
            DispatchQueue.main.async {
                if authoredStatu {
                    authored?()
                } else {
                    unauthored?()
                }
            }
        }
    }
    
                                                                                                                                                                                                                           
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeTool: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            scanCompletion?(QRCodeTool.failureMessage)
            return
        }
        
        stopScan()
        let metadataObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        let resultStr = metadataObject.stringValue ?? QRCodeTool.failureMessage
        scanCompletion?(resultStr)
    }
    
}



// MARK: - Private Methods
extension QRCodeTool {
    
    // MARK: - 高清图
    fileprivate static func createHighDefinitionImage(image: CIImage, size: CGFloat) -> UIImage {
        
        
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        
        let context = CIContext(options: nil)
        let bitImage = context.createCGImage(image, from: extent)!
        
        let w = extent.width * scale
        let h = extent.height * scale
        
        let bitmapRef = CGContext(data: nil, width: Int(w), height: Int(h), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitImage, in: extent)
        
        let scaledImage = bitmapRef.makeImage()
        
        return UIImage(cgImage: scaledImage!)
    }
    
    
    /// 添加自定义中间小图
    ///
    /// - parameter smallImage:  小图
    /// - parameter backImage :  大图
    ///
    /// - returns: 合成之后图片
    fileprivate static func addMiddleImage(smallImage: UIImage, to backImage: UIImage) -> UIImage {
        
        let size = smallImage.size
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        
        backImage.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        // 绘制中间小图
        let width = size.width * 0.25
        let height = size.height * 0.25
        let x = (size.width - width) * 0.5
        let y = (size.height - height) * 0.5
        smallImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? backImage
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
}
