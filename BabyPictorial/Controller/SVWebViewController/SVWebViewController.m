//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "WXApi.h"
#import "SFHFKeychainUtils.h"

#import "Reachability.h"

#import "UIImage+UIImageScale.h"
//#import "TabBarShareView.h"

/*
 *  新浪微博相关
 */
#define kWBURLSchemePrefix              @"WB_"
#define kWBKeychainServiceNameSuffix    @"_WeiBoServiceName"
#define kWBKeychainUserID               @"WeiBoUserID"
#define kWBKeychainAccessToken          @"WeiBoAccessToken"
#define kWBKeychainExpireTime           @"WeiBoExpireTime"
//#define kWBKeyAppKey                    @"2796878419"
//#define kWBKeyAppSecret                 @"a517807ec1b5a884f0f857e67132f8be"

/*
 * Todo: 请填写您需要的登录授权方式，目前支持webview和浏览器两种方式，分别为InWebView和InSafari，其中浏览器方式需要手动获取授权码，不建议使用
 */
#define oauthMode InWebView

/*
 * 获取oauth1.0票据的key
 */
#define oauth1TokenKey @"AccessToken"
#define oauth1SecretKey @"AccessTokenSecret"

/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expire_in="

@interface SVWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;

@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) UIImage *thumbImage;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

@end


@implementation SVWebViewController

@synthesize availableActions;

@synthesize URL, mainWebView , articleTitle , thumbImage;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, pageActionSheet;

@synthesize userID = _userID , accessToken = _accessToken, expireTime = _expireTime , weiBoEngine = _weiBoEngine;

//@synthesize mURLShortenInterface = _mURLShortenInterface , shortUrl = _shortUrl;

#pragma mark - 新浪微博
//微博前期准备工作
- (NSString *)urlSchemeString
{
    return [NSString stringWithFormat:@"%@%@", kWBURLSchemePrefix, kWBKeyAppKey];
}

-(void)readWeiBoAccessToken
{
    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
    self.userID = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
    
    self.accessToken = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
    self.expireTime = [[SFHFKeychainUtils getPasswordForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil] doubleValue];
    
}

-(void)share2SinaWeibo
{
    [self readWeiBoAccessToken];
    
    if (self.userID != nil && self.accessToken!=nil && self.expireTime>0.0) {
        
        NSString *string = [[NSString alloc]initWithFormat:@"#桃小仙# 这个怎么样？ %@" ,
//                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                            self.articleTitle];
//                            self.shortUrl];
        
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBKeyAppKey 
                                                        appSecret:kWBKeyAppSecret 
                                                             text:string 
                                                            image:self.thumbImage];
        [sendView setDelegate:self];
        
        [sendView show:YES];
        [sendView release];
        [string release];
    }
    else {
        WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBKeyAppKey appSecret:kWBKeyAppSecret];
        [engine setRootViewController:self];
        [engine setRedirectURI:@"http://www.sina.com"];
        [engine setIsUserExclusive:NO];
        self.weiBoEngine = engine;
        [engine release];
        [self.weiBoEngine logIn];
        
    }
}

#pragma mark - 微信分享
#define BUFFER_SIZE 1024 * 100
//发送图片消息
-(void)sendImageContent:(UIImage *)img description:(NSString *)description url:(NSString *)url{
//    WXMediaMessage *msg = [WXMediaMessage message];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//    [msg setThumbImage:[UIImage imageWithData:data]];
//    
//    WXImageObject *ext = [WXImageObject object];
//    ext.imageUrl = imgUrl;
//    
//    msg.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
//    req.bText = NO;
//    req.message = msg;
//    req.scene = WXSceneSession;
//    
//    [WXApi sendReq:req];
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = @"桃小仙,讨你喜欢~";
    msg.description = description;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//    [msg setThumbImage:[UIImage imageWithData:data]];
    [msg setThumbImage:[img scaleToSize:CGSizeMake(150, 150)]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.extInfo = @"桃小仙test";
    ext.webpageUrl = url;
    
//    Byte *pBuffer = (Byte *)malloc(BUFFER_SIZE);
//    memset(pBuffer, 0, BUFFER_SIZE);
//    NSData *data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
//    free(pBuffer);
//    
//    ext.fileData = data;
    
    msg.mediaObject = ext;
    
    SendMessageToWXReq *req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = msg;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

#pragma mark - 腾讯微博分享
/*
 * 初始化titlelabel和webView
 */
- (void) webViewShow {
    
//    CGFloat titleLabelFontSize = 14;
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _titleLabel.text = @"微博登录";
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
//    _titleLabel.textColor = [UIColor blackColor];
//    _titleLabel.font = [UIFont boldSystemFontOfSize:titleLabelFontSize];
//    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
//    | UIViewAutoresizingFlexibleBottomMargin;
//    _titleLabel.textAlignment = UITextAlignmentCenter;
//    
//    [self.view addSubview:_titleLabel];
    
//    [_titleLabel sizeToFit];
//    CGFloat innerWidth = self.view.frame.size.width;
//    _titleLabel.frame = CGRectMake(
//                                   0,
//                                   0,
//                                   innerWidth,
//                                   _titleLabel.frame.size.height+6);
    
//    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
//    bounds.origin.y -= 20;
    self.title = @"腾讯微博登陆";
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height,
                                                           self.view.frame.size.width,
                                                           self.view.frame.size.height)];
    
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_webView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect bounds = [[UIScreen mainScreen] applicationFrame];
                         bounds.origin.y -= 20;
                         _webView.frame = bounds;
                     }];
}

