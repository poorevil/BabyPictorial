//
//  TaobaoUrlSignGenerateUtil.m
//  Tenyuan
//
//  Created by 超 韩 on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaobaoUrlSignGenerateUtil.h"
#import "MySingleton.h"
#import "NSString+MD5.h"
#import "NSString+URLEncoding.h"

@implementation TaobaoUrlSignGenerateUtil

+(NSString *)generateByUrl:(NSString *)url
{
    if (url && [url hasPrefix:@"http://"]) {
        NSString *paramString = [url substringFromIndex:[url rangeOfString:@"?"].location+1];
        
        NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
        paramArray = [paramArray sortedArrayUsingComparator:^(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableString *sortedString = [NSMutableString string];
        [sortedString appendString:[MySingleton sharedSingleton].appSecret];
        for (NSString *str in paramArray) {
            [sortedString appendString:[str stringByReplacingOccurrencesOfString:@"="
                                                                      withString:@""]];
        }
        [sortedString appendString:[MySingleton sharedSingleton].appSecret];
        
        NSString *signStr = [sortedString md5HexDigest];
//        NSLog(@"--[%@]----------[%@]",sortedString,signStr);
        return signStr;
    }
    
    return nil;
}

//名称          类型          是否必需            描述
//method      string          Y               API接口名称

//timestamp   string          Y         时间戳，格式为yyyy-mm-dd HH:mm:ss，例如：2008-01-25 20:23:30。淘宝API服务端允许客户端请求时间误差为6分钟。
//format      string          N               可选，指定响应格式。默认xml,目前支持格式为xml,json
//app_key     string          Y               TOP分配给应用的AppKey
//v           string          Y               API协议版本，可选值:2.0。
//sign        string          Y               API输入参数签名结果
//sign_method string          Y               参数的加密方法选择，可选值是：md5,hmac
+(NSString *)dealUrl2TaobaoStyle:(NSString *)orignUrl
{
    if (orignUrl && [orignUrl hasPrefix:@"http://"]) {
        NSMutableString *resultUrl = [NSMutableString string];//结果url
        //截取参数之前的url地址
        [resultUrl appendString:[orignUrl substringToIndex:[orignUrl rangeOfString:@"?"].location+1]];
        
//        //http方式固定参数
//        [resultUrl appendString:[NSString stringWithFormat:@"?v=2.0&format=json&sign_method=md5&app_key=%@&",[MySingleton sharedSingleton].appKey]];
        //获取当前事件
        NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [NSDate date];
        NSString * timestamp = @"2012-09-02 23:55:55";//[dateFormatter stringFromDate:date];
//        [resultUrl appendString:timestamp];

        //拼装http方式固定参数
        NSString *tmpUrl = [NSString stringWithFormat:@"%@&v=2.0&format=json&sign_method=md5&app_key=%@&timestamp=%@"
                            ,orignUrl
                            ,[MySingleton sharedSingleton].appKey
                            ,timestamp];
        
        
        
        NSString *paramString = [tmpUrl substringFromIndex:[tmpUrl rangeOfString:@"?"].location+1];
        //拆解url请求参数
        NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
        paramArray = [paramArray sortedArrayUsingComparator:^(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        //对参数排序
        NSMutableString *sortedString = [NSMutableString string];
        [sortedString appendString:[MySingleton sharedSingleton].appSecret];
        for (NSString *str in paramArray) {
            [resultUrl appendString:[NSString stringWithFormat:@"%@&",[str URLEncodedStringForTaobao]]];
            [sortedString appendString:[str stringByReplacingOccurrencesOfString:@"="
                                                                      withString:@""]];
        }
        [sortedString appendString:[MySingleton sharedSingleton].appSecret];
        //生成md5签名
        NSString *signStr = [sortedString md5HexDigest];

        //拼装最终淘宝风格的url
        [resultUrl appendString:[NSString stringWithFormat:@"sign=%@",signStr]];
//        NSLog(@"-----------[%@]",resultUrl);
        
        
        return resultUrl;
    }
    
    return orignUrl;
}
@end
