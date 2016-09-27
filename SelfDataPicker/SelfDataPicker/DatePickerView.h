//
//  DatePickerView.h
//  SelfDataPicker
//
//  Created by 陈威 on 16/9/8.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    DateStyleShowYearMonthDayHourMinute = 0,
    DateStyleShowMonthDayHourMinute = 1,
    DateStyleShowYearMonthDay = 2,
    DateStyleShowMonthDay = 3,
    DateStyleShowHourMinute = 4
} DateStyle;

typedef enum {
    DateTypeStartDate,
    DateTypeEndDate
} DateType;

@interface DatePickerView : UIView

@property(nonatomic,assign)DateType dateType;
@property(nonatomic,assign)DateStyle datePickerStyle;
@property(nonatomic,retain)NSDate *maxLimitDate;//限制最大时间（没有设置默认2049
@property(nonatomic,retain)NSDate *minLimitDate;//限制最小时间（没有设置默认1970）
@property(nonatomic,retain)NSDate *defaultDate;//默认显示时间
- (instancetype)initWithCompleteBlock:(void(^)(NSDate *))completeBlock;
@end
