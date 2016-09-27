//
//  CWDatePickerView.h
//  SelfDataPicker
//
//  Created by 陈威 on 16/9/13.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeliveryDateDelegate <NSObject>
- (void)DeliverystartDate:(NSDate *)startdate theendDate:(NSDate *)enddate;
@end

@interface CWDatePickerView : UIView

@property(nonatomic,copy)NSString *starttimestr;
@property(nonatomic,copy)NSString *endtimestr;
@property (weak, nonatomic) IBOutlet UIButton *DoneButton;
@property(nonatomic,weak)id<DeliveryDateDelegate>delegate;
@end
