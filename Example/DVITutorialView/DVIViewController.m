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
                                     @"Explanation on this nice label",
                                     @"A long and warm multi-line welcome if you're on a phone. What could we tell more?",
                                     @"And a thank you on a blank screen, with a somewhat longer text",
                                     @"Some text on the text field",
                                     @"and what this label is about",
                                     @"It's a button, folks",
                                     ];
    tutorialView.tutorialViews = @[
                                   self.label1,
                                   [UIView new],
                                   [UIView new],
                                   self.textField1,
                                   self.label2,
                                   self.button1,
                                   ];
    
    tutorialView.maskColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:0.75];
    tutorialView.textBackgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:0.5];
    [tutorialView startWithCompletion:^(){
        NSLog(@"The End!");
    }];
}

@end
