//
//  DatePickerView.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05/04/16.
//  Copyright © 2016 Igor. All rights reserved.
//

import UIKit

protocol onSelectMonthYear {
    func onSelect(_ date:Date)
}

class DatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    var monthYearDelegate:onSelectMonthYear? = nil
    fileprivate let bigRowCount = 1
    fileprivate var componentsCount = 2
    var minYear = 1965
    var maxYear = 2031
    var rowHeight : CGFloat = 38
    static let DEFAULT_FONT_SIZE:CGFloat = 23

    var monthFont = UIFont.systemFont(ofSize: DatePickerView.DEFAULT_FONT_SIZE)
    var monthSelectedFont = UIFont.systemFont(ofSize: DatePickerView.DEFAULT_FONT_SIZE)

    var yearFont = UIFont.systemFont(ofSize: DatePickerView.DEFAULT_FONT_SIZE)
    var yearSelectedFont = UIFont.systemFont(ofSize: DatePickerView.DEFAULT_FONT_SIZE)

    var monthTextColor = UIColor.black
    var monthSelectedTextColor = UIColor.black

    var yearTextColor = UIColor.black
    var yearSelectedTextColor = UIColor.black

    fileprivate let formatter = DateFormatter.init()

    fileprivate var monthIndex:Int? {
        // Если режим - месяц\год - месяц на первом месте. Если режим Год - месяц не показываем вообще
        if componentsCount > 1 {
            return 0
        }
        else {
            return nil
        }
    }

    fileprivate var yearIndex:Int {
        return componentsCount - 1
    }

    fileprivate var rowLabel : UILabel
    {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: componentWidth, height: rowHeight))
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }

    var months : Array<String>
    {
        return [NSLocalizedString("January", comment: ""), NSLocalizedString("February", comment: ""), NSLocalizedString("March", comment: ""), NSLocalizedString("April", comment: ""), NSLocalizedString("May", comment: ""), NSLocalizedString("June", comment: ""), NSLocalizedString("July", comment: ""), NSLocalizedString("August", comment: ""), NSLocalizedString("September", comment: ""), NSLocalizedString("October", comment: ""), NSLocalizedString("November", comment: ""), NSLocalizedString("December", comment: "")]
    }

    var years : Array<String>
    {
        let years = [Int](minYear...maxYear)
        var names = [String]()
        for year in years
        {
            names.append(String(year))
        }
        return names
    }

    var currentMonthName : String
    {
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = "MMMM"
        let dateString = formatter.string(from: Date.init())
        return NSLocalizedString(dateString, comment: "")
    }

    var currentYearName : String
    {
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date.init())
    }

    fileprivate var bigRowMonthCount : Int
    {
        return months.count  * bigRowCount
    }

    fileprivate var bigRowYearCount : Int
    {
        return years.count  * bigRowCount
    }

    fileprivate var componentWidth : CGFloat
    {
        return self.bounds.size.width / CGFloat(componentsCount)
    }

    fileprivate func getIndex(forDate date:Date) -> (month: Int, year:Int) {

        let units: Set<Calendar.Component> = [.hour, .day, .month, .year]
        let comps = Calendar.current.dateComponents(units, from: date)

        return (comps.month! - 1, comps.year! - minYear)

    }

    fileprivate var todayIndexPath : (month: Int, year:Int)
    {
        return getIndex(forDate: Date())
    }

    var date : Date
        {
        get {
            var c = DateComponents()
            c.year = selectedRow(inComponent: yearIndex) + minYear
            if monthIndex != nil {
                c.month = selectedRow(inComponent: monthIndex!) + 1
            }
            else {
                c.month = 6
            }
            c.day = 15

            let calendar = Calendar(identifier: .gregorian)
            return calendar.date(from: c)!
        }

        set(newDate) {
            let index = getIndex(forDate: newDate)
            selectRows(month: index.month, year: index.year)
        }
    }

    //MARK: - Override

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        loadDefaultsParameters()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        loadDefaultsParameters()
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        loadDefaultsParameters()
    }

    fileprivate func selectRows(month: Int, year:Int) {
        if monthIndex != nil {
            selectRow(month, inComponent: monthIndex!, animated: false)
        }

        selectRow(year, inComponent: yearIndex, animated: false)
    }

    //MARK: - Open


    func selectToday()
    {
        let todayComps = todayIndexPath
        selectRows(month: todayComps.month, year: todayComps.year)
    }

    func setMonthYearMode() {
        componentsCount = 2
        reloadAllComponents()
    }

    func setYearMode() {
        componentsCount = 1
        reloadAllComponents()
    }

    //MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return componentWidth
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label : UILabel
        if view is UILabel
        {
            label = view as! UILabel
        }
        else
        {
            label = rowLabel
        }

        let selected = isSelectedRow(row, component: component)
        label.font = selected ? selectedFontForComponent(component) : fontForComponent(component)
        label.textColor = selected ? selectedColorForComponent(component) : colorForComponent(component)
        label.text = titleForRow(row, component: component)
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return rowHeight
    }

    //MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return componentsCount
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == monthIndex
        {
            return bigRowMonthCount
        }
        return bigRowYearCount
    }

    //MARK: - Private

    fileprivate func loadDefaultsParameters()
    {
        delegate = self
        dataSource = self
    }

    fileprivate func isSelectedRow(_ row : Int, component : Int) -> Bool
    {
        var selected = false
        if component == monthIndex
        {
            let name = months[row % months.count]
            if name == currentMonthName
            {
                selected = true
            }
        }
        else
        {
            let name = years[row % years.count]
            if name == currentYearName
            {
                selected = true
            }
        }

        return selected
    }

    fileprivate func selectedColorForComponent(_ component : Int) -> UIColor
    {
        if component == monthIndex
        {
            return monthSelectedTextColor
        }
        return yearSelectedTextColor
    }

    fileprivate func colorForComponent(_ component : Int) -> UIColor
    {
        if component == monthIndex
        {
            return monthTextColor
        }
        return yearTextColor
    }

    fileprivate func selectedFontForComponent(_ component : Int) -> UIFont
    {
        if component == monthIndex
        {
            return monthSelectedFont
        }
        return yearSelectedFont
    }

    fileprivate func fontForComponent(_ component : Int) -> UIFont
    {
        if component == monthIndex
        {
            return monthFont
        }
        return yearFont
    }

    fileprivate func titleForRow(_ row : Int, component : Int) -> String
    {
        if component == monthIndex
        {
            return months[row % months.count]
        }
        return years[row % years.count]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        monthYearDelegate?.onSelect(self.date)
        print (self.date)
    }
}
