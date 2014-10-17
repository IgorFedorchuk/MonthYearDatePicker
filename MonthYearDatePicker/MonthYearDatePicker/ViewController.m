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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.picker selectToday];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
