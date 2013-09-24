//
//  FLIPTestOCMock.h
//  DemoUnitTest
//
//  Created by dangthan on 9/18/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

@class FLIPPage2ViewController;

@interface FLIPTestOCMock : SenTestCase {
    FLIPPage2ViewController *pageController;
    NSNotificationCenter *notificationCenter;
    id mock;
    BOOL didCallContraints;
}

@end
