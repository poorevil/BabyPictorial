//
//  TaokeItemDetailInterface.m
//  BabyPictorial
//
//  Created by han chao on 13-3-30.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "TaokeItemDetailInterface.h"

#import "ASIHTTPRequest.h"

#import "TaobaoUrlSignGenerateUtil.h"

#import "JSONKit.h"

@implementation TaokeItemDetailInterface

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter release];
    
    return destDate;
    
}

-(void)getTaokeItemDetailsByNumiid:(NSString *)num_iid
{
    //http://gw.api.taobao.com/router/rest?
//        sign=729C5BF5C9C0F791201E1F1E910E1335
//        &timestamp=2013-03-30+16%3A44%3A16
//        &v=2.0
//        &app_key=12129701
//        &method=taobao.taobaoke.items.detail.get
//        &partner_id=top-apitools
//        &format=json
//        &num_iids=17617225578
//          &fields=click_url
//          &outer_code=baby
    
    if (num_iid && num_iid.length > 0) {
    
        NSString *urlStr = [NSString stringWithFormat:@"http://gw.api.taobao.com/router/rest?method=taobao.taobaoke.items.detail.get&num_iids=%@&fields=click_url&outer_code=%@",num_iid,@"baby"];
        
        urlStr = [TaobaoUrlSignGenerateUtil dealUrl2TaobaoStyle:urlStr];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        self.request = [ASIHTTPRequest requestWithURL:url];
        [self.request setTimeOutSeconds:15];
        
        [self.request setDelegate:self];
        [self.request startAsynchronous];
    }
}


#pragma mark - ASIHttpRequestDelegate
//{
//    "taobaoke_items_detail_get_response": {
//        "taobaoke_item_details": {
//            "taobaoke_item_detail": [
//                                     {
//                                         "click_url": "http://s.click.taobao.com/t?e=zGU34CA7K%2BPkqB07S4%2FK0CITy7klxn%2Fr3HZwuuY0VC7BwYV228tDpGwUhhsZhXt2qcwARuSK2A%2BDnend09V3vKbNebVpWL4HgQHsSKypkO0SxMpaQRQgl90gCil3MurSZt%2FslsaNUokVQmx0vp6QyfY3fHVGrGL9X2B8qaDUN2aHTHtR4IG1McruVc9RfFuT031G5Kk%3D&unid=baby&spm=2014.12129701.1.0",
//                                         "item": {}
//                                     }
//                                     ]
//        },
//        "total_results": 1
//    }
//}

-(void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseBody = request.responseString;

    NSDictionary *respDict = (NSDictionary *)[responseBody objectFromJSONString];
    
    NSDictionary *taobaokeDict = [respDict objectForKey:@"taobaoke_items_detail_get_response"];
    
    if (taobaokeDict && taobaokeDict.count > 0) {
        
        NSArray *itemsArray = [[taobaokeDict objectForKey:@"taobaoke_item_details"] objectForKey:@"taobaoke_item_detail"];
        
        NSMutableArray *resultArray = [NSMutableArray array];
        
        [resultArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"所有分类",@"name"
                                ,[NSNumber numberWithInt:30],@"cid", nil]];
        
        for (NSDictionary *dict in itemsArray) {
            
            NSString *url = [dict objectForKey:@"click_url"];
            
            [self.delegate getTaokeItemDetailsByNumiidDidFinished:url];
            
            break;
        }
        
    }else{
        
        [self.delegate getTaokeItemDetailsByNumiidDidFailed];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"%@",request.error.localizedDescription);
    
    [self.delegate getTaokeItemDetailsByNumiidDidFailed];
}

-(void)dealloc {
    self.delegate = nil;
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    
    [super dealloc];
}

@end
