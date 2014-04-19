//
//  BITGalleryViewController.m
//  Bitraf
//
//  Created by Alexander Alemayhu on 19.04.14.
//  Copyright (c) 2014 Bitraf. All rights reserved.
//

#import "BITGalleryViewController.h"

@interface BITGalleryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation BITGalleryViewController

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
    
    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GALLERY_URL]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
}

@end
