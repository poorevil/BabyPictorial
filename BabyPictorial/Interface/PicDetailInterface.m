//
//  PicDetailInterface.m
//  BabyPictorial
//
//  Created by han chao on 13-3-25.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailInterface.h"

#import "JSONKit.h"

#import "PicDetailModel.h"
#import "AlbumModel.h"

@implementation PicDetailInterface

-(void)getPicDetailByPid:(NSString *)pid
{
    self.interfaceUrl = [NSString stringWithFormat:@"http://pic.taoxiaoxian.com/interface/picdetail?pid=%@&cid=9",pid];
    self.baseDelegate = self;
    
    [self connect];
}


#pragma mark - BaseInterfaceDelegate
//{
//    "picModelInAlbum": [
//                        {
//                            "pic_path": "http://img04.taobaocdn.com/imgextra/i4/15167020618926233/T1NHdNXsdeXXXXXXXX_!!862605167-0-pix.jpg",
//                            "pid": "64852851",
//                            "pic_desc": "adsfsdfdsfdsf"
//                        },
//                        ...
//                        ],
//    "picDetail": {
//        "albunm_id": "22464807",
//        "user_id": "862605167",
//        "description": "配色简洁的魅力开衫\n.柔和自然的配色，很适合春季的氛围",
//        "taoke_price": "115.00",
//        "pid": "64848695",
//        "root_cate_id": 0,
//        "height": 220,
//        "width": 220,
//        "cate_id": 9,
//        "time": "2013-03-19 16:58:57",
//        "taoke_title": "韩国进口正品童装【部分现货】三只熊P 148590 条纹休闲开衫",
//        "pic_path": "http://img04.taobaocdn.com/imgextra/i4/15167022543695582/T1XHROXppbXXXXXXXX_!!862605167-0-pix.jpg",
//        "albunm_name": "帅气男宝的休闲小风度",
//        "taoke_num_iid": "17418578063"
//    },
//    "recommendAlbum": [
//                       {
//                           "albunmId": "22525423",
//                           "albunmName": "个性小潮男上街酷搭",
//                           "picDetail": [
//                                         {
//                                             "pic_path": "http://img04.taobaocdn.com/imgextra/i4/15614020857430971/T17itQXuhgXXXXXXXX_!!75105614-0-pix.jpg",
//                                             "pid": "65981475",
//                                             "pic_desc": "adsfsdfdsfdsf"
//                                         },
//                                         {
//                                             "pic_path": "http://img04.taobaocdn.com/imgextra/i4/15614022774199508/T1WGVGXzpgXXXXXXXX_!!75105614-0-pix.jpg",
//                                             "pid": "65984407",
//                                             "pic_desc": "adsfsdfdsfdsf"
//                                         },
//                                         ...
//                                         ]
//                       },
//                       ...
//                       ]
//}
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    id jsonObj = [jsonStr objectFromJSONString];
    
    [jsonStr release];
    
    if (jsonObj) {
        @try {
            NSDictionary *item = jsonObj;
                
            NSDictionary *picDict = [item objectForKey:@"picDetail"];
            
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
            
            
            /*
             *recommendAlbum
             */
            NSArray *recommendAlbum = [item objectForKey:@"recommendAlbum"];
            
            for (NSDictionary *dict in recommendAlbum) {
                
                AlbumModel *am = [[AlbumModel alloc] init];
                am.albumId = [dict objectForKey:@"albunmId"];
                am.albumName = [dict objectForKey:@"albunmName"];
                
                NSArray *picDetails = [dict objectForKey:@"picDetail"];
                
                for (NSDictionary *dict in picDetails) {
                    
                    PicDetailModel *pdm = [[PicDetailModel alloc] init];
                    
                    pdm.pid = [dict objectForKey:@"pid"];
                    pdm.picUrl = [dict objectForKey:@"pic_path"];
                    pdm.descTitle = [dict objectForKey:@"pic_desc"];
                    
                    [am.picArray addObject:pdm];
                    
                    [pdm release];
                }
                                    
                [pdm.recommendAlbumArray addObject:am];
                [am release];
            }
            
            /*
             *picModelInAlbum
             */
            NSArray *picOwnerAlbum = [item objectForKey:@"picModelInAlbum"];
                
            AlbumModel *am = [[AlbumModel alloc] init];
            am.albumId = pdm.albumId;
            am.albumName = pdm.albumName;
            
            for (NSDictionary *dict in picOwnerAlbum) {
                
                PicDetailModel *pdm = [[PicDetailModel alloc] init];
                
                pdm.pid = [dict objectForKey:@"pid"];
                pdm.picUrl = [dict objectForKey:@"pic_path"];
                pdm.descTitle = [dict objectForKey:@"pic_desc"];
                
                [am.picArray addObject:pdm];
                
                [pdm release];
            }
            
            pdm.ownerAlbum = am;
            [am release];
            
            
            [self.delegate getPicDetailDidFinished:pdm];

        }
        @catch (NSException *exception) {
            [self.delegate getPicDetailDidFailed:@"获取失败"];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPicDetailDidFailed:[NSString stringWithFormat:@"获取失败！(%@)",error]];
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end
