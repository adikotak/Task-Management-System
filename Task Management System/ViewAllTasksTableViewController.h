//
//  ViewAllTasksTableViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 06/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"

@interface ViewAllTasksTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblTask;


@end

