//
//  TaskViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 03/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewDueTodayTableViewController.h"

@interface TaskViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *secBarButton;
@property (weak,nonatomic) IBOutlet UILabel *counter;

- (IBAction)addNewRecord:(id)sender;

@end
