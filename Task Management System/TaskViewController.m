//
//  TaskViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 03/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "TaskViewController.h"
#import "SWRevealViewController.h"
#import "DBManager.h"
#import "AddTaskViewController.h"
@interface TaskViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrTaskInfo;

@property (nonatomic) int recordIDToEdit;


@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _secBarButton.target = self.revealViewController;
    _secBarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *todaysDate = [NSString stringWithFormat:@"%@%@%@",@"'",[dateFormatter stringFromDate:[NSDate date]], @"'"];
    NSString *query =  [NSString stringWithFormat:@"%@%@", @"select * from TaskInfo where DueDate = ", todaysDate];

    
  self.counter.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.dbManager loadDataFromDB:query].count];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewRecord:(id)sender
{

    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddTaskViewController *taskViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    
    [self.navigationController pushViewController:taskViewController animated:YES];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
