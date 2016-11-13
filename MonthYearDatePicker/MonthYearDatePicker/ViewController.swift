//
//  ViewController.swift
//  MonthYearDatePicker
//
//  Created by Igor Fedorchuk on 05/04/16.
//  Copyright © 2016 Igor. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet fileprivate var picker : DatePickerView!
    fileprivate var pickerFromCode : CDatePickerViewEx = CDatePickerViewEx.init(frame: CGRect.zero)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        picker.minYear = 2000
        picker.maxYear = 2020
        picker.rowHeight = 60
        
        picker.selectToday()
        picker.selectRow(50, inComponent: 1, animated: false)
        picker.selectRow(500, inComponent: 0, animated: false)
        
        var frame = picker.bounds
        frame.origin.y = picker.frame.size.height
        pickerFromCode.frame = frame
        
        view.addSubview(pickerFromCode)
        pickerFromCode.selectToday()
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
