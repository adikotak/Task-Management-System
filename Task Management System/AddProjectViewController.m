//
//  AddProjectViewController.m
//  Task Management System
//
//  Created by Aditya Kotak on 09/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import "AddProjectViewController.h"
#import "DBManager.h"

@interface AddProjectViewController ()


@property (nonatomic, strong) DBManager *dbManager;

-(void)loadInfoToEdit;

@end

@implementation AddProjectViewController

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
    self.projectName.delegate = self;
    self.clientName.delegate = self;
    self.pmName.delegate = self;
    self.workers.delegate = self;
    self.dueDate.delegate = self;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tmsdb.sql"];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setMinimumDate: [NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker setDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    self.dueDate.text = [dateFormatter stringFromDate:datePicker.date];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dueDate setInputView:datePicker];
    
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
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    if (self.recordIDToEdit != -1) {
        query = [NSString stringWithFormat:@"update ProjectInfo set Project='%@', Client='%@', PM='%@', Workers='%@', DueDate='%@' where ProjectInfoID=%d", self.projectName.text, self.clientName.text, self.pmName.text, self.workers.text, self.dueDate.text, self.recordIDToEdit];
    }
    else{
        query = [NSString stringWithFormat:@"insert into ProjectInfo values(null, '%@', '%@', '%@', '%@', '%@')", self.projectName.text, self.clientName.text, self.pmName.text, self.workers.text, self.dueDate.text];

    }
    
    
    // Execute the query.
    if (self.projectName.text.length>0 && self.clientName.text.length > 0 && self.pmName.text.length>0 && self.workers.text.length>0 && self.dueDate.text >0)
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
    NSString *query = [NSString stringWithFormat:@"select * from ProjectInfo where ProjectInfoID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if (results.count>0)
    {
        // Set the loaded data to the textfields.
        self.projectName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Project"]];
        self.clientName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Client"]];
        self.pmName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"PM"]];
        self.workers.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Workers"]];
        self.dueDate.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject: @"DueDate"]];
        
    }
}


@end
