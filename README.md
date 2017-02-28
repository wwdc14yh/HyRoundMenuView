---
#HyRoundMenuView
-------------

![image](https://github.com/wwdc14/HyRoundMenuView/blob/master/HyRoundMenuViewDemo/3ip.png)

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
             )](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)](https://developer.apple.com/Objective-C)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
> 关于**HyRoundMenuView**灵感来自于[JZMultiChoicesCircleButton](https://github.com/JustinFincher/JZMultiChoicesCircleButton)
### 目录:
* [示例](#Examples)
* [如何使用本项目](#How to use this project)
* [HyRoundMenuView公有方法以及属性说明](#Public method and attribute description)
* [HyRoundMenuModel公有方法以及属性说明](#Public method and attribute description d)

## <a id="Examples"></a>Examples
### 示例: 
![image](https://github.com/wwdc14/HyRoundMenuView/blob/master/HyRoundMenuViewDemo/Unknown.gif)

## <a id="How to use this project"></a>How to use this project
### 如何使用本项目？
- step 1 -> 初始化
```obj
_menuView = [HyRoundMenuView shareInstance];
```
- step 2 -> 填充数据源
```obj
    _data = @[
              [HyRoundMenuModel title:@"FaceBook"
                            iconImage:[UIImage imageNamed:@"ICON_SNS_facebook"]
                       transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
              
              [HyRoundMenuModel title:@"Link"
                            iconImage:[UIImage imageNamed:@"ICON_SNS_Link"]
                       transitionType:HyRoundMenuModelTransitionTypeNormal],
             
              [HyRoundMenuModel title:@"微信朋友圈"
                            iconImage:[UIImage imageNamed:@"ICON_SNS_Moment"]
                       transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
             
              [HyRoundMenuModel title:@"QQ"
                            iconImage:[UIImage imageNamed:@"ICON_SNS_QQ"]
                       transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
             
              [HyRoundMenuModel title:@"Twitter"
                            iconImage:[UIImage imageNamed:@"ICON_SNS_twitter"]
                       transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
             
              [HyRoundMenuModel title:@"微信"
                            iconImage:[UIImage imageNamed:@"ICON_SNS_Wechat"]
                       transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],

              [HyRoundMenuModel title:@"微博"
                            iconImage:[UIImage imageNamed:@"ICON_SNS_Weibo"]
                       transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge]
             ].mutableCopy;
```
- step 3 -> 自定义圆点图片等等...

```obj
HyRoundMenuModel *centerModel = [HyRoundMenuModel title:@"What you want to do?" iconImage:[UIImage imageNamed:@"SendRound"] transitionType:HyRoundMenuModelTransitionTypeNormal];
```
* 自定义圆点必须设置model的type属性为HyRoundMenuModelItmeTypeCenter，且只能有一个。
```obj
centerModel.type = HyRoundMenuModelItmeTypeCenter;
[_data addObject:centerModel];
```
* 设置好以上属性后add到数据源 
* 最后赋值到`_menuView.dataSources`里
```obj
_menuView.dataSources = _data;
```
* done (更多属性设置请参考demo)

## <a id="Public method and attribute description"></a>HyRoundMenuView public method and attribute description
### HyRoundMenuView公有方法以及属性说明:  
- 允许拖拽按钮 默认为->`YES`

```obj
@property (nonatomic, assign) BOOL allowDrag;
```

- 允许按钮吸附在屏幕边缘 默认为->`YES`
```obj
@property (nonatomic, assign) BOOL allowAdsorption
```

- 允许拖拽按钮选择itme时产生3D效果
```obj
@property (nonatomic, assign) BOOL allowEffect3D;
```

`HyRoundMenuView`Delegate
```obj
@property (nonatomic, weak,  nullable) id<HyRoundMenuViewDelegate> delegate;
``` 
- 动画类型
```obj
@property (nonatomic, assign) HyRoundMenuViewAnimationType animationType;
```

- bigRadius/smallRadius 必须等于4

- Bezier的大小必须和smallRadius*2的大小一样   

- 建议用【PaintCode】来画想要的图形
```obj
@property (nonatomic, nullable, weak) UIBezierPath *customBigShapeBezierPath
```

- 小圆按钮半径
```obj
@property (nonatomic, assign) CGFloat smallRadius
```
- 大圆按钮半径
```obj
@property (nonatomic, assign) CGFloat bigRadius;
```
- 形状颜色
```obj
@property (nonatomic, copy  , nonnull) UIColor *shapeColor;
```

- 模糊风格
```obj
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle
```
- 背景视图类型
```obj
@property (nonatomic, assign) HyRoundMenuViewBackgroundViewType backgroundViewType
```

- 初始化方法
```obj
+(__nonnull instancetype) shareInstance
```
## <a id="Public method and attribute description d"></a>HyRoundMenuModel public method and attribute description
### HyRoundMenuModel公有方法以及属性说明:  

- `model`标题
```obj
@property (nonatomic, strong, nonnull) NSString *title
```

- 设置图标
```obj
@property (nonatomic, strong, nonnull) UIImage *iconImage
```

- 该属性默认为`HyRoundMenuModelItmeTypeDefault`
```obj
@property (nonatomic, assign,        ) HyRoundMenuModelItmeType type
```

- 转场方式类型
```obj
@property (nonatomic, assign,        ) HyRoundMenuModelTransitionType transitionType
```

- 类方法快速生成对象
```obj
+ (__nonnull instancetype)title:(NSString * __nonnull)title
                      iconImage:(UIImage * __nonnull)image
                 transitionType:(HyRoundMenuModelTransitionType)transitionType
```
