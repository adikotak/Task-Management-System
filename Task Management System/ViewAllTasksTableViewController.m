//
//  ViewAllTasksTableViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 06/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "ViewAllTasksTableViewController.h"
#import "TaskViewController.h"
#import "EditTaskViewController.h"
#import "DBManager.h"

@interface ViewAllTasksTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrTaskInfo;

@property (nonatomic) int recordIDToEdit;


-(void)loadData;

@end


@implementation ViewAllTasksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Make self the delegate and datasource of the table view.
    self.tblTask.delegate = self;
    self.tblTask.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];
    
    // Load the data.
    [self loadData];
    self.tblTask.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    EditTaskViewController *taskViewController = [segue destinationViewController];
//    taskViewController.delegate = self;
//    taskViewController.recordIDToEdit = self.recordIDToEdit;
//}




#pragma mark - Private method implementation

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from TaskInfo";
    
    // Get the results.
    if (self.arrTaskInfo != nil) {
        self.arrTaskInfo = nil;
    }
    self.arrTaskInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblTask reloadData];
}


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrTaskInfo.count;
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



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.recordIDToEdit = [[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EditTaskViewController *taskViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
    taskViewController.recordIDToEdit = self.recordIDToEdit;
    
    [self.navigationController pushViewController:taskViewController animated:YES];
    
    // Perform the segue.
//    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
     [_tblTask deselectRowAtIndexPath:indexPath animated:YES];
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
        [self.tblTask reloadData];
    }
}


#pragma mark - AddTaskViewControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}


@end
