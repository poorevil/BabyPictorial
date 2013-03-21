//
//  MySingleton.h
//  ZReader_HD
//
//  Created by zcom on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCLLocationManagerDidStarted @"kCLLocationManagerDidStarted"

@interface MySingleton : NSObject
+ (MySingleton *)sharedSingleton;
//@property (nonatomic,readonly) NSString *baseInterfaceUrl;//接口地址根路径

@property (nonatomic,retain) NSString *appKey;
@property (nonatomic,retain) NSString *appSecret;
@property (nonatomic,retain) NSArray *itemcatsArray;//查询页面-高级搜索-分类列表

@property (nonatomic,retain) NSArray *categoryRecommendArray;//类目推荐数组
@property (nonatomic,retain) NSArray *keywordRecommendArray;//关键字推荐数组
@property (nonatomic,retain) NSArray *shopRecommendArray;//店铺推荐数组

@property (nonatomic,assign) BOOL autoPicQuality;//自动图片质量


@end

