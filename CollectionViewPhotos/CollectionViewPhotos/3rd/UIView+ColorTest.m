//
//  UIView+ColorTest.m
//  Queue
//
//  Created by 陈威 on 16/3/2.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "UIView+ColorTest.h"

@implementation UIView (ColorTest)
//不能写成borderColor = _borderColor;否则编译器马上报错（@dynamic自己实现get与set方法）
@dynamic borderColor,borderWidth,cornerRadius;

-(void)setBorderColor:(UIColor *)borderColor
{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
}
@end
