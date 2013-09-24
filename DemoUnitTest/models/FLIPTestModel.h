//
//  FLIPTestModel.h
//  DemoUnitTest
//
//  Created by dangthan on 9/17/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLIPTestModel : NSObject
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSArray *arrInfo;

- (void) addObjectToArray:(NSArray *) aObject;

@end
