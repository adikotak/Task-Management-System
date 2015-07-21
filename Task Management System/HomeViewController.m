//
//  ViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 01/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "DBManager.h"

@interface HomeViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view, typically from a nib.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];

}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *todaysDate = [NSString stringWithFormat:@"%@%@%@",@"'",[dateFormatter stringFromDate:[NSDate date]], @"'"];
    NSString *query =  [NSString stringWithFormat:@"%@%@", @"select * from TaskInfo where DueDate = ", todaysDate];
    
    NSString *theDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[self.dbManager loadDataFromDB:query].count];
    self.taskCounter.text = [NSString stringWithFormat:@"%@", count];
    self.date.text = theDate;
    if ([self.dbManager loadDataFromDB:query].count != 1)
    {
        self.dueTodayLabel.text = @"tasks due today";
    }
    else{
        self.dueTodayLabel.text = @"task due today";
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
