//
//  HyRoundMenuItme.m
//  Test_Circle_Arranged
//
//  Created by 胡毅 on 17/2/25.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "HyRoundMenuItme.h"

@implementation HyRoundMenuItme



- (void)setModel:(HyRoundMenuModel *)model
{
    self.contentMode = UIViewContentModeCenter;
    _model = model;
    self.image = (id)model.iconImage;
    //[self setImage:model.iconImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
