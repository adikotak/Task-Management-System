//
//  ViewDueTodayTableViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 09/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"

@interface ViewDueTodayTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblTasktwo;

-(NSString *) getCount;

@end