/*
 * 采用两种不同方式进行登录授权,支持webview和浏览器两种方式
 */
- (void) testLoginWithMicroblogAccount {
    
    uint16_t authorizeType = InWebView; 
    
    _OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
    _OpenSdkOauth.oauthType = authorizeType;
    
    BOOL didOpenOtherApp = NO;
    switch (authorizeType) {
        case InSafari:  //浏览器方式登录授权，不建议使用
        {
            didOpenOtherApp = [_OpenSdkOauth doSafariAuthorize:didOpenOtherApp];
            break;
        }
        case InWebView:  //webView方式登录授权，采用oauth2.0授权鉴权方式
        {
            if(!didOpenOtherApp){
                if (([OpenSdkBase getAppKey] == (NSString *)[NSNull null]) || ([OpenSdkBase getAppKey].length == 0)) {
                    NSLog(@"client_id is null");
                    [OpenSdkBase showMessageBox:@"client_id为空，请到OPenSdkBase中填写您应用的appkey"];
                }
                else
                {
                    [self webViewShow];
                }
                
                [_OpenSdkOauth doWebViewAuthorize:_webView];
                
                break;
            }
        }
        default:
            break;
    }
}


-(void)share2QQWeibo
{   
//    if (!_OpenSdkOauth.accessToken || !_OpenSdkOauth.accessSecret) {
//        [self testLoginWithMicroblogAccount];
//        return;
//    }
//    
//    
//    _OpenApi = [[OpenApi alloc] initForApi:_OpenSdkOauth.appKey appSecret:_OpenSdkOauth.appSecret accessToken:_OpenSdkOauth.accessToken accessSecret:_OpenSdkOauth.accessSecret openid:_OpenSdkOauth.openid oauthType:_OpenSdkOauth.oauthType];
//    
//    NSLog(@"appkey:%@,appsecret:%@,token:%@,tokenkey:%@,openid:%@", _OpenSdkOauth.appKey, _OpenSdkOauth.appSecret, _OpenSdkOauth.accessToken,_OpenSdkOauth.accessSecret, _OpenSdkOauth.openid);
//    
//    
//    
//	NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"tmp.png"];
//    NSLog(@"filename is %@", filePath);
//    
//    [UIImageJPEGRepresentation(self.thumbImage, 0) writeToFile:filePath atomically:YES];
//    
//    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//    NSLog(@"imageData size in picker:%d", [imageData length]);
//    
////    _publishParams = [NSMutableDictionary dictionary];
//    
//    //Todo：请填写调用t/add_pic发表带图片微博接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
//    NSString *weiboContent = [NSString stringWithFormat:@"%@  %@",self.articleTitle,self.shortUrl];  //Todo：微博内容
//    //发表带图片微博
//    [_OpenApi publishWeiboWithImage:filePath weiboContent:weiboContent jing:@"0" wei:@"0" format:@"xml" clientip:@"CLIENTIP" syncflag:@"0"];  
}

#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    if (!backBarButtonItem) {
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
        backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		backBarButtonItem.width = 18.0f;
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
        forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		forwardBarButtonItem.width = 18.0f;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    
    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return actionBarButtonItem;
}

