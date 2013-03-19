//
//  UIColor+ColorFromHex.m
//  FemaleShop
//
//  Created by han chao on 12-11-14.
//  Copyright (c) 2012年 taoxiaoxian. All rights reserved.
//

#import "UIColor+ColorFromHex.h"

@implementation UIColor (ColorFromHex)


+(UIColor *)colorFromHex:(NSString *)hex
{
    if (hex != nil && [hex hasPrefix:@"#"]) {
        //#FFFFFF  RGB
        if (hex.length == 7) {
            
            hex = [hex substringFromIndex:1];
            unsigned int hexNumber;
            [[NSScanner scannerWithString:hex] scanHexInt:&hexNumber];
            
            return [UIColor colorWithRed:((float)((hexNumber & 0xFF0000) >> 16))/255.0
                            green:((float)((hexNumber & 0xFF00) >> 8))/255.0
                             blue:((float)(hexNumber & 0xFF))/255.0
                            alpha:1.0];
            
        }else if (hex.length == 9) {//#FFFFFFFF  ARGB
            hex = [hex substringFromIndex:1];
            unsigned int hexNumber;
            [[NSScanner scannerWithString:hex] scanHexInt:&hexNumber];
            
            return [UIColor colorWithRed:((float)((hexNumber & 0xFF0000) >> 16))/255.0
                                   green:((float)((hexNumber & 0xFF00) >> 8))/255.0
                                    blue:((float)(hexNumber & 0xFF))/255.0
                                   alpha:((float)((hexNumber & 0xFF000000) >> 24))/255.0];
            
        }
    }
    
    return [UIColor clearColor];
}

@end
