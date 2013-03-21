//
//  BaseInterface.m
//  ZReader_HD
//
//  接口父类
//
//  Created by  on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@implementation BaseInterface

@synthesize baseDelegate = _baseDelegate , request = _request;
@synthesize interfaceUrl = _interfaceUrl , headers = _headers , bodys = _bodys;

-(void)connect {
    if (self.interfaceUrl) {
        NSURL *url = [[NSURL alloc]initWithString:self.interfaceUrl];
        
        self.request = [ASIHTTPRequest requestWithURL:url];
        [url release];
        
//        //设置缓存机制
//        [[InterfaceCache sharedCache] setShouldRespectCacheControlHeaders:NO];
//        [self.request setDownloadCache:[InterfaceCache sharedCache]];
//        [self.request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
//        [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        
        [self.request setTimeOutSeconds:15];

        if (self.headers) {
            for (NSString *key in self.headers) {
                [self.request addRequestHeader:key value:[self.headers objectForKey:key]];
                
            }
        }
        
        [self.request setDelegate:self];
        [self.request startAsynchronous]; 
        
    }else{
        //抛出异常
    }
}

#pragma mark - ASIHttpRequestDelegate
//- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
//    responseHeaders = [responseHeaders allKeytoLowerCase];
//    
//    NSString *result = [responseHeaders objectForKey:@"result"];
//    if (![result isEqualToString:@"success"]) {
//        //失败
//        if ([@"102" isEqualToString:[responseHeaders objectForKey:@"error-code"]]) {
//            //[self.request clearDelegatesAndCancel];
//            self.request = nil;
//            
//            DefaultLoginInterface * defaultLogin = [[DefaultLoginInterface alloc] init];
//            self.login = defaultLogin;
//            self.login.delegate = self;
//            [defaultLogin release];
//            [self.login doLogin];
//        }
//    }
//}

-(void)requestFinished:(ASIHTTPRequest *)request {
    [self.baseDelegate parseResult:request];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    [_baseDelegate requestIsFailed:request.error];
}


-(void)dealloc {
    self.baseDelegate = nil;
    
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    
    self.interfaceUrl = nil;
    self.headers = nil;
    self.bodys = nil;
    
    [super dealloc];
}


@end
