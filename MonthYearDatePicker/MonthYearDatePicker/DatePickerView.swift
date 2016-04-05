//
//  DatePickerView.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05/04/16.
//  Copyright © 2016 Igor. All rights reserved.
//

import UIKit

enum DatePickerComponent : Int
{
    case Month, Year
}

class DatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    private let bigRowCount = 1000
    private let componentsCount = 2

    var monthFont = UIFont.boldSystemFontOfSize(17)
    var monthSelectedFont = UIFont.boldSystemFontOfSize(17)
    
    var yearFont = UIFont.boldSystemFontOfSize(17)
    var yearSelectedFont = UIFont.boldSystemFontOfSize(17)

    var monthTextColor = UIColor.blackColor()
    var monthSelectedTextColor = UIColor.blueColor()
    
    var yearTextColor = UIColor.blackColor()
    var yearSelectedTextColor = UIColor.blueColor()
    
    var minYear = 2008
    var maxYear = 2031
    var rowHeight : CGFloat = 44
    
    private let formatter = NSDateFormatter.init()

    private var rowLabel : UILabel
    {
        let label = UILabel.init(frame: CGRectMake(0, 0, componentWidth, rowHeight))
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
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
        formatter.locale = NSLocale.init(localeIdentifier: "en_US")
        formatter.dateFormat = "MMMM"
        let dateString = formatter.stringFromDate(NSDate.init())
        return NSLocalizedString(dateString, comment: "")
    }

    var currentYearName : String
    {
        formatter.locale = NSLocale.init(localeIdentifier: "en_US")
        formatter.dateFormat = "yyyy"
        return formatter.stringFromDate(NSDate.init())
    }
    
    private var bigRowMonthCount : Int
    {
        return months.count  * bigRowCount
    }
 
    private var bigRowYearCount : Int
    {
        return years.count  * bigRowCount
    }
    
    private var componentWidth : CGFloat
    {
        return self.bounds.size.width / CGFloat(componentsCount)
    }
    
    private var todayIndexPath : NSIndexPath
    {
        var row = 0
        var section = 0
        let currentMonthName = self.currentMonthName
        let currentYearName = self.currentYearName

        for month in months
        {
            if month == currentMonthName
            {
                row = months.indexOf(month)!
                row += bigRowMonthCount / 2
                break;
            }
        }
        
        for year in years
        {
            if year == currentYearName
            {
                section = years.indexOf(year)!
                section += bigRowYearCount / 2
                break;
            }
        }
        return NSIndexPath.init(forRow: row, inSection: section)
    }
    
    var date : NSDate
    {
        let month = months[selectedRowInComponent(DatePickerComponent.Month.rawValue) % months.count]
        let year = years[selectedRowInComponent(DatePickerComponent.Year.rawValue) % years.count]
        
        let formatter = NSDateFormatter.init()
        formatter.dateFormat = "MMMM:yyyy"
        let date = formatter.dateFromString("\(month):\(year)")
        return date!
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
    
    //MARK: - Open

    func selectToday()
    {
        selectRow(todayIndexPath.row, inComponent: DatePickerComponent.Month.rawValue, animated: false)
        selectRow(todayIndexPath.section, inComponent: DatePickerComponent.Year.rawValue, animated: false)
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return componentWidth
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
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
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return rowHeight
    }
    
    //MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return componentsCount
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == DatePickerComponent.Month.rawValue
        {
            return bigRowMonthCount
        }
        return bigRowYearCount
    }
    
    //MARK: - Private
    
    private func loadDefaultsParameters()
    {
        delegate = self
        dataSource = self
    }
    
    private func isSelectedRow(row : Int, component : Int) -> Bool
    {
        var selected = false
        if component == DatePickerComponent.Month.rawValue
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
    
    private func selectedColorForComponent(component : Int) -> UIColor
    {
        if component == DatePickerComponent.Month.rawValue
        {
            return monthSelectedTextColor
        }
        return yearSelectedTextColor
    }
    
    private func colorForComponent(component : Int) -> UIColor
    {
        if component == DatePickerComponent.Month.rawValue
        {
            return monthTextColor
        }
        return yearTextColor
    }
    
    private func selectedFontForComponent(component : Int) -> UIFont
    {
        if component == DatePickerComponent.Month.rawValue
        {
            return monthSelectedFont
        }
        return yearSelectedFont
    }
    
    private func fontForComponent(component : Int) -> UIFont
    {
        if component == DatePickerComponent.Month.rawValue
        {
            return monthFont
        }
        return yearFont
    }
    
    private func titleForRow(row : Int, component : Int) -> String
    {
        if component == DatePickerComponent.Month.rawValue
        {
            return months[row % months.count]
        }
        return years[row % years.count]
    }
}
