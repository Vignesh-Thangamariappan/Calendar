//
//  DateUtils.swift
//  Swifty Utils
//
//  Created by Vignesh on 26/06/20.
//  Copyright © 2020 Vignesh. All rights reserved.
//

import Foundation
import SwiftDate

struct DateUtils {
    
    enum TimeClassfiers: String {
        case am = "AM"
        case pm = "PM"
    }
    static let twelveHourTimeStringFormat = "h:mm aa"
    static let twentyFourHourTimeStringFormat = "HH:mm"
    
    static func getUpcomingTimeRangeInMilliSec(forDate date: Date) -> (startTime: Double, endTime: Double) {
        
        let (hour, minutes) = getRoundedTime(hour: date.hour, minutes: date.minute)
        guard hour < 24 else {
            let nextDate = date.dateByAdding(1, .day).dateAt(.startOfDay).date
            let endDate = nextDate.dateByAdding(30, .minute).date
            return (nextDate.timeIntervalSince1970 * 1000, endDate.timeIntervalSince1970 * 1000)
        }
        
        let startDate = Date(year: date.year, month: date.month, day: date.day, hour: hour, minute: minutes)
        let endDate = startDate.dateByAdding(30, .minute).date
        
        return (startDate.timeIntervalSince1970 * 1000, endDate.timeIntervalSince1970 * 1000)
    }
    
    static func getRoundedTime(hour: Int, minutes: Int) -> (hour: Int, minutes: Int) {
        if minutes == 0 {
            return (hour, minutes)
        } else if minutes <= 15 {
            return (hour, 15)
        } else if minutes <= 30 {
            return (hour, 30)
        } else if minutes <= 45 {
            return (hour, 45)
        } else {
            return (hour+1, 00)
        }
    }
    
    static func getHoursAndMinutes(forMinutes minutes: Int) -> (hours: Int, minutes: Int) {
        let hours = minutes / 60
        let minutes = minutes % 60
        return (hours: hours, minutes: minutes)
    }
    
    static func getDurationString(forMinutes minutes: Int) -> String {

        let duration = getHoursAndMinutes(forMinutes: minutes)
        var hoursString = ""
        if duration.hours > 0 {
            hoursString = duration.hours > 1 ? "\(duration.hours) hours" : "1 hour"
        }
        let minutesString = duration.minutes > 0 ? " \(duration.minutes) minutes" : ""
        return hoursString + minutesString
    }
    
    static func getTimeBasedOnDeviceSettings(forMinutes minutes: Int) -> String {
        let time = Date().uses12HourFormat() ? getTimeIn12HoursFormat(forMinutes: minutes) : getTimeIn24HoursFormat(forMinutes: minutes)
        return time
    }
    
    static func getTimeIn12HoursFormat(forMinutes minutes: Int) -> String {
        let classifier: TimeClassfiers = minutes > 719 ? .pm : .am
        let minutesFor12Hours = minutes % 720
        let timingString = getTime(forMinutes: minutesFor12Hours)
        return timingString + " " + classifier.rawValue
    }
    
    static func getTimeIn24HoursFormat(forMinutes minutes: Int) -> String {
       return getTime(forMinutes: minutes)
    }
    
    static func getTime(forMinutes minutes: Int) -> String {
        let duration = getHoursAndMinutes(forMinutes: minutes)
        let hoursString =  duration.hours > 9 ? "\(duration.hours)" : "0\(duration.hours)"
        let minuteString =  duration.minutes > 9 ? "\(duration.minutes)" : "0\(duration.minutes)"
        return "\(hoursString):\(minuteString)"
    }
    
}

extension Date {
    func uses12HourFormat() -> Bool {
        let locale = Locale.current
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
        if dateFormat.range(of: "a") != nil {
            return true
        } else {
            return false
        }
    }
}
