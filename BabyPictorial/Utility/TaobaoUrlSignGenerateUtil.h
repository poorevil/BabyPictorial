//
//  TaobaoUrlSignGenerateUtil.h
//  Tenyuan
//
//  Created by 超 韩 on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaobaoUrlSignGenerateUtil : NSObject

+(NSString *)generateByUrl:(NSString *)url;

+(NSString *)dealUrl2TaobaoStyle:(NSString *)orignUrl;
@end
