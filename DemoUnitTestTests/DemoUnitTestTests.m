//
//  DemoUnitTestTests.m
//  DemoUnitTestTests
//
//  Created by dangthan on 9/16/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "DemoUnitTestTests.h"
#import "FLIPPage2ViewController.h"
#import "FLIPViewController.h"
#import "FLIPDemoTableViewController.h"
#import "FLIPTestModel.h"
#import <objc/runtime.h>
#import <OCMock/OCMock.h>
#import "FLIPDetailViewController.h"



@implementation DemoUnitTestTests




- (void)setUp
{
    [super setUp];
    // Set-up code here.
    
    /*** Notes
     Invoke when first load (Unit test should be started)
     So, we need to create an instance of any object or item as global
     ****/
    
    if (!pageController) {
        pageController = [[FLIPPage2ViewController alloc] initWithNibName:@"FLIPPage2ViewController" bundle:nil];
    }
    
    tableView = [[UITableView alloc] init];
    pageController.tableFlip = tableView;
    
    [pageController setArrayTable:[NSArray arrayWithObjects:@"iPhone", @"Android", nil]];
    
    //add observer from notification in pageController
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:TEST_NOTIFICATION object:nil];
    navigationControler = [[UINavigationController alloc] initWithRootViewController:pageController];
    
    if (!flipController) {
        flipController = [[FLIPViewController alloc] initWithNibName:@"FLIPViewController" bundle:nil];
    }
    

    if (!flipTable) {
        flipTable = [[FLIPDemoTableViewController alloc] init];
    }
    if (!testModel) {
        testModel = [[FLIPTestModel alloc] init];
    }
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    /*** Notes
     invoke when unit test should be finished. The memory need to be free
     So, we need to release any object has retain count > 0. Maybe check retain count first before release
     If we use ARC, don't need to release object. It auto by compiler
     In this case (ARC), If you use Notification, you must be remove observer
    ****/
    tableView = nil;
    pageController = nil;
    flipTable = nil;
    testModel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super tearDown];
}

- (void)testExample
{
//    Always fail
//    STFail(@"Unit tests are not implemented yet in DemoUnitTestTests");
}



#pragma mark - Model Test
/****
 To test model in here
 *****/

- (void) testNibnameCorrect {
    STAssertEqualObjects(pageController.nibName, @"FLIPPage2ViewController", @"The nib name should be the name I gave it");
    STAssertEqualObjects(flipController.nibName, @"FLIPViewController", @"The nib name should be the name I gave it");
}

- (void) testWithPropertiesAreWorked {
    [pageController setPageContent:[NSArray arrayWithObjects:@"a", @"b", nil]];
    STAssertEqualObjects([pageController.pageContent objectAtIndex:0], @"a", @"first object of array should be a value as I gave");
}

- (void) testTypeClass {

    STAssertTrue([testModel.username isKindOfClass:[NSString class]], @"username should be a string");
    STAssertTrue([testModel.arrInfo isKindOfClass:[NSArray class]], @"array info should be an array");
}

- (void) testForArrayEmpty {
    STAssertEquals([testModel.arrInfo count], (NSUInteger)0, @"Array should be have no item first");
}

- (void) testForArrayHasItem {
    NSArray *tmpArr = [NSArray arrayWithObjects:@"x", @"y", nil];
    [testModel addObjectToArray:tmpArr];
    STAssertEquals([testModel.arrInfo count], (NSUInteger)2, @"Array should add new two items");
}



#pragma mark - View Controller Test
/****
 To test integrate with controller and also view in here
 I using tableview datasoure in here 
 ****/

- (void) testExistObject {
    STAssertNotNil(pageController, @"should be able to create a Page instance");
    STAssertNotNil(flipController, @"should be able to create web view");
}


- (void) testTableWithTwoRowsContent {
    NSArray *tmpArr = [NSArray arrayWithObjects:@"a", @"b", nil];
//    pageController.arrayTable = tmpArr;
    STAssertEquals((NSInteger)[tmpArr count], [pageController tableView:nil numberOfRowsInSection:0], @"Tableview data source should have two items in list");
}

