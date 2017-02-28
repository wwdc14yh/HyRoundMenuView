---
#HyRoundMenuView
-------------

![image](https://github.com/wwdc14/HyRoundMenuView/blob/master/HyRoundMenuViewDemo/3ip.png)

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
             )](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)](https://developer.apple.com/Objective-C)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
> 关于**HyRoundMenuView**灵感来自于[JZMultiChoicesCircleButton](https://github.com/JustinFincher/JZMultiChoicesCircleButton)

####示例:  </b>
![image](https://github.com/wwdc14/HyRoundMenuView/blob/master/HyRoundMenuViewDemo/Unknown.gif)

####HyRoundMenuView公有方法以及属性说明:  </b>
允许拖拽按钮 默认为->`YES`
`@property (nonatomic, assign) BOOL allowDrag;`
允许按钮吸附在屏幕边缘 默认为->`YES`
`@property (nonatomic, assign) BOOL allowAdsorption`;
允许拖拽按钮选择itme时产生3D效果
`@property (nonatomic, assign) BOOL allowEffect3D;`
`HyRoundMenuView`Delegate
`@property (nonatomic, weak,  nullable) id<HyRoundMenuViewDelegate> delegate;`
动画类型
`@property (nonatomic, assign) HyRoundMenuViewAnimationType animationType;`
** bigRadius/smallRadius 必须等于4
** Bezier的大小必须和smallRadius*2的大小一样   建议用【PaintCode】来画想要的图形
`@property (nonatomic, nullable, weak) UIBezierPath *customBigShapeBezierPath`
小圆按钮半径
`@property (nonatomic, assign) CGFloat smallRadius`
大圆按钮半径
`@property (nonatomic, assign) CGFloat bigRadius;`
形状颜色
`@property (nonatomic, copy  , nonnull) UIColor *shapeColor;`
模糊风格
`@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle`
背景视图类型
`@property (nonatomic, assign) HyRoundMenuViewBackgroundViewType backgroundViewType`
初始化方法
`+(__nonnull instancetype) shareInstance` 

...
