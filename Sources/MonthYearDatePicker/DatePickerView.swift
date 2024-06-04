//
//  DatePickerView.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05/04/16.
//  Copyright © 2016 Igor. All rights reserved.
//

import UIKit

open class DatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    open var minYear = 2000
    open var maxYear = 2030
    open var rowHeight: CGFloat = 44
    open var needRecenter = false
    open var mode = DatePickerMode.mothAndYear

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

    open var date: Date? {
        guard mode == .mothAndYear else {
            return nil
        }
        let month = months[selectedRow(inComponent: DatePickerComponent.month.component(mode: mode)) % months.count]
        let year = years[selectedRow(inComponent: DatePickerComponent.year.component(mode: mode)) % years.count]

        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "MMMM:yyyy"
        let date = formatter.date(from: "\(month):\(year)")
        return date!
    }

    private let numberOfRows = 100_000
    private var componentsCount: Int {
        switch mode {
        case .mothAndYear:
            return 2
        default:
            return 1
        }
    }

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

    override public init(frame: CGRect) {
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

    open func select(monthIndex: Int) {
        guard mode != .year, monthIndex < months.count else {
            return
        }

        select(items: months, currentItem: months[monthIndex], component: DatePickerComponent.month.component(mode: mode))
    }

    open func select(year: Int) {
        guard mode != .month else {
            return
        }
        select(items: years, currentItem: String(year), component: DatePickerComponent.year.component(mode: mode))
    }

    open func selectToday() {
        switch mode {
        case .month:
            select(items: months, currentItem: currentMonthName, component: DatePickerComponent.month.component(mode: mode))
        case .year:
            select(items: years, currentItem: currentYearName, component: DatePickerComponent.year.component(mode: mode))
        case .mothAndYear:
            select(items: months, currentItem: currentMonthName, component: DatePickerComponent.month.component(mode: mode))
            select(items: years, currentItem: currentYearName, component: DatePickerComponent.year.component(mode: mode))
        }
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

        switch mode {
        case .month:
            onMonthLabelCreated?(label)
        case .year:
            onYearLabelCreated?(label)
        case .mothAndYear:
            if component == DatePickerComponent.month.component(mode: mode) {
                onMonthLabelCreated?(label)
            } else {
                onYearLabelCreated?(label)
            }
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
        let middleRow = middleRow(row, component: component)
        // Optional: Re-center the picker view to avoid reaching high row numbers
        if needRecenter, row != middleRow {
            pickerView.selectRow(middleRow, inComponent: component, animated: false)
        }

        rowDidSelect(row, component: component)
    }
}

extension DatePickerView {
    private func middleRow(_ row: Int, component: Int) -> Int {
        switch mode {
        case .month:
            let dataIndex = row % months.count
            return (numberOfRows / 2) - ((numberOfRows / 2) % months.count) + dataIndex
        case .year:
            let dataIndex = row % years.count
            return (numberOfRows / 2) - ((numberOfRows / 2) % years.count) + dataIndex
        case .mothAndYear:
            if component == DatePickerComponent.month.component(mode: mode) {
                let dataIndex = row % months.count
                return (numberOfRows / 2) - ((numberOfRows / 2) % months.count) + dataIndex
            } else {
                let dataIndex = row % years.count
                return (numberOfRows / 2) - ((numberOfRows / 2) % years.count) + dataIndex
            }
        }
    }

    private func rowDidSelect(_ row: Int, component: Int) {
        switch mode {
        case .month:
            let dataIndex = row % months.count
            onMonthChanged?(dataIndex, months[dataIndex])
        case .year:
            let dataIndex = row % years.count
            if let year = Int(years[dataIndex]) {
                onYearChanged?(year)
            }
        case .mothAndYear:
            if component == DatePickerComponent.month.component(mode: mode) {
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

    private func select(items: [String], currentItem: String, component: Int) {
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
        switch mode {
        case .mothAndYear:
            if component == DatePickerComponent.month.component(mode: mode) {
                let name = months[row % months.count]
                return name == currentMonthName
            } else {
                let name = years[row % years.count]
                return name == currentYearName
            }
        case .month:
            let name = months[row % months.count]
            return name == currentMonthName
        case .year:
            let name = years[row % years.count]
            return name == currentYearName
        }
    }

    private func selectedColor(component: Int) -> UIColor {
        switch mode {
        case .mothAndYear:
            return component == DatePickerComponent.month.component(mode: mode) ? monthSelectedTextColor : yearSelectedTextColor
        case .month:
            return monthSelectedTextColor
        case .year:
            return yearSelectedTextColor
        }
    }

    private func color(component: Int) -> UIColor {
        switch mode {
        case .mothAndYear:
            return component == DatePickerComponent.month.component(mode: mode) ? monthTextColor : yearTextColor
        case .month:
            return monthTextColor
        case .year:
            return yearTextColor
        }
    }

    private func selectedFont(component: Int) -> UIFont {
        switch mode {
        case .mothAndYear:
            return component == DatePickerComponent.month.component(mode: mode) ? monthSelectedFont : yearSelectedFont
        case .month:
            return monthSelectedFont
        case .year:
            return yearSelectedFont
        }
    }

    private func font(component: Int) -> UIFont {
        switch mode {
        case .mothAndYear:
            return component == DatePickerComponent.month.component(mode: mode) ? monthFont : yearFont
        case .month:
            return monthFont
        case .year:
            return yearFont
        }
    }

    private func title(row: Int, component: Int) -> String {
        switch mode {
        case .mothAndYear:
            return component == DatePickerComponent.month.component(mode: mode) ? months[row % months.count] : years[row % years.count]
        case .month:
            return months[row % months.count]
        case .year:
            return years[row % years.count]
        }
    }
}
