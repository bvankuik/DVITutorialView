/**
 * Add an inset to a label, see also:
 * http://stackoverflow.com/a/17557490/1085556
 * Thanks to Stack Overflow users Brody Robertson and progrmr
 */

#import <UIKit/UIKit.h>

@interface DVILabelWithInset : UILabel
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end
