//
//  FLIPAppDelegate.h
//  DemoUnitTest
//
//  Created by dangthan on 9/16/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLIPViewController;
@class FLIPPage2ViewController;

@interface FLIPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) FLIPViewController *viewController;
@property (strong, nonatomic) FLIPPage2ViewController *viewController;

@end