- (void) testOneSecsionInTableView {
    STAssertThrows([pageController tableView: nil numberOfRowsInSection: 1], @"Data source doesn't allow asking about additional sections");
}

- (void) testDataSourceCellCreated {
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow:0 inSection:1];
    STAssertThrows([pageController tableView:nil cellForRowAtIndexPath:secondSection], @"Data source will not be prepare to show");
}


- (void) testContentOfTableViewCell {
    NSIndexPath *firstItem = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [pageController tableView:nil cellForRowAtIndexPath:firstItem];
    NSString *cellTitle = cell.textLabel.text;
    STAssertEqualObjects(@"iPhone", cellTitle, @"title should be name that I gave"); // => true
//    STAssertEquals(@"iPhone", cellTitle, @"title should be name that I gave"); // => false
}
/***
 Test delegate
 ***/
- (void) testNonConfirmingObjectCannotBeDelegate {
//    STAssertThrows(flipController.delegate =(id <FLIPViewDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't" @" conform to the delegate protocol");
    STAssertTrue([pageController conformsToProtocol:@protocol(FLIPViewDelegate)], @"pageController should conform to protocol FLIPViewDelegate");
}

- (void) testDelegateAcceptedWithNilValue {
    STAssertNoThrow(flipController.delegate = nil, @"Delegate should allowed to nil");
}

- (void) testConformingPagemanagerDelegate {
    STAssertTrue([pageController conformsToProtocol:@protocol(UIPageViewControllerDataSource)], @"Page controller should conform to protocol PageViewControllerDatasource delegate");
}

- (void) testControllerConnectToDataSourseInViewDidLoad {
    id<UITableViewDataSource> dataSource;
    pageController.tableFlip.dataSource = dataSource;
    [pageController viewDidLoad];
    STAssertEqualObjects([tableView dataSource], dataSource, @"View controller should have set table view's datasource");
}

- (void) testControllerConnectToDataSourceInViewDidLoad {
    id<UITableViewDelegate> delegate;
    pageController.tableFlip.delegate = delegate;
    [pageController viewDidLoad];
    STAssertEqualObjects([tableView delegate], delegate, @"Table view should have set the table view's delegate");
}

/***
 Test properties exist
 ***/
- (void)testProtetyexist {
    objc_objectptr_t arrayTableProperty = class_getProperty([pageController class], "arrayTable"); //must match with property name
    objc_objectptr_t tableProperty = class_getProperty([pageController class], "tableFlip");
    
    STAssertTrue(arrayTableProperty != NULL, @"Page Controller should have arraytable property");
    STAssertTrue(tableProperty != NULL, @"page controller should have table property");
}

/*
 * Test Notification
 * We post a notificaiton fisrt in some case
 * In test class we add an observer for this notification in setup, handle in here or somewhere and test in here
 * Remember to remove observer in dealloc and tearDown when we stop using notification also you using ARC
 */
- (void) didReceiveNotification:(NSNotification *)notification {
    receiveNotification = notification;
}
- (void) testNotificationCenterWithTableViewItemDidSelected {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [pageController tableView:nil didSelectRowAtIndexPath:indexPath];
    STAssertEqualObjects([receiveNotification name], TEST_NOTIFICATION, @"The notification name should be the name that I gave");
    STAssertEqualObjects([receiveNotification object], @"iPhone", @"The notification object return should be name that I gave");
}

/*
 * Test Navigation Controller
 * Test Navigation controller push a viewcontroller to stack
 */
- (void) testNavigationController {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [pageController tableView:nil didSelectRowAtIndexPath:indexPath];
    UIViewController *currentTopVC = navigationControler.topViewController;
    STAssertFalse([currentTopVC isEqual:pageController], @"New view controller should be push into the stack");
    STAssertTrue([currentTopVC isKindOfClass:[FLIPDetailViewController class]], @"new View controller should be a detail");
}

@end
