//
//  ProjectsTableViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 13/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "SWRevealViewController.h"
#import "AddProjectViewController.h"
#import "DBManager.h"

@interface ProjectsTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrTaskInfo;

@property (nonatomic) int recordIDToEdit;


-(void)loadData;

@end


@implementation ProjectsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _thirBarButton.target = self.revealViewController;
    _thirBarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    // Make self the delegate and datasource of the table view.
    self.tblTask2.delegate = self;
    self.tblTask2.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];
    
    // Load the data.
    [self loadData];
    self.tblTask2.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddProjectViewController *projectViewController = [segue destinationViewController];
    projectViewController.delegate = self;
    projectViewController.recordIDToEdit = self.recordIDToEdit;
}


#pragma mark - IBAction method implementation

- (IBAction)addNewRecord:(id)sender {
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    self.recordIDToEdit = -1;
    
    // Perform the segue.
    //[self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}


#pragma mark - Private method implementation

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from ProjectInfo";
    
    // Get the results.
    if (self.arrTaskInfo != nil) {
        self.arrTaskInfo = nil;
    }
    self.arrTaskInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblTask2 reloadData];
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
    
    NSInteger indexOfProject = [self.dbManager.arrColumnNames indexOfObject:@"Project"];
    NSInteger indexOfDueDate = [self.dbManager.arrColumnNames indexOfObject:@"DueDate"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfProject]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDueDate]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.recordIDToEdit = [[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
    [_tblTask2 deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from ProjectInfo where ProjectInfoID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
        //        [arrTaskInfo ];
        [self.tblTask2 reloadData];
    }
}


#pragma mark - AddTaskViewControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}


@end
