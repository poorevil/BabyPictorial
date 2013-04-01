//
//  PicWaterflowInterface.m
//  BabyPictorial
//
//  Created by han chao on 13-3-26.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicWaterflowInterface.h"

#import "JSONKit.h"

#import "PicDetailModel.h"

@implementation PicWaterflowInterface

-(void)getPicWaterflowByPageNum:(NSInteger)pageNum andAlbumId:(NSString *)albumId
{
    NSString *url = [NSString stringWithFormat:@"http://pic.taoxiaoxian.com/interface/picwaterflow?p=%d&cid=9",pageNum];
    
    if (albumId) {
        url = [NSString stringWithFormat:@"%@&albumId=%@",url,albumId];
    }
    
    self.interfaceUrl = url;
    self.baseDelegate = self;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
//[
// {
//     "albunm_id": "22452075",
//     "user_id": "75105614",
//     "description": "韩版儿童发夹，女童红色绸缎发夹，红色与绿色的碰撞，别样的风情美！",
//     "taoke_price": "7.80",
//     "pid": "66000437",
//     "root_cate_id": 0,
//     "height": 220,
//     "width": 220,
//     "cate_id": 9,
//     "time": "2013-03-24 16:03:10",
//     "taoke_title": "儿童头饰 女童红色绸缎发夹 发饰 儿童马尾夹",
//     "pic_path": "http://img02.taobaocdn.com/imgextra/i2/15614022777567581/T1y8RSXwRXXXXXXXXX_!!75105614-0-pix.jpg",
//     "albunm_name": "咔哇伊发饰萌翻天~",
//     "taoke_num_iid": "21467740846"
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
            
            for (NSDictionary *picDict in jsonObj) {
            
                PicDetailModel *pdm = [[[PicDetailModel alloc] init] autorelease];
                
                pdm.albumId = [picDict objectForKey:@"albunm_id"];
                pdm.userId = [picDict objectForKey:@"user_id"];
                pdm.descTitle = [picDict objectForKey:@"description"];
                pdm.taokePrice = [picDict objectForKey:@"taoke_price"];
                pdm.pid = [picDict objectForKey:@"pid"];
                pdm.rootCateId = [[picDict objectForKey:@"root_cate_id"] integerValue];
                pdm.height = [[picDict objectForKey:@"height"] integerValue];
                pdm.width = [[picDict objectForKey:@"width"] integerValue];
                pdm.cateId = [[picDict objectForKey:@"cate_id"] integerValue];
                pdm.time = [picDict objectForKey:@"time"];
                pdm.taokeTitle = [picDict objectForKey:@"taoke_title"];
                pdm.picUrl = [picDict objectForKey:@"pic_path"];
                pdm.albumName = [picDict objectForKey:@"albunm_name"];
                pdm.taokeNumiid = [picDict objectForKey:@"taoke_num_iid"];
                
                [resultArray addObject:pdm];
            
            }            
            
            [self.delegate getPicWaterflowByPageNumDidFinished:resultArray];
            
        }
        @catch (NSException *exception) {
            [self.delegate getPicWaterflowByPageNumDidFailed:@"获取失败"];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPicWaterflowByPageNumDidFailed:[NSString stringWithFormat:@"获取失败！(%@)",error]];
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end
