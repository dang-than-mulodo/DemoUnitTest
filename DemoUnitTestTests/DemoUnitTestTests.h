//
//  DemoUnitTestTests.h
//  DemoUnitTestTests
//
//  Created by dangthan on 9/16/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FLIPViewDelegate.h"

@class FLIPPage2ViewController;
@class FLIPViewController;
@class FLIPDemoTableViewController;
@class FLIPTestModel;

@interface DemoUnitTestTests : SenTestCase {
    FLIPPage2ViewController *pageController;
    FLIPViewController  *flipController;
    FLIPDemoTableViewController *flipTable;
    FLIPTestModel *testModel;
    UITableView *tableView;
    NSNotification *receiveNotification;
    UINavigationController *navigationControler;
}

@end
