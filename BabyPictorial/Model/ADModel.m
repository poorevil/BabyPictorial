//
//  ADModel.m
//  BabyPictorial
//
//  Created by han chao on 13-4-7.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "ADModel.h"

@implementation ADModel

-(void)dealloc
{
    self.title = nil;
    self.picUrl = nil;
    
    self.adIdentifier = nil;
        
    [super dealloc];
}
@end
