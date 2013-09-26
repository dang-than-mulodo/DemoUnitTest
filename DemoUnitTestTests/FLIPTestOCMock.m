//
//  FLIPTestOCMock.m
//  DemoUnitTest
//
//  Created by dangthan on 9/18/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "FLIPTestOCMock.h"
#import "FLIPTestModel.h"
#import "FLIPPage2ViewController.h"


static NSString *NotificationNametest = @"NotificationString";

#pragma mark - Class helper

@interface TestClassWithClassMethods : NSObject
+ (NSString *)foo;
+ (NSString *)bar;
- (NSString *)bar;
@end

@implementation TestClassWithClassMethods

+ (NSString *)foo
{
    return @"Foo-ClassMethod";
}

+ (NSString *)bar
{
    return @"Bar-ClassMethod";
}

- (NSString *)bar
{
    return @"Bar";
}

@end


#pragma mark - Class helper 2


#pragma mark - Class helper 3

@protocol AuthenticationService <NSObject>

- (void) loginWithEmail:(NSString *)email andPassword:(NSString *)password;

@end

@interface Foo : NSObject {
    id<AuthenticationService> delegate;
}

- (id) initWithAuthenticationService:(id<AuthenticationService>) authenticate;
- (void) doStuff;

@end

@implementation Foo

- (id) initWithAuthenticationService:(id<AuthenticationService>)authenticate {
    self = [super init];
    if (self) {
        //exeption for delegate
        if (authenticate && ![authenticate conformsToProtocol:@protocol(AuthenticationService)]) {
            [NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delegate protocol" userInfo:nil];
        }
        delegate = authenticate;
    }
    return self;
}

- (void) doStuff {
    [delegate loginWithEmail:@"x" andPassword:@"y"];
}

@end

@implementation FLIPTestOCMock

- (void) setUp {
    if (!pageController) {
        pageController = [[FLIPPage2ViewController alloc] initWithNibName:@"FLIPPage2ViewController" bundle:nil];
    }
    [pageController setArrayTable:[NSArray arrayWithObjects:@"iPhone", @"Android", nil]];
    mock = [OCMockObject observerMock];
    notificationCenter = [[NSNotificationCenter alloc] init]; //ARC
    didCallContraints = NO;
}

- (void) tearDown {
    pageController = nil;
}

#pragma mark - OCMock: mock and verifycation

- (void) testOCMockWithTableViewCommitting {
    NSIndexPath *dummyIndexPath = [NSIndexPath indexPathWithIndex:3];
    id tableMock = [OCMockObject mockForClass:[UITableView class]];
    [[tableMock expect] deleteRowsAtIndexPaths:[NSArray arrayWithObject:dummyIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [pageController tableView:tableMock commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:dummyIndexPath];
    
    [tableMock verify];
}


- (void) ocmockTestNotification {
    
}


#pragma mark - Working with missing OCMock and OCUnit
- (void) testTableViewSetupCellCorrectly{
    id mockTable = [OCMockObject mockForClass:[UITableView class]];
    [[[mockTable expect] andReturn:nil] dequeueReusableCellWithIdentifier:@"test"];
    UITableViewCell *cell = [pageController tableView:mockTable cellForRowAtIndexPath:nil];
    
    STAssertNotNil(cell, @"Should have return a cell");
    STAssertEqualObjects(@"iPhone", cell.textLabel.text, @"The value of label should be the same name as I gave");
    
    [mockTable verify];
    
}

#pragma mark - OCMock Stubs

- (void) testOcmockWithArrayLoop {
    mock = [OCMockObject mockForClass:[NSArray class]];
    [[mock stub] indexOfObjectPassingTest:[OCMArg any]];
    [mock indexOfObjectPassingTest:^(id object, NSUInteger idx, BOOL *stop){
        return YES;
    }];
}

#pragma mark - OCMock class method
- (void)testStubsClassMethodWhenNoInstanceMethodExistsWithName
{
    mock = [OCMockObject mockForClass:[TestClassWithClassMethods class]];
    
    [[[mock stub] andReturn:@"mocked"] foo];
    
    STAssertEqualObjects(@"mocked", [TestClassWithClassMethods foo], @"Should have stubbed class method.");
}


#pragma mark - Argument constraints

- (void)testRaisesExceptionOnUnknownSelector
{
	STAssertThrows(CONSTRAINTV(@selector(checkArgXXX:), @"bar"), @"Should have thrown for unknown constraint method.");
}

#if NS_BLOCKS_AVAILABLE
-(void)testUsesBlock {
	BOOL (^checkForFooBlock)(id) = ^(id value)
    {
        return [value isEqualToString:@"foo"];
    };
	
	OCMBlockConstraint *constraint = [[OCMBlockConstraint alloc] initWithConstraintBlock:checkForFooBlock];
    
	STAssertTrue([constraint evaluate:@"foo"], @"Should have accepted foo.");
	STAssertFalse([constraint evaluate:@"bar"], @"Should not have accepted bar.");
}

-(void)testBlockConstraintCanCaptureArgument {
	__block NSString *captured;
	BOOL (^captureArgBlock)(id) = ^(id value)
    {
        captured = value;
        return YES;
    };
	
	OCMBlockConstraint *constraint = [[OCMBlockConstraint alloc] initWithConstraintBlock:captureArgBlock];
    
	[constraint evaluate:@"foo"];
	STAssertEqualObjects(@"foo", captured, @"Should have captured value from last invocation.");
	[constraint evaluate:@"bar"];
	STAssertEqualObjects(@"bar", captured, @"Should have captured value from last invocation.");
}

#endif

#pragma mark - Nice mocks / failing fast
- (void)testReturnsDefaultValueWhenUnknownMethodIsCalledOnNiceClassMock
{
	mock = [OCMockObject niceMockForClass:[NSString class]];
	STAssertNil([mock lowercaseString], @"Should return nil on unexpected method call (for nice mock).");
	[mock verify];
}


#pragma mark - Ptorocol mocks

- (void) testWithConformProtocolOnOCMock {
    id delegateOCMock = [OCMockObject mockForProtocol:@protocol(AuthenticationService)];
    id foo = [[Foo alloc] initWithAuthenticationService:delegateOCMock];
    [[delegateOCMock expect] loginWithEmail:[OCMArg any] andPassword:[OCMArg any]];
    [foo doStuff];
    
    [delegateOCMock verify];
}

#pragma mark - Partial mocks
//- (void)testForwardsUnstubbedMethodsCallsToRealObjectOnPartialMock
//{
//	TestClassWithClassMethods *object = [[TestClassWithClassMethods alloc] init];
//	mock = [OCMockObject partialMockForObject:object];
//
//    STAssertEqualObjects(@"Bar", [mock bar], @"Should have returned value from real object.");
//}

#pragma mark - Observer mocks

- (void) testExceptionExpectedNotification {
    [notificationCenter addMockObserver:mock name:NotificationNametest object:nil];
    [[mock expect] notificationWithName:NotificationNametest object:[OCMArg any]];
    
    [notificationCenter postNotificationName:NotificationNametest object:self];
    
    [mock verify];
}

- (void)testRaisesOnVerifyWhenExpectedNotificationIsNotSent
{
	[notificationCenter addMockObserver:mock name:NotificationNametest object:nil];
    [[mock expect] notificationWithName:NotificationNametest object:[OCMArg any]];
    
	STAssertThrows([mock verify], nil);
}

#pragma mark - Instance-base mocks

@end



