//
//  ViewController.m
//  MonthYearDatePicker
//
//  Created by Igor on 18.03.13.
//  Copyright (c) 2013 Igor. All rights reserved.
//

#import "ViewController.h"
#import "CDatePickerViewEx.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet CDatePickerViewEx *picker;
@property (nonatomic, strong) CDatePickerViewEx *pickerFromCode;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.picker selectToday];
    
    CGRect frame = self.picker.bounds;
    frame.origin.y = self.picker.frame.size.height;
    
    self.pickerFromCode = [[CDatePickerViewEx alloc] initWithFrame:frame];
    [self.view addSubview:self.pickerFromCode];
    [self.pickerFromCode selectToday];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
