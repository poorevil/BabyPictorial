//
//  TaokeItemDetailInterface.h
//  BabyPictorial
//
//  Created by han chao on 13-3-30.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@protocol ASIHTTPRequestDelegate;
@protocol TaokeItemDetailInterfaceDelegate;

@interface TaokeItemDetailInterface : NSObject <ASIHTTPRequestDelegate>

@property (retain,nonatomic) ASIHTTPRequest *request;
@property (nonatomic,assign) id<TaokeItemDetailInterfaceDelegate> delegate;

-(void)getTaokeItemDetailsByNumiid:(NSString *)num_iid;

@end

@protocol TaokeItemDetailInterfaceDelegate <NSObject>

-(void)getTaokeItemDetailsByNumiidDidFinished:(NSString *)url;
-(void)getTaokeItemDetailsByNumiidDidFailed;

@end