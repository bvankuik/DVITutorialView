#import <UIKit/UIKit.h>


/**
 * See the README.md file for a general description.
 */
@interface DVITutorialView : UIView

/**
 * Set a bunch of NSStrings (or NSLocalizedStrings) with an explanation per view.
 */
@property (strong, nonatomic) NSArray *tutorialStrings;

/**
 * Set an array of views that will be exposed. If you pass [UIView new] (which has an empty/zero frame),
 * then nothing will be exposed. This is useful for a welcome/exit tutorial page.
 */
@property (strong, nonatomic) NSArray *tutorialViews;

/**
 * Override the default mask color.
 */
@property (strong, nonatomic) UIColor *maskColor;

/**
 * Override the default tutorial label background color.
 */
@property (strong, nonatomic) UIColor *textBackgroundColor;

/**
 * After instantiation, call this method to add the tutorial view to your viewcontroller's main view and add
 * the constraints to make the tutorial view cover the complete frame of its superview. Alternatively, don't use this
 * method and add a view via interface builder and set the appropriate constraints.
 * @param view pass self.view from your viewcontroller
 */
- (void)addToView:(UIView*)view;

/**
 * After setting the tutorialStrings and tutorialViews properties, call this method.
 */
- (void)start;

@end
