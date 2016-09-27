//
//  DatePickerView.m
//  SelfDataPicker
//
//  Created by 陈威 on 16/9/8.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "DatePickerView.h"
#import "NSDate+Extension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPickerSize self.datePicker.frame.size

#define MAXYEAR 2050
#define MINYEAR 1970

typedef void(^doneBlock)(NSDate *);

@interface DatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
{
    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
    
    NSDate *_startDate;
    NSDate *_endDate;
}

@property (weak, nonatomic) IBOutlet UILabel *showYearLabel;
@property(nonatomic,strong)UIPickerView *datePicker;
@property(nonatomic,retain)NSDate *scrollToDate; //滚到指定日期
@property(nonatomic,strong)doneBlock doneBlock;
@end

@implementation DatePickerView
- (instancetype)initWithCompleteBlock:(void (^)(NSDate *))completeBlock
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]lastObject];
        
        [self setupUI];
        [self defaultConfig];
        
        if (completeBlock) {
            self.doneBlock = ^(NSDate *lastDate){
                completeBlock(lastDate);
            };
        }
    }
    return self;
}

- (void)setupUI
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.showYearLabel addSubview:self.datePicker];
}

- (void)defaultConfig
{
    if (!self.scrollToDate) {
        self.scrollToDate = [NSDate date];
    }
    
    //循环滚动的时候需要用到
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    //设置年月日时分的数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i = 0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12){
            [_monthArray addObject:num];
        }
        if (i<24){
            [_hourArray addObject:num];
        }
        [_minuteArray addObject:num];
    }
    
    for (NSInteger i=MINYEAR; i<MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2049-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    if (self.minLimitDate) {
        self.minLimitDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
}

//构建初始的可变数组
- (NSMutableArray *)setArray:(id)mutableArray
{
    if (mutableArray) {
        [mutableArray removeAllObjects];
    }else{
        mutableArray = [NSMutableArray array];
    }
    return mutableArray;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
            break;
        case DateStyleShowYearMonthDay:
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            return 3;
            break;
        case DateStyleShowMonthDayHourMinute:
            [self addLabelWithName:@[@"月",@"日",@"时",@"分"]];
            return 4;
            break;
        case DateStyleShowMonthDay:
            [self addLabelWithName:@[@"月",@"日"]];
            return 2;
            break;
        case DateStyleShowHourMinute:
            [self addLabelWithName:@[@"时",@"分"]];
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (void)addLabelWithName:(NSArray *)nameArr
{
    for (id subView in self.showYearLabel.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i<nameArr.count; i++) {
        CGFloat labelX = kPickerSize.width/(nameArr.count*2)+20+kPickerSize.width/nameArr.count*i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, (self.showYearLabel.frame.size.height-15)/2, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor clearColor];
        [self.showYearLabel addSubview:label];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

- (NSArray *)getNumberOfRowsInComponent
{
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self daysfromYear:[_yearArray[yearIndex]integerValue] andMonth:[_monthArray[monthIndex]integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNum = _minuteArray.count;
    NSInteger timeInterval = MAXYEAR-MINYEAR;
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNum)];
            break;
        case DateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNum)];
            break;
        case DateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case  DateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum)];
            break;
        case DateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNum)];
            break;
        default:
            return @[];
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc]init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:18]];
    }
    NSString *title;
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            if (component == 0) {
                title = _yearArray[row];
            }
            if (component == 1) {
                title = _monthArray[row];
            }
            if (component == 2) {
                title = _dayArray[row];
            }
            if (component == 3) {
                title = _hourArray[row];
            }
            if (component == 4) {
                title = _minuteArray[row];
            }
            break;
            
        case DateStyleShowYearMonthDay:
            if (component == 0) {
                title = _yearArray[row];
            }
            if (component == 1) {
                title = _monthArray[row];
            }
            if (component == 2) {
                title = _dayArray[row];
            }
            break;
        case  DateStyleShowMonthDayHourMinute:
            if (component == 0) {
                title = _monthArray[row%12];
            }
            if (component == 1) {
                title = _dayArray[row];
            }
            if (component == 2) {
                title = _hourArray[row];
            }
            if (component == 3) {
                title = _minuteArray[row];
            }
            break;
        case DateStyleShowMonthDay:
            if (component == 0) {
                title = _monthArray[row%12];
            }
            if (component == 1) {
                title = _dayArray[row];
            }
            break;
        case DateStyleShowHourMinute:
            if (component == 0) {
                title = _hourArray[row];
            }
            if (component == 1) {
                title = _minuteArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    customLabel.textColor = [UIColor blackColor];
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:{
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1) {
                [self daysfromYear:[_yearArray[yearIndex]integerValue] andMonth:[_monthArray[monthIndex]integerValue]];
                if (_dayArray.count-1 < dayIndex) {
                    dayIndex = _dayArray.count -1;
                }
            }
        }
            break;
        case DateStyleShowYearMonthDay:{
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1) {
                [self daysfromYear:[_yearArray[yearIndex]integerValue] andMonth:[_monthArray[monthIndex]integerValue]];
                if (_dayArray.count - 1<dayIndex) {
                    dayIndex = _dayArray.count - 1;
                }
            }
        }
            break;
        case DateStyleShowMonthDayHourMinute:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                if (_dayArray.count - 1 <dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self daysfromYear:[_yearArray[yearIndex]integerValue] andMonth:[_monthArray[monthIndex]integerValue]];
        }
            break;
        case DateStyleShowMonthDay:
        {
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count - 1;
                }
            }
            [self daysfromYear:[_yearArray[yearIndex]integerValue] andMonth:[_monthArray[monthIndex]integerValue]];
        }
            break;
        case DateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
            break;
        }
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
    self.scrollToDate = [NSDate date:dateStr WithFormat:@"yyyy-MM-dd HH:mm"];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    
    switch (self.dateType) {
        case DateTypeStartDate:
            _startDate = self.scrollToDate;
            break;
            
        default:
            _endDate = self.scrollToDate;
            break;
    }
    NSLog(@"~~~~~~~~~~最后选择的时间是%@",self.scrollToDate);
    self.doneBlock(self.scrollToDate);
}

