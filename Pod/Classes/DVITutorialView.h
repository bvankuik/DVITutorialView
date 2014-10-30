#import <UIKit/UIKit.h>



@interface DVITutorialView : UIView

@property (strong, nonatomic) NSArray *tutorialStrings;
@property (strong, nonatomic)  NSArray *tutorialViews;
@property (weak, nonatomic) UIViewController *coveredViewController;

- (void)addToView:(UIView*)view;
- (void)start;

@end
