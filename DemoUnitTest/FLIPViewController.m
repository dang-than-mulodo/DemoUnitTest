//
//  FLIPViewController.m
//  DemoUnitTest
//
//  Created by dangthan on 9/16/13.
//  Copyright (c) 2013 Mulodo Inc. All rights reserved.
//

#import "FLIPViewController.h"
#import "UIWebView+Extention.h"


@interface FLIPViewController ()

@end

@implementation FLIPViewController
@synthesize webVIew, dataObject;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self conformADelegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [webVIew loadHTMLString:dataObject baseURL:[NSURL URLWithString:@""]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PageController Delegate
- (void) setDelegate:(id<FLIPViewDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol:@protocol(FLIPViewDelegate)]) {
        [NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not coform to the delegate protocol" userInfo:nil];
    }
    delegate = newDelegate;
}

- (void) conformADelegate {
    if (delegate && [delegate respondsToSelector:@selector(testADelegate)]) {
        [delegate testADelegate];
    }
}

#pragma mark - UIWebView delegate
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}


#pragma mark - Notification handle
- (void) contextualMenuAction :(NSNotification *)notification {
    CGPoint pt;
    NSDictionary *coord = [notification object];
    pt.x = [[coord objectForKey:@"x"] floatValue];
    pt.y = [[coord objectForKey:@"y"] floatValue];
    
    //convert point from window to coordinate system
    pt = [webVIew convertPoint:pt fromView:nil];
    
    //convert point from view to HTML coordinate syste
    CGPoint offset = [webVIew scrollOffset];
    CGSize viewSize = [webVIew frame].size;
    CGSize windowSize = [webVIew windowSize];
    
    CGFloat f = windowSize.width / viewSize.width;
    pt.x = pt.x * f + offset.x;
    pt.y = pt.y * f + offset.y;
    
    [self openContextualMenuAt:pt];
}

- (void) openContextualMenuAt:(CGPoint) pt {
    //load javascript from bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webVIew stringByEvaluatingJavaScriptFromString:jsCode];
    
    //get tag at the touch location
    NSString *tags = [webVIew stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);", (NSInteger)pt.x, (NSInteger)pt.y]];
    
    //create actionsheet and populate it with button related to the tags
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"ContextMenu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    // If a link was touched, add link-related buttons
    if ([tags rangeOfString:@",A,"].location != NSNotFound) {
        [sheet addButtonWithTitle:@"Open Link"];
        [sheet addButtonWithTitle:@"Open Link in Tab"];
        [sheet addButtonWithTitle:@"Download Link"];
    }
    //if an image was touched
    if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
        [sheet addButtonWithTitle:@"Save Picture"];
    }
    
    // Add buttons which should be always available
    [sheet addButtonWithTitle:@"Save Page as Bookmark"];
    [sheet addButtonWithTitle:@"Open Page in Safari"];
    
    [sheet showInView:webVIew];
}

#pragma mark - Actionsheet delegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
            
        default:
            break;
    }
}

@end
