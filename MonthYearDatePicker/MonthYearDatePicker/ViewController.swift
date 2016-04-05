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
    @IBOutlet private var picker : DatePickerView!
    private var pickerFromCode : CDatePickerViewEx = CDatePickerViewEx.init(frame: CGRectZero)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        picker.minYear = 2000
        picker.maxYear = 2020

        picker.selectToday()
        
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
