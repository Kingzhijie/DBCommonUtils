//
//  DB_ArchiverSaveTool.swift
//  DBMerchantProject
//
//  Created by xiaoxiaoniuzai on 2018/3/8.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit

//保存的文件名
public enum ArchiverFilePath :String{
    case common   //默认文件
    case router   //路由配置
    case history  //历史记录等
}

public class DB_ArchiverSaveTool: NSObject {

    static public func setObject(_ object: Any, for key: String, keyPath:ArchiverFilePath = .common) -> Bool {
        return NSKeyedArchiver.archiveRootObject(object, toFile: self.saveFilePath(for: key ,keyPath: keyPath))
    }

    static public func getObject(for key: String, keyPath:ArchiverFilePath = .common) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: self.saveFilePath(for: key ,keyPath: keyPath))
    }

    static public func removeObject(for key: String, keyPath:ArchiverFilePath = .common) {
        let filePath = self.saveFilePath(for: key, keyPath: keyPath)
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
    static private func saveFilePath(for key: String, keyPath:ArchiverFilePath = .common) -> String {
        if let cachePath = BaseTool.cachesPath() {
            let directoryPath = cachePath + "/" + keyPath.rawValue
            try? FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            return directoryPath + "/\(key).plist"
        }
        return ""
    }
}
