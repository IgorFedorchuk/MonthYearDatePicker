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
    case month, year
}

class DatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    fileprivate let bigRowCount = 1000
    fileprivate let componentsCount = 2
    var minYear = 2008
    var maxYear = 2031
    var rowHeight : CGFloat = 44
    
    var monthFont = UIFont.boldSystemFont(ofSize: 17)
    var monthSelectedFont = UIFont.boldSystemFont(ofSize: 17)
    
    var yearFont = UIFont.boldSystemFont(ofSize: 17)
    var yearSelectedFont = UIFont.boldSystemFont(ofSize: 17)

    var monthTextColor = UIColor.black
    var monthSelectedTextColor = UIColor.blue
    
    var yearTextColor = UIColor.black
    var yearSelectedTextColor = UIColor.blue
        
    fileprivate let formatter = DateFormatter.init()

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
    
    fileprivate var todayIndexPath : IndexPath
    {
        var row = 0
        var section = 0
        let currentMonthName = self.currentMonthName
        let currentYearName = self.currentYearName

        for month in months
        {
            if month == currentMonthName
            {
                row = months.firstIndex(of: month)!
                row += bigRowMonthCount / 2
                break;
            }
        }
        
        for year in years
        {
            if year == currentYearName
            {
                section = years.firstIndex(of: year)!
                section += bigRowYearCount / 2
                break;
            }
        }
        return IndexPath.init(row: row, section: section)
    }
    
    var date : Date
    {
        let month = months[selectedRow(inComponent: DatePickerComponent.month.rawValue) % months.count]
        let year = years[selectedRow(inComponent: DatePickerComponent.year.rawValue) % years.count]
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMMM:yyyy"
        let date = formatter.date(from: "\(month):\(year)")
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
        selectRow((todayIndexPath as NSIndexPath).row, inComponent: DatePickerComponent.month.rawValue, animated: false)
        selectRow((todayIndexPath as NSIndexPath).section, inComponent: DatePickerComponent.year.rawValue, animated: false)
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
        if component == DatePickerComponent.month.rawValue
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
        if component == DatePickerComponent.month.rawValue
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
        if component == DatePickerComponent.month.rawValue
        {
            return monthSelectedTextColor
        }
        return yearSelectedTextColor
    }
    
    fileprivate func colorForComponent(_ component : Int) -> UIColor
    {
        if component == DatePickerComponent.month.rawValue
        {
            return monthTextColor
        }
        return yearTextColor
    }
    
    fileprivate func selectedFontForComponent(_ component : Int) -> UIFont
    {
        if component == DatePickerComponent.month.rawValue
        {
            return monthSelectedFont
        }
        return yearSelectedFont
    }
    
    fileprivate func fontForComponent(_ component : Int) -> UIFont
    {
        if component == DatePickerComponent.month.rawValue
        {
            return monthFont
        }
        return yearFont
    }
    
    fileprivate func titleForRow(_ row : Int, component : Int) -> String
    {
        if component == DatePickerComponent.month.rawValue
        {
            return months[row % months.count]
        }
        return years[row % years.count]
    }
}
