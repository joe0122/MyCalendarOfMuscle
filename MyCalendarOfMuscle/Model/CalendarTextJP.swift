//
//  CalendarJP.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/12/22.
//

import Foundation
import CalculateCalendarLogic
import FSCalendar

class CalendarTextJP {
    
    func calendarTextJP(calendar:FSCalendar){
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        //曜日のラベルの色を変更(平日を黒、土曜を青、日曜を赤)
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calendar.calendarWeekdayView.weekdayLabels[1].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[2].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[3].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[4].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue
    }
    
}
