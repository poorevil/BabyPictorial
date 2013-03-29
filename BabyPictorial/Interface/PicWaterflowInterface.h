//
//  PicWaterflowInterface.h
//  BabyPictorial
//
//  Created by han chao on 13-3-26.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "BaseInterface.h"

@protocol PicWaterflowInterfaceDelegate;

@interface PicWaterflowInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<PicWaterflowInterfaceDelegate> delegate;

-(void)getPicWaterflowByPageNum:(NSInteger)pageNum andAlbumId:(NSString *)albumId;

@end

@protocol PicWaterflowInterfaceDelegate <NSObject>

-(void)getPicWaterflowByPageNumDidFinished:(NSArray *)array;
-(void)getPicWaterflowByPageNumDidFailed:(NSString *)errorMsg;

@end