- (UIActionSheet *)pageActionSheet {
    
    if(!pageActionSheet) {
        pageActionSheet = [[UIActionSheet alloc] 
                        initWithTitle:self.articleTitle     //self.mainWebView.request.URL.absoluteString
                        delegate:self 
                        cancelButtonTitle:nil   
                        destructiveButtonTitle:nil   
                        otherButtonTitles:nil]; 

        if((self.availableActions & SVWebViewControllerAvailableActionsCopyLink) == SVWebViewControllerAvailableActionsCopyLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Copy Link", @"")];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsOpenInSafari) == SVWebViewControllerAvailableActionsOpenInSafari)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", @"")];
        
        if([MFMailComposeViewController canSendMail] && (self.availableActions & SVWebViewControllerAvailableActionsMailLink) == SVWebViewControllerAvailableActionsMailLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Mail Link to this Page", @"")];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsShare2WeiXin) == SVWebViewControllerAvailableActionsShare2WeiXin)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Share to weixin", @"")];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsShare2QQWeiBo) == SVWebViewControllerAvailableActionsShare2QQWeiBo)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Share to tengxun weibo", @"")];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsShare2SinaWeiBo) == SVWebViewControllerAvailableActionsShare2SinaWeiBo)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Share to sina weibo", @"")];
        
        
        [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }
    
    return pageActionSheet;
}

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL thumbImage:(UIImage *)_thumbImage title:(NSString *)_articleTitle {
    
    if(self = [super init]) {
        self.URL = pageURL;
        self.articleTitle = _articleTitle;
        self.thumbImage = _thumbImage;
        self.availableActions = //SVWebViewControllerAvailableActionsOpenInSafari |
            SVWebViewControllerAvailableActionsMailLink | 
            SVWebViewControllerAvailableActionsCopyLink //|
//            SVWebViewControllerAvailableActionsShare2WeiXin //|
//            SVWebViewControllerAvailableActionsShare2QQWeiBo | //腾讯微博登陆部分还需要优化
//            SVWebViewControllerAvailableActionsShare2SinaWeiBo
            ;
    }
    
    return self;
}

#pragma mark - Memory management

- (void)dealloc {
    [_webView release];
    [_OpenApi release];
    [_OpenSdkOauth release];
    
//    self.shortUrl = nil;
//    self.mURLShortenInterface.delegate = nil;
//    self.mURLShortenInterface = nil;
    
    mainWebView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - View lifecycle

- (void)loadView {
    mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    [mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    self.view = mainWebView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
//    self.mURLShortenInterface = [[URLShortenInterface alloc] init];
//    self.mURLShortenInterface.delegate = self;
//    [self.mURLShortenInterface getShortUrl:self.URL.absoluteString];
    
//    //处理tab bar
//    mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
//    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"TabBarShareView" owner:self options:nil];
//    self.tabBarView = (TabBarShareView*)[arr1 objectAtIndex:0];
//    [self.tabBarView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
////    [self.tabBarView.homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [mCustomTabBarController pushTabBar:self.tabBarView];
    
    
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    mainWebView = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
    pageActionSheet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    
//    self.tabBarView.webUndoBtn.enabled = self.mainWebView.canGoBack;
//    self.tabBarView.webForwardBtn.enabled = self.mainWebView.canGoForward;
//    
//    
//    [self.tabBarView.webUndoBtn addTarget:self
//                                   action:@selector(goBackClicked:)
//                            forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.tabBarView.webForwardBtn addTarget:self
//                                      action:@selector(goForwardClicked:)
//                            forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.tabBarView.webRefreshBtn addTarget:self
//                                      action:@selector(reloadClicked:)
//                            forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.tabBarView.shareBtn addTarget:self
//                                      action:@selector(actionButtonClicked:)
//                            forControlEvents:UIControlEventTouchUpInside];
//    
    
    
    
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = !self.mainWebView.isLoading
        && ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
    
    UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray *items;
        CGFloat toolbarWidth = 250.0f;
        
        if(self.availableActions == 0) {
            toolbarWidth = 200.0f;
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     fixedSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    } 
    else {
        NSArray *items;
        
        if(self.availableActions == 0) {
            items = [NSArray arrayWithObjects:
                     flexibleSpace,
                     self.backBarButtonItem, 
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
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
        }
        
        self.toolbarItems = items;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self action:@selector(goMainView)];
}

-(void)goMainView
{
    if (_webView.superview == self.view) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect frame = CGRectMake(0, 
                                                       self.view.frame.size.height, 
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height);
                             _webView.frame = frame;
                         } 
                         completion:^(BOOL finished) {
                             self.title = self.articleTitle;
                             [_webView removeFromSuperview];
                         }];
        
    }else{
        [self.navigationController setToolbarHidden:YES animated:NO];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState 
         | UIViewAnimationCurveEaseIn animations:^{
             CATransition *animation = [CATransition animation];
             [animation setDuration:0.5];
             [animation setType: kCATransitionReveal];//覆盖
             [animation setSubtype: kCATransitionFromLeft];
             [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            
             [self.navigationController.view.layer addAnimation:animation forKey:nil];
         } completion:^(BOOL finished) {
             if (finished)
             {
                 [self.navigationController popViewControllerAnimated:NO];
                 
                 
    //             CGAffineTransform transform = CGAffineTransformScale(self.view.transform, 2, 2);
    //             [self.view setTransform: transform];    // this effects the SUBVIEWS rotate and scale
             }
         }];
    }
    
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView != _webView) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self updateToolbarItems];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView != _webView) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self updateToolbarItems];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView != _webView) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self updateToolbarItems];
    }else{
        NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
        
        if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
            [_OpenSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
            [_webView removeFromSuperview];
//            [_titleLabel removeFromSuperview];
        }
    }
}

