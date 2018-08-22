//
//  DB_DateTool.swift
//  DBMerchantProject
//
//  Created by mbApple on 2018/2/9.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
private let DateFormatterHelper = DateFormatter()
public class DB_DateTool: NSObject {
    public class var sharedDate : DateFormatter {
        return DateFormatterHelper
    }
    
    /*
     ** 获取当前时间戳(1970年到现在流失的秒数)
     */
    public class func getCurrentTimeStr() -> TimeInterval {
        return Date.init().timeIntervalSince1970
    }
    
    /*
     ** 传入一个时间戳(seconds),返回一个时间 (单位 秒)
     **  dateStyle 需要返回日期的格式(yyyy-MM-dd a HH:mm:ss)
     */
    public class func getTimeDateBySeconds(seconds:Double,dateStyle:String) -> String {
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DB_DateTool.sharedDate as DateFormatter
        formatter.dateFormat = dateStyle
        return formatter.string(from: date)
    }
    
    /*
     ** dateStyle: 日期的格式(yyyy-MM-dd HH:mm:ss)
     **  time : 对应的时间
     **  返回一个对应的时间戳
     */
    public class func getTimestamp(dateStyle:String,time:String) -> Int {
        let datefmatter = DB_DateTool.sharedDate as DateFormatter
        datefmatter.dateFormat = dateStyle
        let date = datefmatter.date(from: time)
        let dateStamp:TimeInterval = date?.timeIntervalSince1970 ?? 0
        let dateStr:Int = Int(dateStamp)
        return dateStr
    }
    
    
    /// 格式化时间
    ///
    /// - Returns: 时间串
    public class func timeFormatter(_ timestamp: Int64) -> String {

        let date = Date(timeIntervalSince1970: TimeInterval(Double(timestamp)
            / 1000.0))

        if Calendar.current.isDateInToday(date) { // 当天 18:23
            let today = self.getTimeDateBySeconds(seconds: Double(timestamp) / 1000.0, dateStyle: "HH:mm")
            return today
        } else {
            
            if !self.isThisYear(from: date, to: Date()) { // 不是今年
                let year = self.getTimeDateBySeconds(seconds: Double(timestamp) / 1000.0, dateStyle: "yyyy-MM-dd")
                return year
            }
            
            // 今年-昨天
            if Calendar.current.isDateInYesterday(date) { // 昨天
                let yesterday = self.getTimeDateBySeconds(seconds: Double(timestamp) / 1000.0, dateStyle: "HH:mm")
                return "昨天 " + yesterday
            }
            
            // 今年-昨天之前
            if !Calendar.current.isDateInYesterday(date) { // 今年但不是昨天
                let unYesterday = self.getTimeDateBySeconds(seconds: Double(timestamp) / 1000.0, dateStyle: "MM-dd HH:mm")
                return unYesterday
            }
            
        }
        
        return ""
    }
    
    // MARK: 是否为今年
    private class func isThisYear(from: Date, to: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year], from: from, to: to)
        return com.year == 0
    }
}
