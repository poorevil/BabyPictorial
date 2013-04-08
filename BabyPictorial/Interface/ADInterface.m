//
//  ADInterface.m
//  BabyPictorial
//
//
//  Created by han chao on 13-4-7.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "ADInterface.h"

#import "ADModel.h"

#import "JSONKit.h"

@implementation ADInterface

-(void)getADList
{
    self.interfaceUrl = [NSString stringWithFormat:@"http://pic.taoxiaoxian.com/interface/ad?appid=4"];//宝贝画报HD appId=4
    self.baseDelegate = self;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
//[
// {
//     "title": "广告位1",
//     "appId": "4",
//     "picUrl": "http://img02.taobaocdn.com/imgextra/i2/16508023355031665/T1qNd7XCBdXXXXXXXX_!!73236508-0-pix.jpg_300x1000.jpg",
//     "adIdentifier": "64012883",
//     "adType": 0,
//     "aId": 6,
//     "order": 1
// },
// ...
// ]
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    id jsonObj = [jsonStr objectFromJSONString];
    
    [jsonStr release];
    
    if (jsonObj) {
        @try {
            NSMutableArray *resultArray = [NSMutableArray array];
            
            for (NSDictionary *dict in jsonObj) {
                
                ADModel *ad = [[[ADModel alloc] init] autorelease];
                
                ad.title = [dict objectForKey:@"title"];
                ad.picUrl = [dict objectForKey:@"picUrl"];
                ad.adIdentifier = [dict objectForKey:@"adIdentifier"];
                ad.adType = [[dict objectForKey:@"adType"] intValue];
                
                [resultArray addObject:ad];
                
            }   
            
            [self.delegate getADListDidFinished:resultArray];
            
        }
        @catch (NSException *exception) {
            [self.delegate getADListDidFailed:@"获取失败"];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    [self.delegate getADListDidFailed:[NSString stringWithFormat:@"获取失败！(%@)",error]];
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end
