//
//  NSDate+DynamicDateString.h
//  Color
//
//  Created by chao han on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DynamicDateString)
//倒计时式的显示方式。距离现在还剩X小时，X天，X周，X月。最大单位为月
//maxSecs:最大秒数
//replaceStr:大于等于最大秒数时，用来替换的字符串
//perfixStr:前缀
-(NSString *)distanceFromNowMaxSeconds:(NSInteger) maxSecs RelpaceStr:(NSString *)replaceStr
                             perfixStr:(NSString *)perfixStr;

-(NSString *)getDynamicDateStringFromNow;//将该时间转换为星期，几周后，几月后等string显示

-(BOOL)isSameDay:(NSDate*)date;//判断是否同一天

////输入的日期字符串形如：@"1992-05-21 13:08:08"
//- (NSDate *)dateFromString:(NSString *)dateString;
@end
