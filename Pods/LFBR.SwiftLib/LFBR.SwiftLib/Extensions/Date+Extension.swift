//
//  Date+Extension.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class Date_Extension: NSObject {

}

public extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        var result: String = ""
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        if days(from: date)    > 0 { result = result + " " + "\(days(from: date)) D" }
        if hours(from: date)   > 0 { result = result + " " + "\(hours(from: date)) H" }
        if minutes(from: date) > 0 { result = result + " " + "\(minutes(from: date)) M" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        return ""
    }
    
    /// Return yyy MMM dd HH:mm from current date
    ///
    /// - Returns: date as descriptive string
    func getTimeWithYYYMMMDDHHmmFormat() -> String{
        return getTimeBy(format: "yyy MMM dd HH:mm")
    }

    /// Return dd MMM yyy HH:mm from current date
    ///
    /// - Returns: date as descriptive string
    func getTimeWithDDMMMYYYHHmmFormat() -> String{
        return getTimeBy(format: "dd MMM yyy HH:mm")
    }
    
    /// Add some days to current date
    ///
    /// - Parameter days: days to add to your current date
    /// - Returns: date as dd-MMM format with
    func getLeftDaysFrom(days:Int) -> String{
        let date = Calendar.current.date(byAdding: .day, value: days, to: self)!
        return date.getTimeBy(format: "dd-MMM")
    }
    
    /// Return date as string
    ///
    /// - Parameter format: formate descriptio
    /// - Returns: date as descriptive string
    func getTimeBy(format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// Transform current date value to int representation by offset
    ///
    /// - Returns: Int64 representation
    func getTimeStamp() -> Int64{
        return Int64(self.timeIntervalSince1970)
    }
}
