//
//  DatePickerComponent.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05.06.2024.
//  Copyright © 2024 Igor. All rights reserved.
//

import Foundation

enum DatePickerComponent: CaseIterable {
    case month, year

    func component(mode: DatePickerMode) -> Int {
        switch mode {
        case .month, .year:
            return 0
        case .mothAndYear:
            switch self {
            case .month:
                return 0
            case .year:
                return 1
            }
        }
    }
}
