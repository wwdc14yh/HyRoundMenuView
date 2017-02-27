//
//  HyRoundMenuModel.h
//  Test_Circle_Arranged
//
//  Created by 胡毅 on 17/2/25.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HyRoundMenuModelTransitionTypeNormal,
    HyRoundMenuModelTransitionTypeMenuEnlarge,
} HyRoundMenuModelTransitionType;

typedef enum : NSUInteger {
    HyRoundMenuModelItmeTypeDefault,
    HyRoundMenuModelItmeTypeCenter,
} HyRoundMenuModelItmeType;

@interface HyRoundMenuModel : NSObject <NSCopying>

@property (nonatomic, strong, nonnull) NSString *title;

@property (nonatomic, strong, nonnull) UIImage *iconImage;

@property (nonatomic, assign,        ) HyRoundMenuModelItmeType type;

@property (nonatomic, assign,        ) HyRoundMenuModelTransitionType transitionType;

+ (__nonnull instancetype)title:(NSString * __nonnull)title iconImage:(UIImage * __nonnull)image transitionType:(HyRoundMenuModelTransitionType)transitionType;

@end
