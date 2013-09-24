//
//  FLIPMyWindow.m
//  DemoUnitTest
//
//  Created by dangthan on 9/18/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "FLIPMyWindow.h"

@implementation FLIPMyWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - tap handle
- (void) tapAndHoldAction:(NSTimer *)timer {
    contextualMenuTimer = nil;
    NSDictionary *coord = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tapLocation.x], @"x",
                           [NSNumber numberWithFloat:tapLocation.y], @"y", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TapAndHoldNotification" object:coord];
}

- (void) sendEvent:(UIEvent *)event {
    NSSet *touches = [event touchesForWindow:self];
//    [touches retain];
    [super sendEvent:event]; // Call super to make sure the event is processed as usual
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        switch (touch.phase) {
            case UITouchPhaseBegan:
                tapLocation = [touch locationInView:self];
                [contextualMenuTimer invalidate];
                contextualMenuTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(tapAndHoldAction:) userInfo:nil repeats:NO];
                break;
                
            case UITouchPhaseEnded:
            case UITouchPhaseMoved:
            case UITouchPhaseCancelled:
                [contextualMenuTimer invalidate];
                contextualMenuTimer = nil;
                break;
                
            default:
                break;
        }
    } else {
        [contextualMenuTimer invalidate];
        contextualMenuTimer = nil;
    }
//    [touches release]; //just for non-ARC

}

@end
