//
//  NSObjectExtension.swift
//  MBCommonUtils
//
//  Created by nz on 2018/7/25.
//  Copyright © 2018年 xiaoxiaoniuzai. All rights reserved.
//

import UIKit


extension NSObject {
    
    public class func className() -> String {
        let name: AnyClass! = object_getClass(self)
        return "\(name)"
    }
    
}



// MARK: - Double
extension Double {
    
    // Double convert CGFloat
    public var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    
    // Double convert Int
    public var toInt: Int {
        return Int(self)
    }
    
    // Double convert NSNumber
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
    
    // 金额格式化
    public var formatter: String {
        return String(format: "¥ %.2f", self * 0.01)
    }
}


// MARK: - CGFloat
extension CGFloat {
    
    // CGFloat convert Int
    public var toInt: Int {
        return Int(self)
    }
    
    // CGFloat convert Double
    public var toDouble: Double {
        return Double(self)
    }
    
}


// MARK: - Int
private let scalePlus:CGFloat = 1.10  // plus
private let scale5s:CGFloat = 0.85  // 5
private let scale6:CGFloat = 1.00  // 6

extension Int {
    // 适配
    public func scale() -> CGFloat {
        
        if KscreenWidth == 414 {
            return self.toCGFloat * scalePlus
        } else if KscreenWidth == 375 {
            return self.toCGFloat
        } else if KscreenWidth == 320 {
            return self.toCGFloat * scale5s
        } else {
            return self.toCGFloat
        }
    }
    
    
    // Int convert CGFloat
    public var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    
    // Int convert Double
    public var toDouble: Double {
        return Double(self)
    }
    
    // Int convert NSNumber
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}
