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
    private var pickerFromCode = DatePickerView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.onMonthLabelCreated = { label in
            label.text = label.text?.capitalized
        }
        picker.minYear = 2020
        picker.maxYear = 2030
        picker.rowHeight = 60
        picker.select(year: 2028)
        picker.select(monthIndex: 2)
        picker.onYearChanged = { [weak self] year in
            print("year: \(year)")
            print("date: \(String(describing: self?.picker.date))")
        }
        picker.onMonthChanged = { index, name in
            print("name: \(name), index: \(index)")
        }

        var frame = picker.bounds
        frame.origin.y = picker.frame.size.height + 80
        pickerFromCode.frame = frame
        pickerFromCode.needRecenter = true
        pickerFromCode.locale = Locale(identifier: "ru_RU")
        view.addSubview(pickerFromCode)
        pickerFromCode.reloadAllComponents()
        pickerFromCode.selectToday()
    }
}
