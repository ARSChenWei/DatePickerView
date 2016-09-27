//
//  CWDatePickerView.m
//  SelfDataPicker
//
//  Created by 陈威 on 16/9/13.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "CWDatePickerView.h"
#import "DatePickerView.h"
#import "NSDate+Extension.h"
#import "Define.h"

#define MINTIME @"2008-05-25 12:00"
#define MAXTIME @"2018-05-25 12:00"
@interface CWDatePickerView ()
@property(nonatomic,retain)NSDate *startdate;
@property(nonatomic,retain)NSDate *enddate;
@property(nonatomic,retain)NSDate *finalstartdate;
@property(nonatomic,retain)NSDate *finalenddate;
@end

@implementation CWDatePickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]lastObject];
    }
    return self;
}

- (void)createUI
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAction)];
    [self addGestureRecognizer:tap];

    DatePickerView *StartDatePickerView = [[DatePickerView alloc]initWithCompleteBlock:^(NSDate *lastDate) {
        NSLog(@"\n最后选择的时间是:%@",lastDate);
        self.startdate = lastDate;
    }];
    StartDatePickerView.frame = CGRectMake((SCREEN_WIDTH-300)/2, 50, 300, 150);
    StartDatePickerView.datePickerStyle = 0;
    StartDatePickerView.dateType = DateTypeStartDate;
    StartDatePickerView.minLimitDate = [NSDate date:MINTIME WithFormat:DATEFORM];
    StartDatePickerView.maxLimitDate = [NSDate date:MAXTIME WithFormat:DATEFORM];
    StartDatePickerView.defaultDate = [NSDate date:self.starttimestr WithFormat:DATEFORM];
    [self addSubview:StartDatePickerView];
    
    
    DatePickerView *EndDatePickerView = [[DatePickerView alloc]initWithCompleteBlock:^(NSDate *lastDate) {
        self.enddate = lastDate;
        NSLog(@"\n最后选择的时间是:%@",lastDate);
    }];
    EndDatePickerView.frame = CGRectMake((SCREEN_WIDTH-300)/2, StartDatePickerView.frame.size.height+StartDatePickerView.frame.origin.y+50, 300, 150);
    EndDatePickerView.datePickerStyle = 0;
    EndDatePickerView.dateType = DateTypeStartDate;
    EndDatePickerView.minLimitDate = [NSDate date:MINTIME WithFormat:DATEFORM];
    EndDatePickerView.maxLimitDate = [NSDate date:MAXTIME WithFormat:DATEFORM];
//    EndDatePickerView.maxLimitDate = [NSDate date];
    EndDatePickerView.defaultDate = [NSDate date:self.endtimestr WithFormat:DATEFORM];
    [self addSubview:EndDatePickerView];
    
    self.DoneButton.frame = CGRectMake((SCREEN_WIDTH-300)/2, EndDatePickerView.frame.size.height+EndDatePickerView.frame.origin.y+40, 300, 30);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self createUI];
}

- (IBAction)DoneButtonClick:(UIButton *)sender {
    
    NSLog(@"确认最后要传出去的时间是开始时间是:%@,结束时间是:%@",self.startdate,self.enddate);
    if (self.startdate) {
        NSLog(@"选了start");
        self.finalstartdate = self.startdate;
    }else{
        NSLog(@"没选start");
        self.finalstartdate = [NSDate date:self.starttimestr WithFormat:DATEFORM];
    }
    
    if (self.enddate) {
        NSLog(@"选了end");
        self.finalenddate = self.enddate;
    }else{
        NSLog(@"没选end");
        self.finalenddate = [NSDate date:self.endtimestr WithFormat:DATEFORM];
    }
    
    //判断是否结束日期大于开始
    if ([self.finalstartdate compare:self.finalenddate]==NSOrderedAscending) {
        [self hiddenAction];
        [self.delegate DeliverystartDate:self.finalstartdate theendDate:self.finalenddate];
    }else{
        NSLog(@"开始时间不能大于结束时间");
    }
}

- (void)hiddenAction
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

@end
