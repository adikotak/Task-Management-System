//
//  AddTaskViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 06/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "EditTaskViewController.h"
#import "DBManager.h"

@interface EditTaskViewController ()


@property (nonatomic, strong) DBManager *dbManager;
//@property (nonatomic, weak) UIPickerView *projectPicker;

-(void)loadInfoToEdit;

@end

@implementation EditTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Make self the delegate of the textfields.
    self.taskName.delegate = self;
    self.projectName.delegate = self;
    self.dueDate.delegate = self;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
    
    UIPickerView *projectPicker = [[UIPickerView alloc]init];
    projectPicker.dataSource = self;
    projectPicker.delegate = self;
    [projectPicker setShowsSelectionIndicator:YES];
    [self.projectName setInputView:projectPicker];
    NSString *query = [NSString stringWithFormat:@"select Project from ProjectInfo", self.recordIDToEdit];
    
    // Load the relevant data.
    pickerObjs = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    //    _pickerObjs = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB: [NSString stringWithFormat:@"select * from ProjectInfo where ProjectInfoID=%d", self.recordIDToEdit]]];
    
    
    
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    [datePicker setMinimumDate: [NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker setDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    self.dueDate.text = [dateFormatter stringFromDate:datePicker.date];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dueDate setInputView:datePicker];
    
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerObjs.count;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerObjs[row] objectAtIndex:0];
}

-(void) pickerView: (UIPickerView*) pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.projectName.text = [pickerObjs[row]objectAtIndex:0];
}


-(void)updateTextField:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    self.dueDate.text = [dateFormatter stringFromDate:((UIDatePicker*)sender).date];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IBAction method implementation

- (IBAction)saveInfo:(id)sender {
    NSString *query = [NSString stringWithFormat:@"update TaskInfo set Task='%@', Project='%@', DueDate='%@' where TMSInfoID=%d", self.taskName.text, self.projectName.text, self.dueDate.text, self.recordIDToEdit];
//    if (self.recordIDToEdit != -1) {
//        query = [NSString stringWithFormat:@"update TaskInfo set Task='%@', Project='%@', DueDate='%@' where TaskInfoID=%d", self.taskName.text, self.projectName.text, self.dueDate.text, self.recordIDToEdit];
//    }
//    else{
//        query = [NSString stringWithFormat:@"insert into TaskInfo values(null, '%@', '%@', '%@')", self.taskName.text, self.projectName.text, self.dueDate.text];
//    }
    
    
    // Execute the query.
    if (self.taskName.text.length>0 && self.projectName.text.length > 0 && self.dueDate.text.length>0)
    {
        [self.dbManager executeQuery:query];
    }
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        [self.navigationController popViewControllerAnimated:YES];
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}


#pragma mark - Private method implementation

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from TaskInfo where TMSInfoID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if (results.count>0)
    {
        // Set the loaded data to the textfields.
        self.taskName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Task"]];
        self.projectName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Project"]];
        self.dueDate.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject: @"DueDate"]];
        
    }
}


@end
