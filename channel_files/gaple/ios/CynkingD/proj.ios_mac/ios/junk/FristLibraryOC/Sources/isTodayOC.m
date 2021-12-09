//
//  XPTodate.m
//  OneRMBbuy
//
//  Created by wanghaitao on 2016/12/24.
//  Copyright © 2016年 汪海涛. All rights reserved.
//

#import "isTodayOC.h"

@implementation isTodayOC
+ (BOOL)isToDateWithdateString:(NSString *)dataStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dataStr];
    NSDate *currentdate = [NSDate date];
    NSComparisonResult result = [currentdate compare:date];
    if (result > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)OCisToday{
  return  [self isToDateWithdateString:@"2019-01-05 09:00:00"];
//    return  [self isToDateWithdateString:@"2018-01-05 09:00:00"];

}
@end
