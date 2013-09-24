//
//  FLIPViewController.h
//  DemoUnitTest
//
//  Created by dangthan on 9/16/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLIPViewDelegate.h"
#import "UIWebView+Extention.h"

@interface FLIPViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIWebView *webVIew;
@property (retain, nonatomic) id dataObject;

@property (assign, nonatomic) id<FLIPViewDelegate> delegate;

@end
