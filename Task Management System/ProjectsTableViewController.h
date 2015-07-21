//
//  ProjectsTableViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 13/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddProjectViewController.h"

@interface ProjectsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddProjectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblTask2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *thirBarButton;


- (IBAction)addNewRecord:(id)sender;

@end