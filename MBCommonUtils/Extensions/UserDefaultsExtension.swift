//
//  UserDefaultsExtension.swift
//  MBCommonUtils
//
//  Created by nz on 2018/7/26.
//  Copyright © 2018年 xiaoxiaoniuzai. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    public subscript(key: String) -> Any? {
        set {
            set(newValue, forKey: key)
        }
        get {
            return object(forKey: key)
        }
    }

}
