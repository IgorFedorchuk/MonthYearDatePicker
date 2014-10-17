//
//  CDatePickerViewEx.h
//  MonthYearDatePicker
//
//  Created by Igor on 18.03.13.
//  Copyright (c) 2013 Igor. All rights reserved.
//

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIColor *monthSelectedColor;
@property (nonatomic, strong) UIColor *daySelectedColor;

@property (nonatomic, strong, readonly) NSDate *date;

-(void)selectToday;

@end
