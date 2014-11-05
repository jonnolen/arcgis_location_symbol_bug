
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, FSNavigationButtonState) {
    FSNavigationButtonStateOff          =  (1 << 16),
    FSNavigationButtonStateOn           =  (1 << 17),
    FSNavigationButtonStateDirection    =  (1 << 18)
};


@interface FSNavigationButton : UIButton

@property (nonatomic, assign) FSNavigationButtonState navigationState;

- (FSNavigationButtonState)nextState;

@end
