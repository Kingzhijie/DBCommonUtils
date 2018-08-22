//
//  UIDeviceExtension.swift
//  XJDProject
//
//  Created by mbApple on 2018/1/9.
//  Copyright © 2018年 panda誌. All rights reserved.
//

import UIKit
import AdSupport
import SimulateIDFA

extension UIDevice{
    //获取设备名称
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch 5"
        case "iPod7,1":   return "iPod Touch 6"
        
        case "iPhone1,1":  return "iPhone 1G"
        case "iPhone1,2":  return "iPhone 3G"
        case "iPhone2,1":  return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 "
        case "iPhone5,3":  return "iPhone 5c "
        case "iPhone5,4":  return "iPhone 5c "
        case "iPhone6,1":  return "iPhone 5s "
        case "iPhone6,2":  return "iPhone 5s "
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone 5SE"
        case "iPhone9,1":   return "iPhone 7"
        case "iPhone9,2":  return "iPhone 7 Plus"
        case "iPhone9,3":  return "iPhone 7"
        case "iPhone9,4":  return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
    
    // 获取IDFA
    public class func getDeviceIDFA() -> String {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled == true {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return SimulateIDFA.createSimulateIDFA()
    }
    
    // 获取容量大小
    public class func getTotalDiskSize() -> String {
        var buf =  statfs()
        var freeSpace: CLongLong = -1
        if statfs("/var", &buf) >= 0 {
            freeSpace = CLongLong(buf.f_bsize) * CLongLong(buf.f_blocks)
        }
        return UIDevice.fileSizeToString(fileSize: freeSpace)
    }
    
    // 可用容量大小
    public class func getAvailableDiskSize() -> String {
        var buf =  statfs()
        var freeSpace: CLongLong = -1
        if statfs("/var", &buf) >= 0 {
            freeSpace = CLongLong(buf.f_bsize) * CLongLong(buf.f_bavail)
        }
        return UIDevice.fileSizeToString(fileSize: freeSpace)
    }
    
    // 格式转换
    public class func fileSizeToString(fileSize: CLongLong) -> String {
        let KB:NSInteger = 1024
        let MB:NSInteger = KB * KB
        let GB:NSInteger = MB * KB
        
        if fileSize < 10  {
            return "0 B"
        }else if fileSize < KB {
            return "< 1 KB"
        }else if fileSize < MB {
            let size = NSInteger(fileSize)/KB
            return "\(size) KB"
        }else if fileSize < GB {
            let size = NSInteger(fileSize)/MB
            return "\(size) MB"
        }else {
            let size = NSInteger(fileSize)/GB
            switch (size) {
            case 0..<16:
                return "16G"
            case 16..<32:
                return "32G"
            case 32..<64:
                return "64G"
            case 64..<128:
                return "128G"
            case 128..<256:
                return "256G"
            case 256..<512:
                return "512G"
            default:
                return ""
            }
        }
    }
    
    
    
    
    // 获取当前wifi的IP地址
    public class func getLocalIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
}
