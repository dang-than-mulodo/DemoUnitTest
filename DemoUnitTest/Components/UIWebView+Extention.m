//
//  FLIPWebViewExtention.m
//  DemoUnitTest
//
//  Created by dangthan on 9/19/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "UIWebView+Extention.h"

@implementation UIWebView (Extention)

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

- (CGSize) windowSize {
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
 
    return size;
}

- (CGPoint) scrollOffset {
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    
    return pt;
}

@end
