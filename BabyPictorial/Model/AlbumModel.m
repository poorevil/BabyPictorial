//
//  AlbumModel.m
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

-(id)init
{
    if (self = [super init]) {
        self.picArray = [NSMutableArray array];
    }
    
    return self;
}

-(void)dealloc
{
    self.albumId = nil;
    self.albumName = nil;
    self.picArray = nil;
    
    [super dealloc];
}

@end
