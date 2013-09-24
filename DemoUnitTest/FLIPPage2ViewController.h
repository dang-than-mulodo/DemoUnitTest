//
//  FLIPPage2ViewController.h
//  DemoUnitTest
//
//  Created by dangthan on 9/16/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLIPViewController.h"


@interface FLIPPage2ViewController : UIViewController <UIPageViewControllerDataSource, UITableViewDelegate, UITableViewDataSource, FLIPViewDelegate>{
    UIPageViewController *pageController;
    NSArray *pageContent;
}
@property (weak, nonatomic) IBOutlet UITableView *tableFlip;

@property (strong, nonatomic) NSArray *arrayTable;

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;

@end
