//
//  RangePickerViewController.swift
//  FSCalendarSwiftExample
//
//  Created by Hussein Habibi Juybari on 5/13/18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit

class RangePickerViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{

    weak var calendar: FSCalendar?
    weak var eventLabel: UILabel?
    var gregorian: Calendar?
    var dateFormatter: DateFormatter?
    // The start date of the range
    var date1: Date?
    // The end date of the range
    var date2: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gregorian = Calendar(identifier: .persian)
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "yyyy-MM-dd"

    }
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        self.view = view
        let calendar = FSCalendar(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.size.width, height: view.frame.size.height - (navigationController?.navigationBar.frame.maxY)!))
        
        calendar.locale = NSLocale(localeIdentifier: "fa-IR") as Locale
        calendar.calendarIdentifier = NSCalendar.Identifier.persian.rawValue
        
        calendar.firstWeekday = 7
        calendar.dataSource = self
        calendar.delegate = self
        calendar.pagingEnabled = false
        calendar.allowsMultipleSelection = true
        calendar.rowHeight = 60
        calendar.placeholderType = FSCalendarPlaceholderType(rawValue: 0)!
        view.addSubview(calendar)
        
        self.calendar = calendar
        calendar.appearance.titleDefaultColor = UIColor.black
        calendar.appearance.headerTitleColor = UIColor.black
        let aSize = UIFont.systemFont(ofSize: 16)
        calendar.appearance.titleFont = aSize
        
        calendar.weekdayHeight = 0
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.today = nil
        // Hide the today circle
        calendar.register(RangePickerCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - FSCalendarDataSource
    func minimumDate(for calendar: FSCalendar) -> Date {
        return (dateFormatter?.date(from: "2000-07-08"))!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return (dateFormatter?.date(from: "2020-07-08"))!
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at monthPosition: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell: RangePickerCell? = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: monthPosition) as? RangePickerCell
        return cell!
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureCell(cell, for: date, at: monthPosition)
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.swipeToChooseGesture.state == .changed {
            // If the selection is caused by swipe gestures
            if !(date1 != nil) {
                date1 = date
            } else {
                if (date2 != nil) {
                    calendar.deselect(date2!)
                }
                date2 = date
            }
        } else {
            if (date2 != nil) {
                calendar.deselect(date1!)
                calendar.deselect(date2!)
                date1 = date
                date2 = nil
            } else if !(date1 != nil) {
                date1 = date
            } else {
                date2 = date
            }
        }
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let aDate = date
        print("did deselect date \(String(describing: dateFormatter?.string(from: aDate)))")
        
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if (gregorian?.isDateInToday(date))! {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    // MARK: - Private methods
    func configureVisibleCells() {
        for obj in (calendar?.visibleCells())! {
            let date: Date? = self.calendar?.date(for: obj)
            let position: FSCalendarMonthPosition = self.calendar!.monthPosition(for: obj)
            self.configureCell(obj, for: date!, at: position)
        }
    }
    
    func configureCell(_ cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let rangeCell = cell as? RangePickerCell
        if position != .current {
            rangeCell?.middleLayer.isHidden = true
            rangeCell?.selectionLayer.isHidden = true
            return
        }
        if (date1 != nil) && (date2 != nil) {
            // The date is in the middle of the range
            let isMiddle: Bool = date.compare(date1!) != date.compare(date2!)
            rangeCell?.middleLayer.isHidden = !isMiddle
        } else {
            rangeCell?.middleLayer.isHidden = true
        }
        var isSelected = false
        let aDate = date
        isSelected = (date1 != nil) && (gregorian?.isDate(aDate, inSameDayAs: date1!))! || (date2 != nil) && (gregorian?.isDate(aDate, inSameDayAs: date2!))!
        
        rangeCell?.selectionLayer.isHidden = !isSelected
    }
}
