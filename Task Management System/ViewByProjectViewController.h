//
//  ViewByProjectViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 09/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"

@interface ViewByProjectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddTaskViewControllerDelegate>
{
    NSArray *objs;
}

@property (weak, nonatomic) IBOutlet UITextField *selectProject;
@property (weak, nonatomic) IBOutlet UITableView *thirTblTask;

- (IBAction)hideOnTouch:(id)sender;

@end
