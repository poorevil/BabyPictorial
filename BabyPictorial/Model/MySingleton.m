//
//  MySingleton.m
//  ZReader_HD
//
//  Created by zcom on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MySingleton.h"
//#import "CategoryRecommendModel.h"
//#import "ShopRecommendModel.h"

@implementation MySingleton

@synthesize appKey = _appKey , appSecret = _appSecret;
//@synthesize baseInterfaceUrl = _baseInterfaceUrl;

+ (MySingleton *)sharedSingleton
{
    static MySingleton *sharedSingleton=nil;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[MySingleton alloc] init];
        
        return sharedSingleton;
    }
}

-(id)init {
    self = [super init];
    
    if (self) {
        self.appKey = @"21125417";
        self.appSecret = @"2b4fc27525fd9a225cdedcbb0a6862a7";
//        _baseInterfaceUrl = @"http://pp.zcom.com";
    }
    
    return self;
}

////从plist中获取状态dict
//-(NSMutableDictionary *)getRecommendDict
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *plistFile = [[paths objectAtIndex:0]
//                           stringByAppendingPathComponent:@"recommend.plist"];
//    
//    NSMutableDictionary *stateDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistFile] autorelease];
//    if (!stateDict) {
//        stateDict = [[[NSMutableDictionary alloc] init] autorelease];
//        
//        //初始化状态值
////        [stateDict setObject:[NSNumber numberWithInt:0] forKey:@"lastCircleId"];//上次所在圈子id
////        [stateDict setObject:[NSNumber numberWithInt:UIImagePickerControllerCameraFlashModeAuto]
////                      forKey:@"lastCameraFlashMode"];//上次相机闪光灯状态
////        
////        [stateDict setObject:@"" forKey:@"name"];//用户昵称
////        [stateDict setObject:@"" forKey:@"userId"];//用户id
////        [stateDict setObject:@"" forKey:@"avatarUrl"];//用户头像
//        
//        [stateDict writeToFile:plistFile atomically:YES];//保存plist
//    }
//    
//    return stateDict;
//}
//
////保存状态dict到plist
//-(void)saveRecommendDict:(NSMutableDictionary *)stateDict
//{
//    if (stateDict) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                             NSUserDomainMask, YES);
//        NSString *plistFile = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:@"recommend.plist"];
//        
//        [stateDict writeToFile:plistFile atomically:YES];//保存plist
//    }
//}
//
////类目推荐数组
//-(NSArray *)categoryRecommendArray
//{
//    NSArray *array = [[self getRecommendDict] objectForKey:@"category"];
//    NSMutableArray *resultArray = [NSMutableArray array];
//    for (NSData *data in array) {
//        [resultArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
//    }
//    
//    return resultArray;
//}
//
//-(void)setCategoryRecommendArray:(NSArray *)categoryRecommendArray
//{
//    
//    NSMutableDictionary *recommendDict = [self getRecommendDict];
//    
//    NSMutableArray *array = [NSMutableArray array];
//    for (CategoryRecommendModel *cate in categoryRecommendArray) {
//        [array addObject:[NSKeyedArchiver archivedDataWithRootObject:cate]];
//    }
//    
//    [recommendDict setObject:array forKey:@"category"];
//    
//    [self saveRecommendDict:recommendDict];
//}
//
////关键字推荐数组
//-(NSArray *)keywordRecommendArray
//{
//    return [[self getRecommendDict] objectForKey:@"keyword"];
//}
//
//-(void)setKeywordRecommendArray:(NSArray *)keywordRecommendArray
//{
//    NSMutableDictionary *recommendDict = [self getRecommendDict];
//    [recommendDict setObject:keywordRecommendArray forKey:@"keyword"];
//    
//    [self saveRecommendDict:recommendDict];
//}
//
////类目推荐数组
//-(NSArray *)shopRecommendArray
//{
//    NSArray *array = [[self getRecommendDict] objectForKey:@"shop"];
//    NSMutableArray *resultArray = [NSMutableArray array];
//    for (NSData *data in array) {
//        [resultArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
//    }
//    
//    return resultArray;
//}
//
//-(void)setShopRecommendArray:(NSArray *)shopRecommendArray{
//    
//    NSMutableDictionary *recommendDict = [self getRecommendDict];
//    
//    NSMutableArray *array = [NSMutableArray array];
//    for (ShopRecommendModel *shop in shopRecommendArray) {
//        [array addObject:[NSKeyedArchiver archivedDataWithRootObject:shop]];
//    }
//    
//    [recommendDict setObject:array forKey:@"shop"];
//    
//    [self saveRecommendDict:recommendDict];
//}
//
////从plist中获取settings dict
//-(NSMutableDictionary *)getSettingsDict
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *settingsFile = [[paths objectAtIndex:0]
//                              stringByAppendingPathComponent:@"settings.plist"];
//    
//    NSMutableDictionary *settingsDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile] autorelease];
//    if (!settingsDict) {
//        settingsDict = [[[NSMutableDictionary alloc] init] autorelease];
//        
//        //初始化状态值
//        [settingsDict setObject:[NSNumber numberWithBool:YES] forKey:@"autoPicQuality"];//自动显示图片质量
//        
//        [settingsDict writeToFile:settingsFile atomically:YES];//保存plist
//    }
//    
//    return settingsDict;
//}
//
////保存setting dict到plist
//-(void)saveSettingsDict:(NSMutableDictionary *)stateDict
//{
//    if (stateDict) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                             NSUserDomainMask, YES);
//        NSString *plistFile = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:@"settings.plist"];
//        
//        [stateDict writeToFile:plistFile atomically:YES];//保存plist
//    }
//}
//
//-(BOOL)autoPicQuality
//{
//    return [[[self getSettingsDict] objectForKey:@"autoPicQuality"] boolValue];
//}
//
//-(void)setAutoPicQuality:(BOOL)autoPicQuality
//{
//    NSMutableDictionary *settingsDict = [self getSettingsDict];
//    
//    [settingsDict setObject:[NSNumber numberWithBool:autoPicQuality] forKey:@"autoPicQuality"];
//    
//    [self saveSettingsDict:settingsDict];
//}

@end
