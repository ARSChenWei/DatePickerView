//
//  CWLayout.m
//  CameraAlone
//
//  Created by 陈威 on 16/5/5.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "CWLayout.h"

@implementation CWLayout

-(id)init
{
    self = [super init];
    if (self)
    {
        self.itemSize = CGSizeMake(100, 100);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 10;
    }
    return self;
}

@end
