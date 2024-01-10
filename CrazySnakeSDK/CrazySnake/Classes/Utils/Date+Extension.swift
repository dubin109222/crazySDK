//
//  Date+Extension.swift
//  constellation
//
//  Created by Lee on 2020/4/13.
//  Copyright © 2020 Constellation. All rights reserved.
//

import UIKit


let DAY_SECOND = 60*60*24

let DAY_MILLION_SECOND = 1000*60*60*24

extension Date{
   
    var ls_timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    
    var ls_milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// date str
    /// - Parameter format: "yyyy-MM-dd HH:mm:ss"
    func ls_formatterStr(_ format:String="yyyy-MM-dd ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    static func ls_intervalToDateStr(_ timeInterval:TimeInterval,format:String = "yyyy-MM-dd") -> String {
        let date:Date =  Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        if #available(iOS 16, *) {
//            formatter.timeZone = TimeZone.gmt
//        } else {
//            // Fallback on earlier versions
//        }
//        TimeZone(identifier: "UTC")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    var ls_isToday : Bool {
        return Calendar.current.isDateInToday(self)
    }

    var ls_isYesterday : Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    var ls_isYear: Bool {
        let nowComponent = Calendar.current.dateComponents([.year], from: Date())
        let component = Calendar.current.dateComponents([.year], from: self)
        return (nowComponent.year == component.year)
    }
}
