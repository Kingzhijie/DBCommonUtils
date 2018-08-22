//
//  DB_LocationTool.swift
//  DBMerchantProject
//
//  Created by mbApple on 2018/3/9.
//  Copyright © 2018年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
import CoreLocation

// 定位服务工具类
private let locationTool = DB_LocationTool()
@objcMembers public class DB_LocationTool: NSObject ,CLLocationManagerDelegate{
    public class var shared : DB_LocationTool {
        return locationTool
    }
    
    private lazy var locationmanager: CLLocationManager = {
        let locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest //最精确定位
        locationmanager.distanceFilter = 50.0 //位置更新的最小距离，只有移动大于这个距离才更新位置信息
        return locationmanager
    }()
    public var longitude:Double = 0 //经度
    public var latitude:Double = 0 //纬度
    public var currentCity = "杭州" // 当前城市
    public var authorizationStatus: CLAuthorizationStatus =  .denied
 
    private var hasDidChangeAuthorization: Bool?
    
    //MARK: - 获取位置
    public func getLocation() {
        if CLLocationManager.locationServicesEnabled() == true{ //判断定位功能是否打开
            locationmanager.startUpdatingLocation()
        }
    }
    
   //MARK: - (需要重新打开定位的时候更新数据)
   public func updateLocation() {
        if CLLocationManager.locationServicesEnabled() == false || CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            locationmanager.startUpdatingLocation()
            
            DispatchQueue.main.async {
     
                let alertVc = UIAlertController(title: "允许定位提示", message: "请在设置中打开定位", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
                alertVc.addAction(cancel)
                
                let goSetting = UIAlertAction(title: "打开", style: .default, handler: { (_) in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                alertVc.addAction(goSetting)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alertVc, animated: true, completion: nil)
            }
        }
    }
    
    //定位失败
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    //定位成功
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationmanager.stopUpdatingLocation()
        let currentLocation = locations.last
        let geoCoder = CLGeocoder()
        longitude = currentLocation?.coordinate.longitude ?? 0
        latitude = currentLocation?.coordinate.latitude ?? 0

        //反地理编码
        geoCoder.reverseGeocodeLocation(currentLocation!) { (placemarks, error) in
            if Int(placemarks?.count ?? 0) > 0{
                let placeMark = placemarks![0]
                let currentCity = placeMark.locality ?? "杭州"//当前城市
                let country = placeMark.country ?? ""//当前国家
                let subLocality = placeMark.subLocality ?? ""//当前县,区
                let thoroughfare = placeMark.thoroughfare ?? ""//当前街道
                let detailName = placeMark.name ?? ""//具体地址
                self.currentCity = currentCity.contains("市") ? currentCity.replacingOccurrences(of: "市", with: "") : currentCity
                
            }
        }

    }
    
    
    /// 获取某个经纬度, 据当前定位, 之间的距离
    ///
    /// - Parameters:
    ///   - lon: 经度
    ///   - lat: 纬度
    /// - Returns: 距离, 单位m
    public func LantitudeLongitudeDist(lon:Double,lat:Double) -> Double {
        let orig = CLLocation.init(latitude: self.latitude, longitude: self.longitude)
        let dist = CLLocation.init(latitude: lat, longitude: lon)
        let meter = orig.distance(from: dist)
        return meter
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    }
    
    
}
