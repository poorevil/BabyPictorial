//
//  UINavigationController+OrientationControl.m
//  BabyPictorial
//
//  Created by han chao on 13-6-2.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "UINavigationController+OrientationControl.h"

@implementation UINavigationController (OrientationControl)

-(NSUInteger)supportedInterfaceOrientations
{
    if (IDIOM == IPAD){
        
        return UIInterfaceOrientationMaskLandscape;
    }else{
        
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}


-(BOOL)shouldAutorotate
{
    return YES;
}

@end
