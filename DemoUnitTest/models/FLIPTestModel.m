//
//  FLIPTestModel.m
//  DemoUnitTest
//
//  Created by dangthan on 9/17/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "FLIPTestModel.h"

@implementation FLIPTestModel
@synthesize username, email, arrInfo;

- (id) init {
    self = [super init];
    if (self) {
        username = @"than";
        email = @"dang.than@mulodo.com";
        arrInfo = [[NSArray alloc] init];
        
    }
    return self;
}


- (void) addObjectToArray:(NSArray *)aObject {
    if (aObject && [aObject count] > 0) {
        arrInfo = [NSArray arrayWithArray:aObject];
    }
}

@end
