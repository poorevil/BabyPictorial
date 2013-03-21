//
//  MainPageInterface.h
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseInterface.h"

@protocol MainPageInterfaceDelegate;

@interface MainPageInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<MainPageInterfaceDelegate> delegate;

-(void)getAlbumListByPageNum:(NSInteger)pageNum;

@end

@protocol MainPageInterfaceDelegate <NSObject>

-(void)getAlbumListDidFinished:(NSArray *)resultArray;
-(void)getAlbumListDidFailed:(NSString *)errorMsg;


@end