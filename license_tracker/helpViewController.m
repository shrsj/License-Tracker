//
//  helpViewController.m
//  license_tracker
//
//  Created by SJ GOA on 09/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import "helpViewController.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"

@interface helpViewController ()

@end

@implementation helpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*- (IBAction)help:(UIButton *)sender {
 
 //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"Http://www.facebook.com/sjinnovation/"]];
 
 [super viewDidLoad];
 NSString *fullURL = @"http://www.facebook.com/sjinnovation/";
 NSURL *url = [NSURL URLWithString:fullURL];
 NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
 [_viewWeb loadRequest:requestObj];
 }
 */
- (IBAction)webView:(UIButton *)sender {
    
    NSURL *URL = [NSURL URLWithString:@"http:www.facebook.com/sjinnovation/"];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:webViewController animated:YES completion:NULL];
    
}
@end
