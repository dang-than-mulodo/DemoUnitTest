//
//  FLIPDemoTableViewController.m
//  DemoUnitTest
//
//  Created by dangthan on 9/17/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "FLIPDemoTableViewController.h"

@implementation FLIPDemoTableViewController
@synthesize arr;


- (void) initWithArrayObjects:(NSArray *)array {
    NSArray *tmpArr = nil;
    if (array || [array count]) {
        tmpArr = array;
    } else {
        tmpArr = [[NSArray alloc] init];
    }
    arr = tmpArr;
}

#pragma mark - table datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

#pragma mark - table delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //do something here
}



@end
