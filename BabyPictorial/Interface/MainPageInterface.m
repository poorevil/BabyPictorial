//
//  MainPageInterface.m
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "MainPageInterface.h"

#import "AlbumModel.h"
#import "PicDetailModel.h"
#import "JSONKit.h"

@implementation MainPageInterface

-(void)getAlbumListByPageNum:(NSInteger)pageNum
{
    self.interfaceUrl = [NSString stringWithFormat:@"http://pic.taoxiaoxian.com/interface/recommend_album?p=%d&cid=9",pageNum];
    self.baseDelegate = self;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
//[
// {
//     "albunmId": "22418293",
//     "albunmName": "可爱宝贝---超洋气春装",
//     "picDetail": [
//                   {
//                       "pic_path": "http://img04.taobaocdn.com/imgextra/i4/19018020515306883/T1IV0LXwRdXXXXXXXX_!!653669018-0-pix.jpg",
//                       "pid": "64309213"
//                   },
//                   {
//                       "pic_path": "http://img04.taobaocdn.com/imgextra/i4/19018022429115540/T1VKtLXtlcXXXXXXXX_!!653669018-0-pix.jpg",
//                       "pid": "64311601"
//                   },
//                   {
//                       "pic_path": "http://img01.taobaocdn.com/imgextra/i1/19018020503946253/T1S7XLXA8aXXXXXXXX_!!653669018-0-pix.jpg",
//                       "pid": "64309212"
//                   },
//                   {
//                       "pic_path": "http://img03.taobaocdn.com/imgextra/i3/19018020503818499/T1uQFKXBVeXXXXXXXX_!!653669018-0-pix.jpg",
//                       "pid": "64308814"
//                   },
//                   {
//                       "pic_path": "http://img02.taobaocdn.com/imgextra/i2/19018020506243109/T13KNKXsJgXXXXXXXX_!!653669018-0-pix.jpg",
//                       "pid": "64302881"
//                   },
//                   {
//                       "pic_path": "http://img02.taobaocdn.com/imgextra/i2/19018020511649004/T1ZBBLXyJbXXXXXXXX_!!653669018-0-pix.jpg",
//                       "pid": "64302879"
//                   }
//                   ]
// },
//...
// ]
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    id jsonObj = [jsonStr objectFromJSONString];
    
    [jsonStr release];
    
    if (jsonObj) {
        @try {
            NSMutableArray *resultList = [[NSMutableArray alloc] init];
            for (NSDictionary *item in jsonObj) {
                
                AlbumModel *am = [[AlbumModel alloc] init];
                am.albumId = [item objectForKey:@"albunmId"];
                am.albumName = [item objectForKey:@"albunmName"];
                
                NSArray *picDetails = [item objectForKey:@"picDetail"];
                
                for (NSDictionary *dict in picDetails) {
                   
                    PicDetailModel *pdm = [[PicDetailModel alloc] init];
                    
                    pdm.pid = [dict objectForKey:@"pid"];
                    pdm.picUrl = [dict objectForKey:@"pic_path"];

                    [am.picArray addObject:pdm];
                    
                    [pdm release];
                }
                
                [resultList addObject:am];
                
                [am release];
            }
            
            [self.delegate getAlbumListDidFinished:resultList];
            
            [resultList release];
        }
        @catch (NSException *exception) {
            [self.delegate getAlbumListDidFailed:@"获取失败"];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    [self.delegate getAlbumListDidFailed:[NSString stringWithFormat:@"获取失败！(%@)",error]];
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}
@end
