#import "DVITutorialView.h"
#import <QuartzCore/QuartzCore.h>


// If uncommented, debugging is disabled
//#define DLog(...)

// If you use Crashlytics, simply change the NSLog below to CLNSLog
#define DLog(__FORMAT__, ...) NSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// When set to 1, draws a border around most views created in this class. Useful when debugging layout issues
#define DEBUG_BORDERS 0

// A little shorthand
#define IS_IPAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)



@interface DVITutorialView()

@property CAShapeLayer *mask;
@property NSMutableArray *tutorialLabels;
@property UIPageControl *pageControlTop;
@property UIPageControl *pageControlBottom;
@end



@implementation DVITutorialView {
    int currentStep;
    BOOL constraintsAreSetup;
}

- (id)initWithCoder:(NSCoder*)coder
{
    DLog(@"entry");
    
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    DLog(@"entry");
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    DLog(@"entry");
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Initialize some variables
    self.tutorialStrings = @[];
    self.tutorialViews = @[];
    self.tutorialLabels = [[NSMutableArray alloc] init];
    currentStep = -1;
    constraintsAreSetup = NO;
    
    // Create UI elements
    [self setupMask];
    [self addGestures];
    self.pageControlTop = [[UIPageControl alloc] init];
    self.pageControlTop.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.pageControlTop];
    self.pageControlTop.alpha = 0;
    self.pageControlBottom = [[UIPageControl alloc] init];
    self.pageControlBottom.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControlBottom.alpha = 0;
    [self addSubview:self.pageControlBottom];

    if(DEBUG_BORDERS) {
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 1.0;
    }
    self.alpha = 0;
    self.hidden = YES;
}

- (void)addToView:(UIView*)view
{
    [view addSubview:self];
    [self constrainSelfToSuperview:view];
    [self layoutIfNeeded];
}

#pragma - Initialization

- (UILabel *)labelForTutorialWithText:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:18.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:title];
    [label setNumberOfLines:4];
    [label setBackgroundColor:[UIColor clearColor]];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(DEBUG_BORDERS) {
        label.layer.borderColor = [UIColor blueColor].CGColor;
        label.layer.borderWidth = 1.0;
    }
    return label;
}

- (void)createTutorialLabels
{
    for(NSString *s in self.tutorialStrings) {
        [self.tutorialLabels addObject:[self labelForTutorialWithText:s]];
    }
    
    [self setupConstraintsForTutorialLabels];
}

- (void)addGestures
{
    DLog(@"entry");

    // Next page
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToPreviousStep:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:recognizer];

    // Next page
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToNextStep:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:recognizer];
}

#pragma mark - Layout

+ (BOOL)requiresConstraintBasedLayout
{
    DLog(@"entry");
    return YES;
}

- (void)constrainSelfToSuperview:(UIView*)superview
{
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:superview
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:self
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:superview
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:self
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:superview
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    [superview addConstraint:width];
    [superview addConstraint:height];
    [superview addConstraint:top];
    [superview addConstraint:leading];
}

- (void)setupConstraintsForTutorialLabels
{
    DLog(@"entry");
    
    for(int i = 0; i < [self.tutorialViews count]; i++) {
        UIView *currentView = self.tutorialViews[i];
        UILabel *tutorialLabel = self.tutorialLabels[i];
        tutorialLabel.alpha = 0;
        
        // Add tutorial label with correct constraints
        [self addSubview:tutorialLabel];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint
                                       constraintWithItem:tutorialLabel
                                       attribute:NSLayoutAttributeCenterX
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self
                                       attribute:NSLayoutAttributeCenterX
                                       multiplier:1.f constant:0.f];
        [self addConstraint:centerX];
        
        if(CGRectIsEmpty(currentView.frame)) {
            DLog(@"This view has an empty frame, centering label");
            NSLayoutConstraint *centerY = [NSLayoutConstraint
                                           constraintWithItem:tutorialLabel
                                           attribute:NSLayoutAttributeCenterY
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                           attribute:NSLayoutAttributeCenterY
                                           multiplier:1.f constant:0.f];
            [self addConstraint:centerY];
            
        } else {
            
            DLog(@"currentView.frame.origin.y=%f, self.bounds.size.height=%f", currentView.frame.origin.y, self.bounds.size.height);
            
            float distanceToSwipeLabel = (IS_IPAD ? 50.0 : 8.0);

            if(currentView.frame.origin.y < (self.bounds.size.height/2.0)) {
                // See if we're above or below the middle
                DLog(@"currently exposed view its origin is in the upper half of the screen");
                NSLayoutConstraint *bottom = [NSLayoutConstraint
                                              constraintWithItem:tutorialLabel
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.pageControlBottom
                                              attribute:NSLayoutAttributeTopMargin
                                              multiplier:1.0f
                                              constant:-distanceToSwipeLabel];
                [self addConstraint:bottom];
                
            } else {
                DLog(@"currently exposed view its origin is in the lower half of the screen");
                NSLayoutConstraint *top = [NSLayoutConstraint
                                           constraintWithItem:tutorialLabel
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:self.pageControlTop
                                           attribute:NSLayoutAttributeBottom
                                           multiplier:1.0f
                                           constant:distanceToSwipeLabel];
                [self addConstraint:top];
                
            }
            
            NSLayoutConstraint *width = [NSLayoutConstraint
                                     constraintWithItem:tutorialLabel
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1.0f
                                     constant:-40];
            [self addConstraint:width];
        }
    }
}

