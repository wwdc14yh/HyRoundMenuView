//
//  OverheadView.m
//  Test_Circle_Arranged
//
//  Created by 胡毅 on 17/2/25.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "OverheadView.h"

@implementation OverheadView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    id obj = [super hitTest:point withEvent:event];
    if ([obj isKindOfClass:NSClassFromString(@"HyMenuButton")] || [obj isKindOfClass:NSClassFromString(@"HyRoundMenuItme")]) {
        return obj;
    }
    if ([obj isKindOfClass:NSClassFromString(@"HyRoundMenuView")]) {
        id tag = [obj valueForKey:@"menuButton"];
        BOOL isOpen = [tag valueForKey:@"isOpen"];
        if (isOpen) {
            return obj;
        }
    }
    return nil;
}

@end
