//
//  AlbumModel.m
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

-(void)dealloc
{
    self.albumId = nil;
    self.albumName = nil;
    self.picUrls = nil;
    
    [super dealloc];
}

@end