- (void)yearChange:(NSInteger)row
{
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow<12 && row-preRow>0 && [_monthArray[monthIndex]integerValue]<[_monthArray[preRow%12] integerValue]) {
        yearIndex++;
    }else if (preRow-row <12 && preRow-row >0 && [_monthArray[monthIndex]integerValue]>[_monthArray[preRow%12]integerValue]){
        yearIndex--;
    }else{
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    preRow = row;
}

#pragma mark - tools
//通过年月求每月天数
- (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year = year;
    NSInteger num_month = month;
    
    BOOL leapyear = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (leapyear) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i = 1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    [self daysfromYear:date.year andMonth:date.month];
    
    yearIndex = date.year-MINYEAR;
    monthIndex = date.month-1;
    dayIndex = date.day-1;
    hourIndex = date.hour;
    minuteIndex = date.minute;
    
    //循环滚动的时候需要用到
    preRow = (self.scrollToDate.year - MINYEAR)*12+self.scrollToDate.month-1;
    NSArray *indexArray;
    if (self.datePickerStyle == DateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == DateStyleShowYearMonthDay)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == DateStyleShowMonthDayHourMinute)
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == DateStyleShowMonthDay)
        indexArray = @[@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == DateStyleShowHourMinute)
        indexArray = @[@(hourIndex),@(minuteIndex)];
    
    
    for (int i = 0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == DateStyleShowMonthDayHourMinute || self.datePickerStyle == DateStyleShowMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year-MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        }else{
            [self.datePicker reloadAllComponents];
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
    }
}

#pragma  mark - getter/setter
- (UIPickerView *)datePicker
{
    if (!_datePicker) {
        [self.showYearLabel layoutIfNeeded];
        _datePicker = [[UIPickerView alloc]initWithFrame:self.showYearLabel.bounds];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (void)setMinLimitDate:(NSDate *)minLimitDate
{
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}

- (void)setDatePickerStyle:(DateStyle)datePickerStyle
{
    _datePickerStyle = datePickerStyle;
    if (datePickerStyle == DateStyleShowMonthDayHourMinute || datePickerStyle == DateStyleShowMonthDay) {
        if (datePickerStyle == DateStyleShowMonthDay) {
        }
    }else{
    }
    [self.datePicker reloadAllComponents];
}

- (void)setDefaultDate:(NSDate *)defaultDate
{
    _defaultDate = defaultDate;
    [self getNowDate:_defaultDate animated:NO];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
