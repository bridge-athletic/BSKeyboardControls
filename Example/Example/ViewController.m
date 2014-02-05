//
//  ViewController.m
//  Example
//
//  Created by Simon B. Støvring on 11/01/13.
//  Copyright (c) 2013 simonbs. All rights reserved.
//

#import "ViewController.h"
#import "BSKeyboardControls.h"

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString *kDeveloperUrl = @"http://twitter.com/simonbs";

enum
{
    kSectionDeveloper = 4
};

enum
{
    kRowDeveloper = 0
};

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITextField *textFieldUsername;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPassword;
@property (nonatomic, weak) IBOutlet UITextField *textFieldRepeatedPassword;
@property (nonatomic, weak) IBOutlet UITextView *textViewAbout;
@property (nonatomic, weak) IBOutlet UITextField *textFieldFavoriteFood;
@property (nonatomic, weak) IBOutlet UITextField *textFieldFavoriteMovie;
@property (nonatomic, weak) IBOutlet UITextField *textFieldFavoriteBook;
@property (nonatomic, weak) IBOutlet UITextView *textViewNotes;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation ViewController

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *fields = @[ self.textFieldUsername, self.textFieldPassword,
                         self.textFieldRepeatedPassword, self.textViewAbout,
                         self.textFieldFavoriteFood, self.textFieldFavoriteMovie,
                         self.textFieldFavoriteBook, self.textViewNotes];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setSwitchOnTitle:@"kgs"];
    [self.keyboardControls setSwitchOffTitle:@"lbs"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTextFieldUsername:nil];
    [self setTextFieldPassword:nil];
    [self setTextFieldRepeatedPassword:nil];
    [self setTextViewAbout:nil];
    [self setTextFieldFavoriteFood:nil];
    [self setTextFieldFavoriteMovie:nil];
    [self setTextFieldFavoriteBook:nil];
    [self setTextViewNotes:nil];
    [self setKeyboardControls:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{    
    UIView *view;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        view = field.superview.superview;
    } else {
        view = field.superview.superview.superview;
    }
    
    [self.tableView scrollRectToVisible:view.frame animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}

- (void)keyboardControlsSwitchValueChanged:(BSKeyboardControls *)keyboardControls {
    NSLog(@"Switch changed!!  New Value:  %@", keyboardControls.switchOn ? keyboardControls.switchOnTitle : keyboardControls.switchOffTitle);
}

- (BOOL)isSwitchOnForKeyboardControls:(BSKeyboardControls *)keyboardControls withField:(UIView *)field {
    if (field == _textFieldUsername || field == _textFieldPassword || field == _textFieldRepeatedPassword || field == _textFieldFavoriteBook) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSectionDeveloper && indexPath.row == kRowDeveloper)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kDeveloperUrl]];
    }
}

@end
