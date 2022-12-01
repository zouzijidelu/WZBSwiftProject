//
//  DFTimeUtil.swift
//  dftv2
//
//  Created by zhibin wang on 2020/8/3.
//  Copyright © 2020 italktv. All rights reserved.
//

import UIKit

class DFTimeUtil {
    
    /// 时间戳 获取格式化时间
    /// - Parameter timeStamp: 时间戳字符串 秒
    /// - Returns: 格式化时间
    static func getFormatTime(wiht timeStamp: String?) -> String {
        guard let timeStamp = timeStamp else {
            return ""
        }
        let intStamp = (Int(timeStamp) ?? 1000)/1000
        let realTimeStamp = String(intStamp)
        let tempMilli: TimeInterval = TimeInterval.init(realTimeStamp)!
        let myDate = Date.init(timeIntervalSince1970: tempMilli)
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let curComponents = calendar.dateComponents(unit, from: Date())
        let currentYear = curComponents.year
        let currentMonth = curComponents.month
        let currentDay = curComponents.day
        let srcComponents = calendar.dateComponents(unit, from: myDate)
        let srcYear = srcComponents.year
        let srcMonth = srcComponents.month
        let srcDay = srcComponents.day
        
        let dateFmt = DateFormatter()
        //2. 指定日历对象,要去取日期对象的那些部分.
        let comp = calendar.dateComponents([.year,.month,.day,.weekday], from: myDate)
        
        if currentYear == srcYear {
            let currentTimeStamp = DFTimeUtil.getIOSTimeStamp(dat: Date())
            let srcTimepStamp = DFTimeUtil.getIOSTimeStamp(dat: myDate)
            let delta = currentTimeStamp - srcTimepStamp
            
            if currentMonth == srcMonth && currentDay == srcDay {
                dateFmt.dateFormat = "HH:mm"
                return dateFmt.string(from: myDate)
            } else {
                let yesterDayDate = Date(timeInterval: -24*60*60, since: Date())
                let yestadyCom = calendar.dateComponents([.year,.month,.day], from: yesterDayDate)
                let yestdayDay = yestadyCom.day
                let yestdayMonth = yestadyCom.month
                
                if srcMonth == yestdayMonth && srcDay == yestdayDay {
                    dateFmt.dateFormat = " HH:mm"
                    return "昨天" + dateFmt.string(from: myDate)
                } else {
                    let delteHour = delta / 3600
                    var weekStr = ""
                    dateFmt.dateFormat = " HH:mm"
                    if delteHour <= 7*24 {
                        switch comp.weekday {
                        case 1:
                            weekStr = "星期日"
                            break
                        case 2:
                            weekStr = "星期一"
                            break
                        case 3:
                            weekStr = "星期二"
                            break
                        case 4:
                            weekStr = "星期三"
                            break
                        case 5:
                            weekStr = "星期四"
                            break
                        case 6:
                            weekStr = "星期五"
                            break
                        case 7:
                            weekStr = "星期六"
                            break
                        default: break
                            
                        }
                        return weekStr + dateFmt.string(from: myDate)
                    } else {
                        dateFmt.dateFormat = "yyyy/MM/dd"
                    }
                }
            }
        } else {
            dateFmt.dateFormat = "yyyy/MM/dd"
        }
        return dateFmt.string(from: myDate)
    }
    
////    X分钟前：发布时间在1h内时显示
////    X小时前：发布时间在1h-24h内时显示
////    X天前：发布时间在24h-30天内显示
////    YYYY-MM-DD：发布时间超过30天以上时显示
////    数据来自接口，UTC时间戳， 显示为本地时间
//   //数据返回的“时间”超出当前时间则不显示”发布时间
//    static func getFormatTimeWithUTCTimeStamp(timeStamp: Int64) -> String? {
//        let utcDate = Date(timeIntervalSince1970: Double(timeStamp))
//        let sinceNow = Int64(ceil(utcDate.timeIntervalSinceNow))
//        if sinceNow >= 0 {
//            return nil
//        }
//        let absSinceNow = abs(sinceNow)
//        switch absSinceNow {
//        case 0 ... 59:
//            return "n分钟"("1")
//        case 60 ... 3599:
//            let min = absSinceNow/60
//            return (min == 1 ? "n分钟前_singular" : "n分钟前_plural")("\(min)")
//        case 3600 ... 86399:
//            let hour = absSinceNow/3600
//            return (hour == 1 ? "n小时前_singular" : "n小时前_plural")("\(hour)")
//        case 86400 ... 2591999:
//            let day = absSinceNow/86400
//            return (day == 1 ? "n天前_singular" : "n天前_plural")("\(day)")
//        default:
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            return dateFormatter.string(from: utcDate)
//        }
//    }
    
    static func getIOSTimeStamp(dat: Date) -> Int {
        let la = dat.timeIntervalSince1970
        return Int(la)
    }
    // 获得yyyy/MM/dd  HH:mm
    static func getSimpleFormatTimeWithUTCTimeStamp(timeStamp: Int64) -> String? {
        let utcDate = Date(timeIntervalSince1970: Double(timeStamp/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: utcDate)
    }
    
}
