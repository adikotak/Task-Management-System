//
//  ViewByProjectViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 09/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "ViewByProjectViewController.h"
#import "DBManager.h"
#import "EditTaskViewController.h"

@interface ViewByProjectViewController ()
{
    UIPickerView *projectPicker;
}

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrTaskInfo;

@property (nonatomic) int recordIDToEdit;

@end

@implementation ViewByProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Make self the delegate and datasource of the table view.
    self.thirTblTask.delegate = self;
    self.thirTblTask.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];
    
    // Load the data.
    self.thirTblTask.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    projectPicker = [[UIPickerView alloc]init];
    projectPicker.dataSource = self;
    projectPicker.delegate = self;
    [projectPicker setShowsSelectionIndicator:YES];
    [self.selectProject setInputView:projectPicker];
    NSString *query = [NSString stringWithFormat:@"select Project from ProjectInfo", self.recordIDToEdit];
    objs = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];


    
    [self loadData];

}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return objs.count;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [objs[row] objectAtIndex:0];
}

-(void) pickerView: (UIPickerView*) pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectProject.text = [objs[row]objectAtIndex:0];
    [self loadData];
    [projectPicker endEditing:YES];
    
}


- (IBAction)hideOnTouch:(id)sender
{
   //[self.selectProject setInputView:nil];
    [self.selectProject resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddTaskViewController *taskViewController = [segue destinationViewController];
    taskViewController.delegate = self;
    taskViewController.recordIDToEdit = self.recordIDToEdit;
}


#pragma mark - IBAction method implementation

- (IBAction)addNewRecord:(id)sender {
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    self.recordIDToEdit = -1;
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}


#pragma mark - Private method implementation

-(void)loadData{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"%@%@%@%@", @"select * from TaskInfo where Project = ", @"'", self.selectProject.text, @"'" ];
    
    // Get the results.
    if (self.arrTaskInfo != nil) {
        self.arrTaskInfo = nil;
    }
    self.arrTaskInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.thirTblTask reloadData];
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
     [_thirTblTask deselectRowAtIndexPath:indexPath animated:YES];
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
        [self.thirTblTask reloadData];
    }
}


#pragma mark - AddTaskViewControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}


@end
