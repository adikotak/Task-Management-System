//
//  AddProjectViewController.h
//  Task Management System
//
//  Created by Aditya Kotak on 09/07/15.
//  Copyright (c) 2015 HiTechOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddProjectViewControllerDelegate

-(void)editingInfoWasFinished;

@end


@interface AddProjectViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) id<AddProjectViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *projectName;

@property (weak, nonatomic) IBOutlet UITextField *clientName;

@property (weak, nonatomic) IBOutlet UITextField *pmName;

@property (weak, nonatomic) IBOutlet UITextField *workers;

@property (weak, nonatomic) IBOutlet UITextField *dueDate;

@property (nonatomic) int recordIDToEdit;

- (IBAction)saveInfo:(id)sender;


@end
