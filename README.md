It is a sublcass of UIPickerView. You can display month and year using native iOS control. 

# Requirements
- iOS 13.0
- Xcode 15.0+
- iPhone/iPad
- Swift 5

# Screenshots
![Simulator Screenshot - iPhone 15 Pro - 2024-06-04 at 17 20 22](https://github.com/IgorFedorchuk/MonthYearDatePicker/assets/2764603/21dc1d1f-ecc9-46e4-9370-b159dc09606a)

# How to use
For clearer comprehension, please open the project located in the "Example" folder.
```
var picker = DatePickerView(frame: view.bounds)
picker.needRecenter = true
picker.minYear = 2020
picker.maxYear = 2030
picker.rowHeight = 60
picker.yearFont = UIFont.systemFont(ofSize: 17)
picker.monthFont = UIFont.systemFont(ofSize: 17)
picker.locale = Locale(identifier: "en_US")
picker.onYearChanged = { year in
    print("year: \(year)")
    print("date: \(String(describing: picker.date))")
}
picker.onMonthChanged = { index, name in
    print("name: \(name), index: \(index)")
    print("date: \(String(describing: picker.date))")
}
view.addSubview(picker)
picker.reloadAllComponents()
picker.selectToday()
```
