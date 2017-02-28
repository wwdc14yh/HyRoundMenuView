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
允许拖拽按钮 默认为->`YES`\<br> 

`@property (nonatomic, assign) BOOL allowDrag;`</b>
允许按钮吸附在屏幕边缘 默认为->`YES`</b>

`@property (nonatomic, assign) BOOL allowAdsorption`;</b>
允许拖拽按钮选择itme时产生3D效果</b>

`@property (nonatomic, assign) BOOL allowEffect3D;`</b>
`HyRoundMenuView`Delegate</b>

`@property (nonatomic, weak,  nullable) id<HyRoundMenuViewDelegate> delegate;`</b>
动画类型</b>

`@property (nonatomic, assign) HyRoundMenuViewAnimationType animationType;`</b>
** bigRadius/smallRadius 必须等于4</b>

** Bezier的大小必须和smallRadius*2的大小一样   建议用【PaintCode】来画想要的图形</b>

`@property (nonatomic, nullable, weak) UIBezierPath *customBigShapeBezierPath`</b>
小圆按钮半径</b>

`@property (nonatomic, assign) CGFloat smallRadius`</b>
大圆按钮半径</b>
`@property (nonatomic, assign) CGFloat bigRadius;`</b>
形状颜色</b>

`@property (nonatomic, copy  , nonnull) UIColor *shapeColor;`</b>
模糊风格</b>

`@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle`</b>
背景视图类型</b>

`@property (nonatomic, assign) HyRoundMenuViewBackgroundViewType backgroundViewType`</b>
初始化方法</b>

`+(__nonnull instancetype) shareInstance` </b>

...</b>
