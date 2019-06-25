//
//  StringExtention.swift
//  FSCalendarSwiftExample
//
//  Created by Hussein Habibi Juybari on 5/10/18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import Swift

extension String {
    func isRTLCalendar() -> Bool {
        let rtlId = [NSCalendar.Identifier.islamicCivil, NSCalendar.Identifier.persian, NSCalendar.Identifier.islamicUmmAlQura, NSCalendar.Identifier.islamic]
        return rtlId.contains(NSCalendar.Identifier(rawValue: self)) 
    }
}