/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView == _webView) {
        NSURL* url = request.URL;
        
        NSLog(@"response url is %@", url);
        NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
        
        //如果找到tokenkey,就获取其他key的value值
        if (start.location != NSNotFound)
        {
            NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
            NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
            NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
            NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
            
            NSDate *expirationDate =nil;
            if (_OpenSdkOauth.expireIn != nil) {
                int expVal = [_OpenSdkOauth.expireIn intValue];
                if (expVal == 0) {
                    expirationDate = [NSDate distantFuture];
                } else {
                    expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
                } 
            } 
            
            NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
            
            if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
                || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
                || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
                [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
            }
            else {
                [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
            }
            _webView.delegate = nil;
            [_webView setHidden:YES];
            //        [_titleLabel setHidden:YES];
            
            return NO;
        }
        else
        {
            start = [[url absoluteString] rangeOfString:@"code="];
            if (start.location != NSNotFound) {
                [_OpenSdkOauth refuseOauth:url];
            }
        }
    }
    return YES;
}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    [mainWebView stopLoading];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {
    
    if(pageActionSheet)
        return;
	
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.pageActionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
    else
        [self.pageActionSheet showFromToolbar:self.navigationController.toolbar];
    
}

- (void)doneButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
	if([title isEqualToString:NSLocalizedString(@"Open in Safari", @"")])
        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL];
    
    if([title isEqualToString:NSLocalizedString(@"Copy Link", @"")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.mainWebView.request.URL.absoluteString;
    }
    
    else if([title isEqualToString:NSLocalizedString(@"Mail Link to this Page", @"")]) {
        
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        
		mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
  		[mailViewController setMessageBody:self.mainWebView.request.URL.absoluteString isHTML:NO];
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
		[self presentModalViewController:mailViewController animated:YES];
        
	}else if([title isEqualToString:NSLocalizedString(@"Share to weixin", @"")]){

        [self sendImageContent:self.thumbImage 
                   description:self.articleTitle 
                           url:[self.URL absoluteString]];
        
    }else if([title isEqualToString:NSLocalizedString(@"Share to tengxun weibo", @"")]){

        [self share2QQWeibo];
        
    }else if([title isEqualToString:NSLocalizedString(@"Share to sina weibo", @"")]){
        
        [self share2SinaWeibo];
    }
    
    pageActionSheet = nil;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error 
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIWebviewDelegate
///*
// * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
// */
//- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSURL* url = request.URL;
//    
//    NSLog(@"response url is %@", url);
//	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
//    
//    //如果找到tokenkey,就获取其他key的value值
//	if (start.location != NSNotFound)
//	{
//        NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
//        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
//        NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
//		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
//        
//		NSDate *expirationDate =nil;
//		if (_OpenSdkOauth.expireIn != nil) {
//			int expVal = [_OpenSdkOauth.expireIn intValue];
//			if (expVal == 0) {
//				expirationDate = [NSDate distantFuture];
//			} else {
//				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
//			} 
//		} 
//        
//        NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
//        
//        if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
//            || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
//            || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
//            [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
//        }
//        else {
//            [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
//        }
//        _webView.delegate = nil;
//        [_webView setHidden:YES];
////        [_titleLabel setHidden:YES];
//        
//		return NO;
//	}
//	else
//	{
//        start = [[url absoluteString] rangeOfString:@"code="];
//        if (start.location != NSNotFound) {
//            [_OpenSdkOauth refuseOauth:url];
//        }
//	}
//    return YES;
//}

///*
// * 当网页视图结束加载一个请求后得到通知
// */
//- (void) webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *url = _webView.request.URL.absoluteString;
//    NSLog(@"web view finish load URL %@", url);
//}

///*
// * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
// */
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
//    
//    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
//        [_OpenSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
//        [_webView removeFromSuperview];
//        [_titleLabel removeFromSuperview];
//	}
//}

#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"=======%@",error.localizedDescription);
    
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"亲！网络不佳，微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

//#pragma mark - URLShortenInterfaceDelegate
//-(void)getShortUrlDidFinished:(NSString *)shortUrl
//{
//    self.shortUrl = shortUrl;
//}
//
//-(void)getShortUrlDidFailed
//{
//    //TODO:获取短链接失败
//}

#pragma mark - TabBar button action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
    //移除当前tabbar
//    [mCustomTabBarController popTabBar];//移除当前tabbar
}

-(void)homeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    CustomTabBarController *mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    //移除当前tabbar
//    [mCustomTabBarController popToRootTabBar];//移除当前tabbar
    
}

- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
//	[self.tabBarView removeFromSuperview];
}

@end
