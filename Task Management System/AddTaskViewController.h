//
//  AddTaskViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 06/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTaskViewControllerDelegate

-(void)editingInfoWasFinished;

@end


@interface AddTaskViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *pickerObjs;

}

@property (nonatomic, strong) id<AddTaskViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *taskName;

@property (weak, nonatomic) IBOutlet UITextField *projectName;

@property (weak, nonatomic) IBOutlet UITextField *dueDate;

@property (nonatomic) int recordIDToEdit;

- (IBAction)saveInfo:(id)sender;

@end
