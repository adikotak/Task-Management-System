//
//  ViewDueTodayTableViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 09/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "ViewDueTodayTableViewController.h"
#import "TaskViewController.h"
#import "EditTaskViewController.h"
#import "DBManager.h"

@interface ViewDueTodayTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrTaskInfo;

@property (nonatomic) int recordIDToEdit;

@end

@implementation ViewDueTodayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblTasktwo.delegate = self;
    self.tblTasktwo.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];
    
    // Load the data.
    [self loadData];
    self.tblTasktwo.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrTaskInfo.count;
}

-(void)loadData{
    // Form the query.
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *todaysDate = [NSString stringWithFormat:@"%@%@%@",@"'",[dateFormatter stringFromDate:datePicker.date], @"'"];
    NSString *query =  [NSString stringWithFormat:@"%@%@", @"select * from TaskInfo where DueDate = ", todaysDate];

    
    // Get the results.
    if (self.arrTaskInfo != nil) {
        self.arrTaskInfo = nil;
    }
    
    self.arrTaskInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblTasktwo reloadData];
}

-(NSString *) getCount{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[_arrTaskInfo count]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfTask = [self.dbManager.arrColumnNames indexOfObject:@"Task"];
    NSInteger indexOfDueDate = [self.dbManager.arrColumnNames indexOfObject:@"DueDate"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfTask]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDueDate]];
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.recordIDToEdit = [[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EditTaskViewController *taskViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
    taskViewController.recordIDToEdit = self.recordIDToEdit;
    
    [self.navigationController pushViewController:taskViewController animated:YES];
     [_tblTasktwo deselectRowAtIndexPath:indexPath animated:YES];
    self.recordIDToEdit = -1;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from TaskInfo where TMSInfoID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
        //        [arrTaskInfo ];
        [self.tblTasktwo reloadData];
    }
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}

@end
