//
//  DVIViewController.m
//  DVITutorialView
//
//  Created by Bart van Kuik on 10/30/2014.
//  Copyright (c) 2014 Bart van Kuik. All rights reserved.
//

#import "DVIViewController.h"
#import <DVITutorialView/DVITutorialView.h>

@interface DVIViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation DVIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tutorialButtonTapped:(id)sender
{
    DVITutorialView *tutorialView = [[DVITutorialView alloc] init];
    [tutorialView addToView:self.view];
    
    tutorialView.tutorialStrings = @[
                                     @"Explanation on button",
                                     @"Explanation on this nice label",
                                     @"Some text on the text field",
                                     @"and finally, what this label is about",
                                     @"And a thank you on a blank screen",
                                     ];
    tutorialView.tutorialViews = @[
                                   self.button1,
                                   self.label1,
                                   self.textField1,
                                   self.label2,
                                   [[UIView alloc] init],
                                   ];
    [tutorialView start];
}

@end
