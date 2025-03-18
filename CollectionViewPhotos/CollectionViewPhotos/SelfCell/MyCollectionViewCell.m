
//
//  MyCollectionViewCell.m
//  CameraAlone
//
//  Created by 陈威 on 16/5/6.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.Button.layer.masksToBounds = YES;
}

- (IBAction)ButtonClick:(id)sender {

    [self.delegate GetValue:self];
}
@end
