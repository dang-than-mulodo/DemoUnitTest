//
//  FLIPPage2ViewController.m
//  DemoUnitTest
//
//  Created by dangthan on 9/16/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "FLIPPage2ViewController.h"
#import "constants.h"
#import "FLIPDetailViewController.h"

@interface FLIPPage2ViewController ()

@end

@implementation FLIPPage2ViewController
@synthesize pageController, pageContent;
@synthesize arrayTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createContentPages];
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
    FLIPViewController *initialViewController = [self viewcontrollerAtIndex:0];
    [initialViewController setDelegate:self];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
    
    [self.tableFlip setDelegate:self];
    [self.tableFlip setDataSource:self];
    
    arrayTable = [[NSArray alloc] initWithObjects:@"iPhone", @"Android", nil];
}

- (void) viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    UIMenuItem *menu1 = [[UIMenuItem alloc] initWithTitle:@"copy" action:@selector(action1)];
//    UIMenuItem *menu2 = [[UIMenuItem alloc] initWithTitle:@"cut" action:@selector(action2)];
//    
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menu1, menu2, nil]];
    
/*
 * To test notification center
 * We need to post a notification first. But for testing, we will post it in test file.
 * In here, we only add and handle
 */

    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(funcNotifiImplement) name: TEST_NOTIFICATION object:nil];

}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) funcNotifiImplement {
    NSLog(@"notification center handle");
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void) action1 {
    NSLog(@"action 1");
    
}

- (void) action2 {
    NSLog(@"action 2");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createContentPages {
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < 11; i++) {
        NSString *contentString = [[NSString alloc] initWithFormat:@"<html><head></head><body><h1>Chapter %d</h1><p>This is the page %d of content displayed using UIPageViewController in iOS 5.</p></body></html>", i, i];
        [pageStrings addObject:contentString];
    }
    pageContent  = [[NSArray alloc] initWithArray:pageStrings];
}

- (FLIPViewController *) viewcontrollerAtIndex:(NSUInteger) index {
    if ([self.pageContent count] == 0 || index >= [self.pageContent count]) {
        return nil;
    }
    
    FLIPViewController *dataViewController = [[FLIPViewController alloc] initWithNibName:@"FLIPViewController" bundle:nil];
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
    return dataViewController;
}

- (NSUInteger) indexOfViewController:(FLIPViewController *) viewcontroller {
    return [self.pageContent indexOfObject:viewcontroller.dataObject];
}

#pragma mark - PageView controller delegate
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(FLIPViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self viewcontrollerAtIndex:index];
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(FLIPViewController *) viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewcontrollerAtIndex:index];
}



- (void)viewDidUnload {
    [self setTableFlip:nil];
    [super viewDidUnload];
}


#pragma mark - TableView Datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSParameterAssert(section == 0);
    return [arrayTable count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([indexPath row] < 10);
    static NSString *identifier = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [arrayTable objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - TableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:[arrayTable objectAtIndex:indexPath.row]];
    FLIPDetailViewController *detail = [[FLIPDetailViewController alloc] initWithNibName:@"FLIPDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //do something
    }
}

#pragma mark - FlipView delegate
- (void) testADelegate {
    
}

@end