- (void)setupConstraintsForPageControl:(BOOL)atTop
{
    DLog(@"entry");
    
    UIView *pageControl = (atTop ? self.pageControlTop : self.pageControlBottom);
    
    if(DEBUG_BORDERS) {
        pageControl.layer.borderColor = [UIColor redColor].CGColor;
        pageControl.layer.borderWidth = 1.0;
    }
    
    // Swipe label constraints
    float distance = (IS_IPAD ? 50.0 : 8.0);
    if(atTop) {
        NSLayoutConstraint *top = [NSLayoutConstraint
                                      constraintWithItem:pageControl
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                      attribute:NSLayoutAttributeTop
                                      multiplier:1.0f
                                      constant:distance];
        [self addConstraint:top];
    } else {
        NSLayoutConstraint *bottom = [NSLayoutConstraint
                                      constraintWithItem:pageControl
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:-distance];
        [self addConstraint:bottom];
    }
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint
                                   constraintWithItem:pageControl
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self
                                   attribute:NSLayoutAttributeCenterX
                                   multiplier:1.f constant:0.f];
    [self addConstraint:centerX];
}

- (void)updateConstraints
{
    if(!constraintsAreSetup) {
        [self setupConstraintsForPageControl:YES];
        [self setupConstraintsForPageControl:NO];
        constraintsAreSetup = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    DLog(@"entry");

    if(currentStep == -1) {
        DLog(@"Not yet initialized");
        return;
    }

    [self setupMask];
    CGRect frame = [self frameForCurrentView];
    [self setCutAtRect:frame];
    UIView *currentView = self.tutorialViews[currentStep];
    
    DLog(@"currentView.frame=%@", NSStringFromCGRect(currentView.frame));
}

#pragma mark - Touches and other actions

- (void)swipeToNextStep:(UISwipeGestureRecognizer*)recognizer
{
    DLog(@"entry");
    [self stepInTutorial:1 withAnimation:YES];
}

- (void)swipeToPreviousStep:(UISwipeGestureRecognizer*)recognizer
{
    DLog(@"entry");
    [self stepInTutorial:-1 withAnimation:YES];
}

- (void)start
{
    DLog(@"entry");
    
    // Some checks
    if([self.tutorialStrings count] == 0 || [self.tutorialViews count] == 0) {
        DLog(@"Can't start tutorial, there aren't any");
        return;
    }
    
    if([self.tutorialStrings count] != [self.tutorialViews count]) {
        DLog(@"Can't start tutorial, the number of strings and views is not equal");
        return;
    }
    
    // Initialize the pager
    self.pageControlTop.numberOfPages = [self.tutorialStrings count];
    self.pageControlTop.currentPage = 0;
    self.pageControlBottom.numberOfPages = [self.tutorialStrings count];
    self.pageControlBottom.currentPage = 0;
    
    // Create labels for each string
    [self createTutorialLabels];
    
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    [self stepInTutorial:1 withAnimation:NO];
}

- (void)cleanUp
{
    DLog(@"entry");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Paging

- (void)setupMask
{
    DLog(@"entry");
    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setFillRule:kCAFillRuleEvenOdd];
    [layer setFillColor:[[UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:0.95] CGColor]];
    
    if(self.mask != nil) {
        DLog(@"Replacing existing mask");
        [self.layer insertSublayer:layer atIndex:0];
        [self.mask removeFromSuperlayer];
        self.mask = nil;
        self.mask = layer;
    } else {
        DLog(@"Inserting new mask");
        [self.layer insertSublayer:layer atIndex:0];
        self.mask = layer;
    }
}

// Returns the frame for the view that should be currently highlighted in the tutorial. If the view
// has a special method for a custom CGRect to be highlighted, call that one.
- (CGRect)frameForCurrentView
{
    DLog(@"entry");

    CGRect retval = CGRectZero;
    CGRect frameToConvert = CGRectZero;
    UIView *currentView = self.tutorialViews[currentStep];
    
    if(CGRectIsEmpty(currentView.frame)) {
        // This is appropriate if some kind of welcome or exit text will be displayed
        return retval;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    BOOL hasVisibleFrame = [currentView respondsToSelector:@selector(visibleFrameAsValue)];
    
    if(hasVisibleFrame) {
        DLog(@"has visible frame");
        NSValue *frameValue = (NSValue*)[currentView performSelector:@selector(visibleFrameAsValue)];
        frameToConvert = [frameValue CGRectValue];
    } else {
        frameToConvert = currentView.frame;
    }
#pragma clang diagnostic pop
    
    // If the view in question is located in a superview, convert the CGRect so it is expressed in
    // the coordinates of our controller its main view.
    retval = [currentView.superview convertRect:frameToConvert toView:nil];
    
    return retval;
}

// Step forward or backward in tutorial
- (void)stepInTutorial:(int)step withAnimation:(BOOL)animated
{
    DLog(@"entry");
    
    if(step > 0) {
        // Step forward
        if((currentStep + 1) >= [self.tutorialViews count]) {
            // We've come at the end
            DLog(@"End of tutorial");
            [self cleanUp];
            return;
        }
    } else {
        // Step backward if possible
        if((currentStep + step) < 0) {
            DLog(@"Already at first page");
            return;
        }
    }
    
    currentStep += step;
    self.pageControlTop.currentPage = currentStep;
    self.pageControlBottom.currentPage = currentStep;
    
    UIView *currentView = self.tutorialViews[currentStep];
    DLog(@"currentView.frame=%@", NSStringFromCGRect(currentView.frame));
    if(currentView.frame.origin.y < (self.bounds.size.height/2.0)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.pageControlTop.alpha = 0;
            self.pageControlBottom.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.pageControlTop.alpha = 1;
            self.pageControlBottom.alpha = 0;
        }];
    }
    
    UILabel *tutorialLabel = self.tutorialLabels[currentStep];
    [UIView animateWithDuration:0.3 animations:^{
        tutorialLabel.alpha = 1;
    }];
    
    CGRect frame = [self frameForCurrentView];
    DLog(@"currentView.frame=%@", NSStringFromCGRect(frame));

    if(animated) {
        UILabel *previousTutorialLabel = self.tutorialLabels[currentStep-step];
        [UIView animateWithDuration:0.3 animations:^{
            previousTutorialLabel.alpha = 0;
        }];

        [self animateCutAtRectToRect:frame];
    } else {
        // Don't animate transition -- this happens when we get called from the start method
        [self setCutAtRect:frame];
    }
}

// For this piece of code you should check
// https://github.com/modocache/MDCFocusView
- (void)animateCutAtRectToRect:(CGRect)rect
{
    DLog(@"entry");

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    if(CGRectIsEmpty(rect)) {
        DLog(@"No frame to expose in this step");
    } else {
        UIBezierPath *cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
        [maskPath appendPath:cutoutPath];
    }
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.delegate = self;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.duration = 1.0;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.fromValue = (__bridge id)(self.mask.path);
    anim.toValue = (__bridge id)(maskPath.CGPath);
    [self.mask addAnimation:anim forKey:@"path"];
    self.mask.path = maskPath.CGPath;
}

- (void)setCutAtRect:(CGRect)rect
{
    DLog(@"entry");
    
    // Define shape
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    if(CGRectIsEmpty(rect)) {
        DLog(@"No frame to expose in this step");
    } else {
        UIBezierPath *cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
        [maskPath appendPath:cutoutPath];
    }
    
    // Set the new path
    self.mask.path = maskPath.CGPath;
}

- (void)dealloc
{
    DLog(@"entry");
}

@end