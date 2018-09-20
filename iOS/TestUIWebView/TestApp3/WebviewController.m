//
//  WebviewController.m
//  TestApp3
//
//  Created by jeffrey on 26/3/15.
//  Copyright (c) 2015 jeffrey. All rights reserved.
//

#import "WebviewController.h"

@interface WebviewController ()

@end

@implementation WebviewController

UIWebView *webView;
UIImageView *imageView;

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidDisappear");
    
    // make sure to remove a key-value observer!!
    [self removeJavaScriptObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    
    //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    //Set the delegate
    webView.delegate = self;
    
    //Set the webview as invisible
    //webView.hidden = YES;
    webView.hidden = NO;
    
    //Set the webview to auto-resize with its parent view
    self.view.autoresizesSubviews = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //webView.opaque = NO;
    // set background color
    //webView.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 \
    green:((float)((0x000000 & 0x00FF00) >>  8))/255.0 \
    blue:((float)((0x000000 & 0x0000FF) >>  0))/255.0 \
    alpha:1.0];
    //webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
    
    webView.frame = self.view.bounds;
    
    UIImage *image = [UIImage imageNamed:@"Default"];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [[UIScreen mainScreen] bounds];
    //imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.hidden = NO;
    
    webView.hidden = YES;
    
    //Add to the UI
    [self.view addSubview:webView];
    [self.view addSubview:imageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    // get localized path for file from app bundle
    NSString *path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource:@"test_css" ofType:@"html"];
    
    [webView loadHTMLString:@"<html>TEST</html>" baseURL:nil];
    
    // make a file: URL out of the path
    //    NSURL *theUrl = [NSURL fileURLWithPath:path];
    //    [webView loadRequest:[NSURLRequest requestWithURL:theUrl]];
    
    // need to do this every time this view appears so that the "home" link keeps working
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com.hk"]]];
    
    // Move Payment Gateway
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.mpaymall.com/MPayMobi/MerchantPay.jsp"]]];
    // Move Webcart
    //    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.hkonlinemall.com/hkonlinemall-web/manulife/index.jsp?language=en&devicetype=ios&rewardid=2&promoclass=4&macauind=N&ownername=Tai%20Man%20Chan&deliverymethod=C&promocode=SYJ6BPJW4V"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// webview delegate methods support
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"scheme = %@",[[request URL] scheme]);
    
    // intercept the webview URL
    NSURL *reqURL = [request URL];
    NSString *urlString = [reqURL absoluteString];
    
    NSLog(@"WebView:ShouldStartLoadWithRequest with url: %@", urlString);
    NSLog(@"URL scheme: %@",[reqURL scheme]);
    NSLog(@"URL host: %@",[reqURL host]);
    NSLog(@"NavigationType: %li",(long)navigationType);
    
    if ([[reqURL scheme] isEqualToString:@"manulifemove"]) {
        [webView stringByEvaluatingJavaScriptFromString:@"moveCallback()"];
        return NO;
    }
    
    return YES;
}

// webview delegate methods support
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webviewDidStartLoad");
}

// webview delegate methods support
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    imageView.hidden = YES;
    webView.hidden = NO;
}

// webview delegate methods support
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView didFailLoadWithError");
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}

// IBAction
- (IBAction)btnClicked:(id)sender
{
    NSLog(@"sender: %@", sender);
    
    // Make sure it's a UIButton
    if ([sender isKindOfClass:[UIButton class]]) {
        NSString *title = [(UIButton *)sender currentTitle];
        NSLog(@"title: %@", title);
        long tag = [sender tag];
        NSLog(@"Button Tag is : %ld", tag);
        
        NSString *jsCall = [NSString stringWithFormat: @"btnClickedWithTag(%ld)", tag];
        [webView stringByEvaluatingJavaScriptFromString:jsCall];
    }
}

- (void) disableBtnByTag:(NSNumber *)tag
{
    id sender = [self.view viewWithTag:tag.intValue];
    NSLog(@"sender: %@", sender);
    
    // Make sure it's a UIButton
    if ([sender isKindOfClass:[UIButton class]]) {
        NSLog(@"disabling UI button...");
        
        // cast to UIButton
        //        UIButton *theBtn = (UIButton *)[self.view viewWithTag:tag.intValue];
        //        theBtn.enabled = NO;
        //        theBtn.hidden = YES;
        
        // Does not require direct referecning of UIButton's instance !!
        [sender setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];
    }
}

//=== Key-Value-Observing ===//
- (void) createJavaScriptObserver
{
    NSLog(@"createJavaScriptObserver");
    
    //id sender = [self.view viewWithTag:1];
    id sender = [self.view viewWithTag:2];
    
    // Register the WebViewController as the observer to be notified for changes, the KeyPath must be KVC-Compliant
    //[sender addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [sender addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void) removeJavaScriptObserver
{
    NSLog(@"removeJavaScriptObserver");
    //id sender = [self.view viewWithTag:1];
    id sender = [self.view viewWithTag:2];
    
    //[sender removeObserver:self forKeyPath:@"hidden"];
    [sender removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"observeValueForKeyPath: %@", keyPath);
    // custom implementation
    // be sure to call the superclass' implementation
    // if the superclass implements it
    if ([keyPath isEqualToString: @"hidden"]) {
        long tag = [object tag];
        NSLog(@"Object Tag is : %ld", tag);
        
        NSString *jsCall = [NSString stringWithFormat: @"onTextFieldChanged(%ld)", tag];
        [webView stringByEvaluatingJavaScriptFromString:jsCall];
        
    } else if ([keyPath isEqualToString: @"text"]) {
        long tag = [object tag];
        NSLog(@"Object Tag is : %ld", tag);
        
        NSString *jsCall = [NSString stringWithFormat: @"onTextFieldChanged(%ld)", tag];
        [webView stringByEvaluatingJavaScriptFromString:jsCall];
        
    } else {
        /*
         Be sure to call the superclass's implementation *if it implements it*.
         NSObject does not implement the method.
         */
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}
// === End of Key-Value-Observer ===//

@end


