//
//  RuntimeParamInterface.h
//  MMPictorial
//
//  获取运行时参数
//  调用时机：
//      1.AppDelegate，启动时
//      2.[MySingleton sharedSingleton]方法，当发现没有appKey等变量时
//
//  Created by han chao on 13-8-5.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseInterface.h"

//@protocol RuntimeParamInterfaceDelegate;

@interface RuntimeParamInterface :  BaseInterface <BaseInterfaceDelegate>

//@property (nonatomic,assign) id<RuntimeParamInterfaceDelegate> delegate;

-(void) getParam;


@end

//@protocol RuntimeParamInterfaceDelegate <NSObject>
//
//-(void)getParamDidFinished:
//
//@end
