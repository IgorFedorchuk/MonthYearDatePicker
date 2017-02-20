//
//  ViewController.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05/04/16.
//  Copyright © 2016 Igor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, onSelectMonthYear
{

    let dateFormatter = DateFormatter()
    func onSelect(_ date:Date) {
        update(date)
    }
    @IBAction func onYear(_ sender: Any) {
        picker.setYearMode()
         picker.selectToday()
    }

    @IBAction func onMonth(_ sender: Any) {
        picker.setMonthYearMode()
         picker.selectToday()
    }
    
    func update(_ date:Date) {
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM, YYYY")
        lSelectedDate.text = dateFormatter.string(from: date)
    }

    @IBOutlet fileprivate var picker : DatePickerView!
    fileprivate var pickerFromCode : CDatePickerViewEx = CDatePickerViewEx.init(frame: CGRect.zero)
    
    @IBOutlet weak var lSelectedDate: UILabel!

    @IBAction func onChangedDate(_ sender: UIDatePicker) {
        picker.date = sender.date
        update(sender.date)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        picker.minYear = 1965
        picker.maxYear = 2035
        picker.rowHeight = 60
        
        picker.selectToday()

        var frame = picker.bounds
        frame.origin.y = picker.frame.size.height
        pickerFromCode.frame = frame
        
//        view.addSubview(pickerFromCode)
//        pickerFromCode.selectToday()
        picker.monthYearDelegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
