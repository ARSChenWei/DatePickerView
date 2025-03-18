//
//  MyCollectionViewCell.h
//  CameraAlone
//
//  Created by 陈威 on 16/5/6.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCollectionViewCell;
@protocol CellDelegate <NSObject>
//该协议方法，用来实现进行传值
-(void)GetValue:(MyCollectionViewCell *)cell;
@end

@interface MyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *Button;

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property(nonatomic,strong)id<CellDelegate>delegate;

- (IBAction)ButtonClick:(id)sender;

@end
