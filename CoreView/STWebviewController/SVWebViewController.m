//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewControllerActivityChrome.h"
#import "SVWebViewControllerActivitySafari.h"
#import "SVWebViewController.h"

#import "NJKWebViewProgress.h"
#import "MyURLCache.h"

#import "STTools.h"
#import "NSEtcHosts.h"

#define DEBUGMODE 1
#if DEBUGMODE
#define SVWLog(xx, ...) NSLog(xx, ##__VA_ARGS__)
#else
#define SVWLog(xx, ...) ((void)0)
#endif


#define MOVEDISTANCE 99                 // 左侧一开始的距离
#define VIEWALPHA 0.8                   // 初始化alpha数值
#define VIEWCOLOR [UIColor blackColor]  // 遮罩的颜色

#define PROGRESSHEIGHT 3                // 设置初始进度条高度
#define PROGRESSORIGNH 64               // 进度条位置高度

typedef NS_ENUM(NSInteger, ViewType) {
    ShadowImgView  = 2,
    BlackAlphaView = 3,
};

@interface SVWebViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;

/// status
@property (nonatomic, assign) BOOL notNeedScreenShot;

/// screen shots
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIImage *backScreenshotsImg;
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end


@implementation SVWebViewController

#pragma mark - Initialization

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;
    self.delegate = nil;
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifeCycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.webView];
    [self loadRequest:self.request];
    
    /// add SomeThing
    self.imgArray = @[].mutableCopy;
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(methodPanGesture:)];
    pangesture.delegate = self;
    [self.view addGestureRecognizer:pangesture];
    
    /// set proxy and progresssView
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressView.frame = CGRectMake(0, PROGRESSORIGNH-20, self.view.frame.size.width, PROGRESSHEIGHT);
    
    /// set url cache
    MyURLCache *shareCache = [[MyURLCache alloc] initWithMemoryCapacity:1024*1024 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:shareCache];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
    _backBarButtonItem = nil;
    _forwardBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _stopBarButtonItem = nil;
    _actionBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    
    /// add progress
    [self.navigationController.navigationBar addSubview:self.progressProxy.progressView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    
    /// add progress
    [self.progressProxy.progressView removeFromSuperview];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Button Getters

- (UIWebView*)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.scalesPageToFit = YES;
        _webView.scrollView.alwaysBounceHorizontal = NO;
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerBack"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(goBackTapped:)];
        _backBarButtonItem.width = 18.0f;
        _backBarButtonItem.tintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1.0];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerNext"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goForwardTapped:)];
        _forwardBarButtonItem.width = 18.0f;
        _forwardBarButtonItem.tintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1.0];
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
        _refreshBarButtonItem.tintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1.0];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
        _stopBarButtonItem.tintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1.0];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
        _actionBarButtonItem.tintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1.0];
    }
    return _actionBarButtonItem;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250.0f;
        fixedSpace.width = 35.0f;
        
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem,
                          nil];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    
    else {
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace,
                          nil];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (![self.webView canGoBack]) {
        SVWLog(@"start load webview...");
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (![self.webView isLoading]) {
        SVWLog(@"finish load webview...");
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.navigationItem.title == nil) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
    
    if (self.progressProxy.isFinishLoad) {
        self.notNeedScreenShot = NO;
    }

    
    /// remove banner or other operate
    [self removeBanner:webView];
    [self performSelector:@selector(removeBanner:) withObject:webView afterDelay:0.5];
    [self performSelector:@selector(removeBanner:) withObject:webView afterDelay:1.5];
}

/// 去除广告 (这里还可以做一些模拟点击等操作)
- (void)removeBanner:(UIWebView*)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"(function() { var taobaoLogo = document.getElementsByClassName(\"new-header new-header-append\");var len = taobaoLogo.length;for(var i = 0; i < len; i++) {taobaoLogo[i].parentNode.removeChild(taobaoLogo[i]);}}())"];
    [webView stringByEvaluatingJavaScriptFromString:@"(function() { var taobaoLogo = document.getElementById(\"down_app_header\"); if(taobaoLogo)taobaoLogo.parentNode.removeChild(taobaoLogo);}())"];
    [webView stringByEvaluatingJavaScriptFromString:@"(function() { var taobaoLogo = document.getElementById(\"down_app\"); if(taobaoLogo)taobaoLogo.parentNode.removeChild(taobaoLogo);}())"];
    [webView stringByEvaluatingJavaScriptFromString:@"(function() { var taobaoLogo = document.getElementById(\"down_app_header\"); if(taobaoLogo)taobaoLogo.parentNode.removeChild(taobaoLogo);}())"];
    [webView stringByEvaluatingJavaScriptFromString:@"(function() { var taobaoLogo = document.getElementById(\"m_common_tip\"); if(taobaoLogo)taobaoLogo.parentNode.removeChild(taobaoLogo);}())"];
    [webView stringByEvaluatingJavaScriptFromString:@"(function() { var taobaoLogo = document.getElementById(\"m_common_header\"); if(taobaoLogo)taobaoLogo.parentNode.removeChild(taobaoLogo);}())"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"(function() { var taobaoLogo = document.getElementsByClassName(\"new-header\");var len = taobaoLogo.length;for(var i = 0; i < len; i++) {taobaoLogo[i].parentNode.removeChild(taobaoLogo[i]);}}())"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    /// 内网翻墙专用的设置
    BOOL headerIsPresent = [[request allHTTPHeaderFields] objectForKey:@"Host"]!=nil;
    if(!headerIsPresent) {
        __block NSMutableURLRequest *my_request = (NSMutableURLRequest*)request;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *host = request.URL.host;
                NSDictionary *hostTable = [NSEtcHosts hostTable];
                if (hostTable[host] == nil) {
                } else {
                    [my_request addValue:hostTable[host] forHTTPHeaderField:@"Host"];
                    // reload the request
                    [self loadRequest:my_request];
                }
            });
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    if (!self.progressProxy.isFinishLoad && !self.notNeedScreenShot && navigationType != UIWebViewNavigationTypeBackForward) {
        /// add image
        UIImage *webScreenshotsImg = [STTools getScreenshot];
        [self.imgArray addObject:webScreenshotsImg];
        self.notNeedScreenShot = YES;
    }
    
    return YES;
}

