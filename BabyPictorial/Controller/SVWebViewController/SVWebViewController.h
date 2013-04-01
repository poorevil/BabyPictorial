//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"

#import "OpenSdkOauth.h"
#import "OpenApi.h"

#import "WBEngine.h"
#import "WBSendView.h"

//#import "URLShortenInterface.h"
//#import "CustomTabBarController.h"

@class TabBarShareView;

@interface SVWebViewController : UIViewController <WBSendViewDelegate>{//,URLShortenInterfaceDelegate
    
    UIWebView *_webView;
    OpenSdkOauth *_OpenSdkOauth;
    OpenApi *_OpenApi;
    
//    CustomTabBarController *mCustomTabBarController;
}

/*
 *  新浪微博相关
 */
@property (nonatomic,retain) WBEngine *weiBoEngine;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, assign) NSTimeInterval expireTime;

//@property (nonatomic,retain) URLShortenInterface *mURLShortenInterface;
//@property (nonatomic,retain) NSString *shortUrl;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)pageURL thumbImage:(UIImage *)_thumbImage title:(NSString *)_articleTitle;//initWithURL:(NSURL*)URL;

@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;

//@property (nonatomic,retain) TabBarShareView *tabBarView;

@end
