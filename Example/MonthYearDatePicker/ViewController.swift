//
//  ViewController.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05/04/16.
//  Copyright © 2016 Igor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var picker: DatePickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.onMonthLabelCreated = { label in
            label.text = label.text?.capitalized
        }
        picker.minYear = 2020
        picker.maxYear = 2030
        picker.rowHeight = 60
        picker.mode = .mothAndYear
        picker.select(year: 2028)
        picker.select(monthIndex: 2)
        picker.onYearChanged = { [weak self] year in
            print("picker year: \(year)")
            print("picker date: \(String(describing: self?.picker.date))")
        }
        picker.onMonthChanged = { [weak self] index, name in
            print("picker name: \(name), index: \(index)")
            print("picker date: \(String(describing: self?.picker.date))")
        }

        var monthPickerFrame = picker.frame
        monthPickerFrame.origin.y = monthPickerFrame.maxY + 10
        let monthPicker = DatePickerView(frame: monthPickerFrame)
        monthPicker.needRecenter = true
        monthPicker.mode = .month
        monthPicker.locale = Locale(identifier: "ru_RU")
        monthPicker.onYearChanged = { year in
            print("monthPicker year: \(year)")
            print("monthPicker date: \(String(describing: monthPicker.date))")
        }
        monthPicker.onMonthChanged = { index, name in
            print("monthPicker name: \(name), index: \(index)")
            print("monthPicker date: \(String(describing: monthPicker.date))")
        }
        view.addSubview(monthPicker)
        monthPicker.reloadAllComponents()
        monthPicker.selectToday()

        var yearPickerFrame = monthPickerFrame
        yearPickerFrame.origin.y = yearPickerFrame.maxY + 10
        let yearPicker = DatePickerView(frame: yearPickerFrame)

        yearPicker.needRecenter = true
        yearPicker.mode = .year
        yearPicker.onYearChanged = { year in
            print("yearPicker year: \(year)")
            print("yearPicker date: \(String(describing: yearPicker.date))")
        }
        yearPicker.onMonthChanged = { index, name in
            print("yearPicker name: \(name), index: \(index)")
            print("yearPicker date: \(String(describing: yearPicker.date))")
        }
        view.addSubview(yearPicker)
        yearPicker.reloadAllComponents()
        yearPicker.select(year: 2022)
        yearPicker.select(monthIndex: 8)
    }
}
