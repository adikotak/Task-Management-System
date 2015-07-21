//
//  ViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 01/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (weak,nonatomic) IBOutlet UILabel *taskCounter;
@property (weak,nonatomic) IBOutlet UILabel *date;
@property (weak,nonatomic) IBOutlet UILabel *dueTodayLabel;


@end

