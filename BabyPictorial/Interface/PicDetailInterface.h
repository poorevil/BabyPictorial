//
//  PicDetailInterface.h
//  BabyPictorial
//
//  Created by han chao on 13-3-25.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "BaseInterface.h"

@class PicDetailModel;

@protocol PicDetailInterfaceDelegate;

@interface PicDetailInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<PicDetailInterfaceDelegate> delegate;

-(void)getPicDetailByPid:(NSString *)pid;

@end

@protocol PicDetailInterfaceDelegate <NSObject>

-(void)getPicDetailDidFinished:(PicDetailModel *)pdm;
-(void)getPicDetailDidFailed:(NSString *)errorMsg;


@end