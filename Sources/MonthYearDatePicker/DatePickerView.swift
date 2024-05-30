//
//  DatePickerView.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05/04/16.
//  Copyright © 2016 Igor. All rights reserved.
//

import UIKit

public enum DatePickerComponent: CaseIterable {
    case month, year

    var rawValue: Int {
        switch self {
        case .month:
            return 0
        case .year:
            return 1
        }
    }
}

open class DatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    open var minYear = 2008
    open var maxYear = 2031
    open var rowHeight: CGFloat = 44
    open var needRecenter = false

    open var monthFont = UIFont.boldSystemFont(ofSize: 17)
    open var monthSelectedFont = UIFont.boldSystemFont(ofSize: 17)

    open var yearFont = UIFont.boldSystemFont(ofSize: 17)
    open var yearSelectedFont = UIFont.boldSystemFont(ofSize: 17)

    open var monthTextColor = UIColor.black
    open var monthSelectedTextColor = UIColor.red

    open var yearTextColor = UIColor.black
    open var yearSelectedTextColor = UIColor.red

    open var onMonthLabelCreated: ((UILabel) -> Void)?
    open var onYearLabelCreated: ((UILabel) -> Void)?
    open var onMonthChanged: ((Int, String) -> Void)?
    open var onYearChanged: ((Int) -> Void)?

    open var locale: Locale = {
        let locale = Locale(identifier: "en_US")
        return locale
    }() {
        didSet {
            months = monthNames()
        }
    }

    open var years: [String] {
        let years = [Int](minYear ... maxYear)
        var names = [String]()
        for year in years {
            names.append(String(year))
        }
        return names
    }

    open var currentMonthName: String {
        let month = Calendar.current.component(.month, from: Date())
        if month <= months.count {
            return months[month - 1]
        }
        return ""
    }

    open var currentYearName: String {
        let year = Calendar.current.component(.year, from: Date())
        return String(year)
    }

    open var date: Date {
        let month = months[selectedRow(inComponent: DatePickerComponent.month.rawValue) % months.count]
        let year = years[selectedRow(inComponent: DatePickerComponent.year.rawValue) % years.count]

        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "MMMM:yyyy"
        let date = formatter.date(from: "\(month):\(year)")
        return date!
    }

    private let numberOfRows = 100_000
    private let componentsCount = DatePickerComponent.allCases.count

    private var rowLabel: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: componentWidth, height: rowHeight))
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }

    private var months = [String]()
    private var componentWidth: CGFloat {
        return bounds.size.width / CGFloat(componentsCount)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func select(monthIndex: Int) {
        guard monthIndex < months.count else {
            return
        }
        selectToday(items: months, currentItem: months[monthIndex], component: DatePickerComponent.month.rawValue)
    }

    func select(year: Int) {
        selectToday(items: years, currentItem: String(year), component: DatePickerComponent.year.rawValue)
    }

    func selectToday() {
        selectToday(items: months, currentItem: currentMonthName, component: DatePickerComponent.month.rawValue)
        selectToday(items: years, currentItem: currentYearName, component: DatePickerComponent.year.rawValue)
    }
}

extension DatePickerView {
    open func pickerView(_: UIPickerView, widthForComponent _: Int) -> CGFloat {
        return componentWidth
    }

    open func pickerView(_: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel
        if view is UILabel {
            label = view as! UILabel
        } else {
            label = rowLabel
        }

        let selected = isSelected(row: row, component: component)
        label.font = selected ? selectedFont(component: component) : font(component: component)
        label.textColor = selected ? selectedColor(component: component) : color(component: component)
        label.text = title(row: row, component: component)

        if component == DatePickerComponent.month.rawValue {
            onMonthLabelCreated?(label)
        } else {
            onYearLabelCreated?(label)
        }
        return label
    }

    open func pickerView(_: UIPickerView, rowHeightForComponent _: Int) -> CGFloat {
        return rowHeight
    }

    open func numberOfComponents(in _: UIPickerView) -> Int {
        return componentsCount
    }

    open func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return numberOfRows
    }

    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let middleRow: Int
        if component == DatePickerComponent.month.rawValue {
            let dataIndex = row % months.count
            middleRow = (numberOfRows / 2) - ((numberOfRows / 2) % months.count) + dataIndex
        } else {
            let dataIndex = row % years.count
            middleRow = (numberOfRows / 2) - ((numberOfRows / 2) % years.count) + dataIndex
        }

        // Optional: Re-center the picker view to avoid reaching high row numbers
        if needRecenter, row != middleRow {
            pickerView.selectRow(middleRow, inComponent: component, animated: false)
        }
        if component == DatePickerComponent.month.rawValue {
            let dataIndex = row % months.count
            onMonthChanged?(dataIndex, months[dataIndex])
        } else {
            let dataIndex = row % years.count
            if let year = Int(years[dataIndex]) {
                onYearChanged?(year)
            }
        }
    }
}

extension DatePickerView {
    private func selectToday(items: [String], currentItem: String, component: Int) {
        let row = items.firstIndex { item in
            item == currentItem
        }

        guard let row = row else {
            return
        }

        let dataIndex = row % items.count
        let middleRow = (numberOfRows / 2) - ((numberOfRows / 2) % items.count) + dataIndex
        if row != middleRow {
            selectRow(middleRow, inComponent: component, animated: false)
        }
    }

    private func monthNames() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        return dateFormatter.standaloneMonthSymbols
    }

    private func setup() {
        delegate = self
        dataSource = self
        months = monthNames()
    }

    private func isSelected(row: Int, component: Int) -> Bool {
        var selected = false
        if component == DatePickerComponent.month.rawValue {
            let name = months[row % months.count]
            if name == currentMonthName {
                selected = true
            }
        } else {
            let name = years[row % years.count]
            if name == currentYearName {
                selected = true
            }
        }

        return selected
    }

    private func selectedColor(component: Int) -> UIColor {
        return component == DatePickerComponent.month.rawValue ? monthSelectedTextColor : yearSelectedTextColor
    }

    private func color(component: Int) -> UIColor {
        return component == DatePickerComponent.month.rawValue ? monthTextColor : yearTextColor
    }

    private func selectedFont(component: Int) -> UIFont {
        return component == DatePickerComponent.month.rawValue ? monthSelectedFont : yearSelectedFont
    }

    private func font(component: Int) -> UIFont {
        return component == DatePickerComponent.month.rawValue ? monthFont : yearFont
    }

    private func title(row: Int, component: Int) -> String {
        return component == DatePickerComponent.month.rawValue ? months[row % months.count] : years[row % years.count]
    }
}
