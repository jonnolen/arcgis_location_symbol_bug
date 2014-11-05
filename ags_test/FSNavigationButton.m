
#import "FSNavigationButton.h"

const NSInteger kFSNavigationButtonValidStateMask = 0x00070000;


@implementation FSNavigationButton

- (instancetype)init{
    self = [super init];
    [self setupImages];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setupImages];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setupImages];
    return self;
}

- (void)setupImages{
    _navigationState = FSNavigationButtonStateOff;
    [self setTitle:@"Turn location on" forState:(UIControlState)FSNavigationButtonStateOff];
    [self setTitle:@"Turn location on" forState:(UIControlState)FSNavigationButtonStateOff | UIControlStateHighlighted];
    [self setTitle:@"Turn compass on" forState:(UIControlState)FSNavigationButtonStateOn];
    [self setTitle:@"Turn compass on" forState:(UIControlState)FSNavigationButtonStateOn | UIControlStateHighlighted];
    [self setTitle:@"Turn location off" forState:(UIControlState)FSNavigationButtonStateDirection];
    [self setTitle:@"Turn location off" forState:(UIControlState)FSNavigationButtonStateDirection | UIControlStateHighlighted];
}

- (void)setNavigationState:(FSNavigationButtonState)navigationState{
    [self willChangeValueForKey:@"state"];
    _navigationState = navigationState;
    [self setNeedsLayout];
    [self didChangeValueForKey:@"state"];
}

- (UIControlState)state {
    return [super state] | self.navigationState;
}

- (FSNavigationButtonState)nextState{
    return self.shiftedState & kFSNavigationButtonValidStateMask ? self.shiftedState : FSNavigationButtonStateOff;
}

- (NSInteger)shiftedState{
    return self.navigationState << 1;
}

@end
