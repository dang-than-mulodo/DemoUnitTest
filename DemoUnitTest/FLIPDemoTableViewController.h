//
//  FLIPDemoTableViewController.h
//  DemoUnitTest
//
//  Created by dangthan on 9/17/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLIPDemoTableViewController : NSObject <UITableViewDelegate, UITableViewDataSource> {
    NSArray *arr;
}

@property (nonatomic, strong) NSArray *arr;

- (void) initWithArrayObjects:(NSArray *) array;

@end
