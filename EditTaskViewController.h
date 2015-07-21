//
//  EditTaskViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 15/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditTaskViewControllerDelegate

-(void)editingInfoWasFinished;

@end


@interface EditTaskViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate>
{
    NSArray *pickerObjs;
    
}

@property (nonatomic, strong) id<EditTaskViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *taskName;

@property (weak, nonatomic) IBOutlet UITextField *projectName;

@property (weak, nonatomic) IBOutlet UITextField *dueDate;

@property (nonatomic) int recordIDToEdit;

- (IBAction)saveInfo:(id)sender;

@end