#pragma mark - Target actions

- (void)goBackTapped:(UIBarButtonItem *)sender {
    if ([self.webView canGoBack]) {
        [self.imgArray removeLastObject];
        [self.webView goBack];
    }
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
    
    /// add image
    UIImage *webScreenshotsImg = [STTools getScreenshot];
    [self.imgArray addObject:webScreenshotsImg];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (void)actionButtonTapped:(id)sender {
    NSURL *url = self.webView.request.URL ? self.webView.request.URL : self.request.URL;
    if (url != nil) {
        NSArray *activities = @[[SVWebViewControllerActivitySafari new], [SVWebViewControllerActivityChrome new]];
        
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *dc = [UIDocumentInteractionController interactionControllerWithURL:url];
            [dc presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        } else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
#ifdef __IPHONE_8_0
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 &&
                UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIPopoverPresentationController *ctrl = activityController.popoverPresentationController;
                ctrl.sourceView = self.view;
                ctrl.barButtonItem = sender;
            }
#endif
            
            [self presentViewController:activityController animated:YES completion:nil];
        }
    }
}

- (void)doneButtonTapped:(id)sùender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma -mark set UIPangestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch locationInView:self.view].x > 40) {
        return NO;
    }
    
    if ([self.webView canGoBack]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        return YES;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    return NO;
}

- (void)methodPanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint offset = [pan translationInView:self.view];
    
    if (UIGestureRecognizerStateBegan == pan.state) {
        SVWLog(@"gesture start...");
        self.backScreenshotsImg = [STTools getScreenshot];
        [self setCustomShowView];
        if (self.webView.canGoBack) {
            _showView.hidden = NO;
        }
        
    } else if (UIGestureRecognizerStateChanged == pan.state) {
        if (offset.x > 0 && self.imgArray.count > 0 && self.webView.canGoBack) {
            [self setCurstomViewFrame:offset.x];
        }
        
    } else if (UIGestureRecognizerStateEnded == pan.state) {
        SVWLog(@"gesture ended...");
        if (offset.x > 44) {
            // 移除最后一张图片,实现后退🏄
            if (self.imgArray.count > 0) {
                [self.imgArray removeLastObject];
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                    [UIView animateWithDuration:0.2 animations:^{
                        [self setCurstomViewFrame:self.view.frame.size.width];
                    } completion:^(BOOL finished) {
                        self.webView.frame = self.view.frame;
                        _showView.hidden = YES;
                    }];
                    return;
                }
            }
            _showView.hidden = YES;
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                [self setCurstomViewFrame:0];
            } completion:^(BOOL finished) {
                _showView.hidden = YES;
            }];
        }
        /// 貌似也不需要前进功能
    }
    
}

#pragma -mark set ShowView

- (void)setCustomShowView {
    CGRect rect = [UIScreen mainScreen].bounds;
    _showView = [[UIView alloc] initWithFrame:CGRectOffset(rect, 0, 0)];
    
    /// leftView + blackView
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectOffset(rect, -MOVEDISTANCE, 0)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.imgArray.count > 0) {
        leftView.image = [self.imgArray lastObject];
    }
    leftView.tag = ShadowImgView;
    [_showView addSubview:leftView];
    
    UIView *blackView = [[UIView alloc] initWithFrame:rect];
    blackView.alpha = VIEWALPHA;
    blackView.backgroundColor = VIEWCOLOR;
    blackView.tag = BlackAlphaView;
    [_showView addSubview:blackView];
    
    _showView.layer.masksToBounds = YES;
    [self.view insertSubview:_showView belowSubview:self.webView];
}

- (void)setCurstomViewFrame:(CGFloat)x {
    if (x >= 0) {
        CGRect rect = [UIScreen mainScreen].bounds;
        CGRect left = CGRectOffset(rect, -MOVEDISTANCE, 0);
        UIView *leftView = [_showView viewWithTag:ShadowImgView];
        leftView.frame = CGRectOffset(left, (x/rect.size.width)*MOVEDISTANCE, 0);
        
        self.webView.frame = CGRectOffset(rect, x, 0);
        
        UIView *blackView = [_showView viewWithTag:BlackAlphaView];
        blackView.alpha = VIEWALPHA *(1 - x/leftView.frame.size.width);
    }
}


@end
