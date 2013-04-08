//
//  ADInterface.h
//  BabyPictorial
//
//  广告接口
//
//  Created by han chao on 13-4-7.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "BaseInterface.h"

@protocol ADInterfaceDelegate;

@interface ADInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<ADInterfaceDelegate> delegate;

-(void)getADList;

@end

@protocol ADInterfaceDelegate <NSObject>

-(void)getADListDidFinished:(NSArray *)result;
-(void)getADListDidFailed:(NSString *)errorMsg;


@end