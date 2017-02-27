//
//  HyRoundMenuModel.m
//  Test_Circle_Arranged
//
//  Created by 胡毅 on 17/2/25.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "HyRoundMenuModel.h"

@implementation HyRoundMenuModel

+ (__nonnull instancetype)title:(NSString * __nonnull)title iconImage:(UIImage * __nonnull)image transitionType:(HyRoundMenuModelTransitionType)transitionType
{
    HyRoundMenuModel *model = [HyRoundMenuModel new];
    model.title = title;
    model.iconImage = image;
    model.type = HyRoundMenuModelItmeTypeDefault;
    model.transitionType = transitionType;
    return model;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone{
    HyRoundMenuModel * model = [[HyRoundMenuModel alloc]init];
    model.title = self.title;
    model.iconImage = self.iconImage;
    model.type = self.type;
    model.transitionType = self.transitionType;
    return  model;
}

@end
