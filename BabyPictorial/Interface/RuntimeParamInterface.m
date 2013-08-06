//
//  RuntimeParamInterface.m
//  MMPictorial
//
//  Created by han chao on 13-8-5.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "RuntimeParamInterface.h"

#import "MySingleton.h"

#import "JSONKit.h"


@implementation RuntimeParamInterface

-(void)getParam
{
    self.interfaceUrl = [NSString stringWithFormat:@"http://vps.taoxiaoxian.com/interface/runtime_param?appId=%d",APP_ID];
    self.baseDelegate = self;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
//{
//    "appKey": "21125417",
//    "appSecret": "2b4fc27525fd9a225cdedcbb0a6862a7",
//    "taokeName": "杜冷丁MM"
//}
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    id jsonObj = [jsonStr objectFromJSONString];
    
    [jsonStr release];
    
    if (jsonObj) {
        @try {
            
            MySingleton *globe = [MySingleton sharedSingleton];
            
            globe.appKey = [jsonObj objectForKey:@"appKey"];
            globe.appSecret = [jsonObj objectForKey:@"appSecret"];
            globe.taokeName = [jsonObj objectForKey:@"taokeName"];
            
        }
        @catch (NSException *exception) {
            //TODO: 缺少重试机制
            
            NSLog(@"%@",exception.reason);
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    //TODO: 缺少重试机制
     NSLog(@"%@",error.description);
}

-(void)dealloc
{
//    self.delegate = nil;
    [super dealloc];
}


@end
