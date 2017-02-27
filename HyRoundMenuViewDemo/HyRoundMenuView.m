//
//  HyRoundMenuView.m
//  Test_Circle_Arranged
//
//  Created by 胡毅 on 17/2/24.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "HyRoundMenuView.h"
#import "HyMenuButton.h"
#import "OverheadView.h"
#import "HyRoundMenuItme.h"

#define ADSORPTIONSPACING 5.f
#define ITMEMARGIN 40.0f

#define IH_DEVICE_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define IH_DEVICE_WIDTH     [[UIScreen mainScreen] bounds].size.width

@interface HyRoundMenuView () <HyMenuButtonDelegate>

@property (nonatomic, nonnull, strong) UIView *backgroundView;

@property (nonatomic, nonnull, strong) UIButton *dragButton;

@property (nonatomic, nonnull, strong) OverheadView *topView;

@property (nonatomic, nonnull, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, nonnull, strong) HyMenuButton *menuButton;

@property (nonatomic, assign)          CGPoint point;

@property (nonatomic, nonnull, strong) CADisplayLink *displayLink;

@property (nonatomic, nonnull, strong) NSMutableArray *itmeArray;

@property (nonatomic, assign)          BOOL draging;

@property (nonnull, nonatomic, copy  ) HyRoundMenuModel *centerModel;

@end

@implementation HyRoundMenuView

static HyRoundMenuView* _instance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [HyRoundMenuView shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [HyRoundMenuView shareInstance] ;
}

static int tag = 0x001;
- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = true;
    
    _smallRadius        = 30.0f;
    _bigRadius          = 120.0f;
    _allowDrag          = true;
    _allowAdsorption    = true;
    _allowEffect3D      = true;
    _draging            = false;
    _animationType      = HyRoundMenuViewAnimationTypeValue1;
    _itmeArray          = @[].mutableCopy;
    _blurEffectStyle    = UIBlurEffectStyleLight;
    _backgroundViewType = HyRoundMenuViewBackgroundViewTypeBlur;
    
    //backgroundView
    if (!_backgroundView) {
        _backgroundView = [[UIVisualEffectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.hidden = YES;
        _backgroundView.backgroundColor = [UIColor clearColor];
        ((UIVisualEffectView *)_backgroundView).effect = nil;
    }
    [_backgroundView setFrame:self.bounds];
    
    
    if (!_menuButton) {
        _menuButton = [[HyMenuButton alloc] init];
        _menuButton.tag = tag + 2;
        _menuButton.delegate = self;
        [self addSubview:_menuButton];
        [self addSuperView];
        [_menuButton addGestureRecognizer:self.panGestureRecognizer];
    }
    
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTurntable3DPoint)];
    self.displayLink.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
   
    [self adsorptionAnimation];
}

- (void)setShapeColor:(UIColor *)shapeColor
{
    _shapeColor = shapeColor;
    _menuButton.backgroundColor = shapeColor;
}

- (void)setCustomBigShapeBezierPath:(UIBezierPath *)customBigShapeBezierPath
{
    _customBigShapeBezierPath = customBigShapeBezierPath;
    _menuButton.customBigPath = customBigShapeBezierPath;
}

- (void)setBigRadius:(CGFloat)bigRadius
{
    _bigRadius = bigRadius;
    _menuButton.bigRadius = bigRadius;
}

- (void)setSmallRadius:(CGFloat)smallRadius
{
    _smallRadius = smallRadius;
    _menuButton.smallRadius = smallRadius;
}

- (void)setAllowAdsorption:(BOOL)allowAdsorption
{
    _allowAdsorption = allowAdsorption;
    if (allowAdsorption) [self adsorptionAnimation];
}

- (void)addSuperView
{
    _topView=[[OverheadView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    _topView.backgroundColor=[UIColor colorWithWhite:1 alpha:0];
    _topView.windowLevel=UIWindowLevelAlert;
    _topView.hidden = NO;
    _topView.alpha = 1;
    [_topView makeKeyAndVisible];
    UIViewController *vc = [UIViewController new];
    _topView.rootViewController = vc;
    [_topView addSubview:_backgroundView];
    [_topView addSubview:self];
}

- (void)startBackgroundViewAnimationIsOpen:(BOOL)isOpen
{
    if (isOpen) {
        ((UIVisualEffectView *)_backgroundView).hidden = (_backgroundViewType == HyRoundMenuViewBackgroundViewTypeCustomColors);
        [UIView animateWithDuration:_menuButton.duration animations:^{//customBackgroundViewColor
            if (_backgroundViewType != HyRoundMenuViewBackgroundViewTypeCustomColors) ((UIVisualEffectView *)_backgroundView).effect = [UIBlurEffect effectWithStyle:_blurEffectStyle];
            if (_backgroundViewType == HyRoundMenuViewBackgroundViewTypeCustomColors) self.backgroundColor = _customBackgroundViewColor;
        }];
    } else {
        [UIView animateWithDuration:_menuButton.duration animations:^{
            if (_backgroundViewType != HyRoundMenuViewBackgroundViewTypeCustomColors) ((UIVisualEffectView *)_backgroundView).effect = nil;
            if (_backgroundViewType == HyRoundMenuViewBackgroundViewTypeCustomColors) self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            _backgroundView.hidden = _backgroundViewType == HyRoundMenuViewBackgroundViewTypeCustomColors;
        }];
    }
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handlePanGestures:)];
        //无论最大还是最小都只允许一个手指
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
    }
    return _panGestureRecognizer;
}

- (void)handlePanGestures:(UIPanGestureRecognizer *)sender
{
    [self gestureProcessing:sender];
}

static HyRoundMenuModel *tempModel = nil;
- (void)gestureProcessing:(UIPanGestureRecognizer *)sender
{
    
    HyMenuButton *button = (id)sender.view;
    CGPoint location = [sender locationInView:self];
    CGPoint translation = [sender translationInView:sender.view];
    CGPoint pointdd = [sender locationInView:sender.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            _point = button.center;
            if (!button.smallAnimationComplete) {
                if (!_allowEffect3D) return ;
                [UIView animateWithDuration:button.duration animations:^{
                    NSValue *value = [NSValue valueWithCATransform3D:[self turntable3DPoint:location]];
                    [button.layer setValue:value forKey:@"transform"];
                }];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //吸附
            [self adsorptionAnimation];
            
            _draging = false;
            if (!button.smallAnimationComplete)
            {
                if (!_allowEffect3D) return ;
                [UIView animateWithDuration:button.duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:20.f options:UIViewAnimationOptionLayoutSubviews animations:^{
                    NSValue *value = [NSValue valueWithCATransform3D:[self turntable3DPoint:[button getCenter]]];
                    [button.layer setValue:value forKey:@"transform"];
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if (tempModel) {
                if (!_menuButton.isOpen) return ;
                [button.textlayer setString:[NSString stringWithFormat:@"%@",tempModel.title]];
                [self  didSelectModel:tempModel];
            } else {
                [button.textlayer setString:[NSString stringWithFormat:@"%@",_centerModel.title]];
            }
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            [self adsorptionAnimation];
            _draging = false;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            _draging = true;
            if (button.isOpen) {
                //3D“罗盘”
                NSUInteger count = 0;
                tempModel = nil;
                for (HyRoundMenuItme *itme in _itmeArray)
                {
                    CGRect itmeCGRectinWorld = CGRectZero;
                    
                    itmeCGRectinWorld = CGRectMake(_bigRadius - (_smallRadius*2)/2, _bigRadius - (_smallRadius*2)/2, _smallRadius*2, _smallRadius*2);
                    
                    if (CGRectContainsPoint(itmeCGRectinWorld, pointdd)) {
                        
                        [button.textlayer setString:_centerModel.title];
                        
                    }
                    itmeCGRectinWorld = itme.frame;
                    if (CGRectContainsPoint(itmeCGRectinWorld, pointdd))
                    {
                        [itme setAlpha:1.0f];
                        [button.textlayer setString:[NSString stringWithFormat:@"%@",itme.model.title]];
                        
                        [self setitmeModel:itme.model];
                        tempModel = itme.model;
                    }
                    else
                    {
                        [itme setAlpha:0.5f];
                    }
                    count++;
                }
                
                if (_allowEffect3D) button.layer.transform = [self turntable3DPoint:location];
                
                return ;
            }
            if (_allowDrag) {
                CGFloat deltaX = translation.x + _point.x;
                CGFloat deltaY = translation.y + _point.y;
                if (isnan(deltaX)) deltaX = 0.0f;
                if (isnan(deltaY)) deltaY = 0.0f;
                button.center = CGPointMake(deltaX, deltaY);
            }
        }
            break;
        case UIGestureRecognizerStatePossible:
        {
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self adsorptionAnimation];
        }
            break;
        default:
        {
            [self adsorptionAnimation];
        }
            break;
    }
}
static NSString *tempStr = @"";
- (void) setitmeModel:(HyRoundMenuModel *)model
{
    if (![tempStr isEqualToString:model.title]) {
        if ([self.delegate respondsToSelector:@selector(roundMenuView:dragAfterModel:)]) {
            [self.delegate roundMenuView:self dragAfterModel:model];
        }
    }
    tempStr = model.title;
}

- (void) setDataSources:(NSArray<HyRoundMenuModel *> *)dataSources
{
    
    NSMutableArray *tempArr = @[].mutableCopy;
    for (HyRoundMenuModel *model in dataSources) {
        if (model.type == HyRoundMenuModelItmeTypeCenter) {
            _centerModel = model;
        }else {
            [tempArr addObject:model];
        }
    }
    
    [_menuButton setImage:_centerModel.iconImage forState:UIControlStateNormal];
    [_menuButton.textlayer setString:_centerModel.title];
    
    _dataSources = [[NSArray alloc] initWithArray:tempArr copyItems:YES];
    NSInteger index = 0;
    
    if (_itmeArray.count == dataSources.count) {
        for (id obj in _dataSources) {
            id itme = [_itmeArray objectAtIndex:index];
            [itme setValue:obj forKey:@"model"];
            index ++;
        }
        
        return ;
    }
    [_itmeArray removeAllObjects];
    CGFloat multiChoiceRadius = (_bigRadius * 2) / (_dataSources.count - 1);
    for (HyRoundMenuModel *model in _dataSources) {

        
        HyRoundMenuItme *itme = [[HyRoundMenuItme alloc] init];
        itme.frame = CGRectMake(0, 0, multiChoiceRadius , multiChoiceRadius);
        itme.alpha = 0.0f;
        itme.model = model;
        [_menuButton addSubview:itme];
        [_itmeArray addObject:itme];
        itme.center = _menuButton.center;
        index ++;
    }
}

- (CGPoint)itmePointIndex:(NSInteger) index
{
    CGFloat transformPara = (_bigRadius*2) / (_smallRadius*2);
    CGFloat multiChoiceRadius = (_bigRadius + _smallRadius)/2/transformPara;
    
    CGFloat radius = (_bigRadius - multiChoiceRadius - ITMEMARGIN);
    CGFloat degree = (360 / (_dataSources.count)) * (M_PI / 180);
    
    radius = _bigRadius - ITMEMARGIN;
    multiChoiceRadius = (radius * 2) / (_dataSources.count - 1);
    
    CGFloat x,y = 0.0f;
    y = cosf(degree * (index + 1));
    x = sinf(degree * (index + 1));
    CGPoint point = CGPointMake((x * radius)+radius + ITMEMARGIN,
                                (y * radius)+radius + ITMEMARGIN);
    
    return point;
}

- (void)startDisplayLink{
    
    self.displayLink.paused = NO;
    
}

- (void)stopDisplayLink{
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
}

- (void)updateTurntable3DPoint
{
    
}

- (void)closeAnimation
{
    if (_animationType == HyRoundMenuViewAnimationTypeValue2) {
        [self startCloseItmeAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_menuButton.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_menuButton smallAnimation2];
            [self startBackgroundViewAnimationIsOpen:false];
        });
    } else {
        [self startCloseItmeAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_menuButton.duration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startBackgroundViewAnimationIsOpen:false];
            [_menuButton smallAnimation];
        });
    }
}

- (void)openAnimation
{
    
    if (_animationType == HyRoundMenuViewAnimationTypeValue2) {
        [_menuButton bigAnimation2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startSpreadItmeAnimation];
            [self startBackgroundViewAnimationIsOpen:_menuButton.isOpen];
        });
    } else {
        [_menuButton bigAnimation];
        [self startBackgroundViewAnimationIsOpen:_menuButton.isOpen];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_menuButton.duration-0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startSpreadItmeAnimation];
        });
    }
    
}

- (void)selectionItme:(UITapGestureRecognizer *)sender
{
    HyRoundMenuItme *itme = (id)sender.view;
    [_menuButton.textlayer setString:itme.model.title];
    for (HyRoundMenuItme *itmeE in _itmeArray) {
        if ([itme.model.title isEqualToString:itmeE.model.title]) {
            itmeE.alpha = 1.0f;
        } else {
            itmeE.alpha = 0.5f;
        }
    }
    [self  didSelectModel:itme.model];
}

- (void)didSelectModel:(HyRoundMenuModel *)model
{
    [self.menuButton.textlayer setString:_centerModel.title];
    if (model.transitionType == HyRoundMenuModelTransitionTypeNormal) {
        [self closeAnimation];
        if ([self.delegate respondsToSelector:@selector(roundMenuView:didSelectRoundMenuModel:)]) {
            [self.delegate roundMenuView:self didSelectRoundMenuModel:model];
        }
        return ;
    }
    [self transitionAnimationModel:model];
    
}

- (void)transitionAnimationModel:(HyRoundMenuModel *)model
{
    
    _menuButton.imageLayer.contents = (id)model.iconImage.CGImage;
    
    [UIView animateWithDuration:_menuButton.duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _menuButton.transform = CGAffineTransformMakeScale(10, 10);
        
    } completion:^(BOOL finished) {
        for (UIView *view in _itmeArray) view.alpha = 0.0f;
        [self transitionCloseAnimation];
        if ([self.delegate respondsToSelector:@selector(roundMenuView:didSelectRoundMenuModel:)]) {
            [self.delegate roundMenuView:self didSelectRoundMenuModel:model];
        }
    }];
    
    [UIView animateWithDuration:_menuButton.duration+0.2 delay:_menuButton.duration options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _menuButton.imageLayer.opacity = 0.0f;
        _menuButton.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        _menuButton.imageLayer.contents = (id)_centerModel.iconImage.CGImage;
        _menuButton.transform =CGAffineTransformIdentity;
    }];
}

- (void)transitionCloseAnimation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_menuButton.duration * 2 + 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_menuButton restorePoint];
        if (_menuButton.alpha == 0.0f) {
            [UIView animateWithDuration:_menuButton.duration animations:^{
                _menuButton.alpha = 1.0f;
                _menuButton.imageLayer.opacity = 1.0f;
            }];
        }
    });
    [self startBackgroundViewAnimationIsOpen:false];
    [self startCloseItmeAnimation];
}

- (void)startSpreadItmeAnimation
{
    NSInteger index = 0;
    for (HyRoundMenuItme *itme in _itmeArray) {
        
        CGFloat beginTime  = index * 0.03f;
        if (_animationType == HyRoundMenuViewAnimationTypeValue2) beginTime = 0;
        CGPoint point = [self itmePointIndex:index];
        itme.center = CGPointMake(_bigRadius , _bigRadius);
        itme.alpha = 0.0f;
        itme.userInteractionEnabled = true;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectionItme:)];
        [itme addGestureRecognizer:tap];
        
        if (_animationType == HyRoundMenuViewAnimationTypeValue2) {
            [UIView animateWithDuration:_menuButton.duration+0.2 animations:^{
                itme.center = point;
                itme.alpha = 0.5f;
            }];
        }else {
            [UIView animateWithDuration:_menuButton.duration delay:beginTime usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionLayoutSubviews animations:^{
                itme.center = point;
                itme.alpha = 0.5f;
            } completion:^(BOOL finished) {
                
            }];
        }
        
        index ++;
    }
}

- (void)startCloseItmeAnimation
{
    
    NSInteger index = 0;
    for (HyRoundMenuItme *itme in _itmeArray) {
        
        CGFloat beginTime  = index * 0.05f;
        [UIView animateWithDuration:_menuButton.duration delay:beginTime usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionLayoutSubviews animations:^{
            itme.center = CGPointMake(_bigRadius , _bigRadius);
            itme.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
        
        index ++;
    }
    
}

- (CATransform3D)turntable3DPoint:(CGPoint)translation
{
    
    CGFloat xOffest = translation.x - [_menuButton getCenter].x;
    CGFloat yOffest = translation.y - [_menuButton getCenter].y;
    
    CGFloat xDegress = xOffest / IH_DEVICE_WIDTH;
    CGFloat yDegress = yOffest / IH_DEVICE_HEIGHT;
    
    
    CATransform3D Rotate = CATransform3DConcat(CATransform3DMakeRotation(xDegress, 0, 1, 0), CATransform3DMakeRotation(-yDegress, 1, 0, 0));
    
    return CATransform3DPerspect(Rotate, CGPointMake(0, 0), _bigRadius+100);
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (void)adsorptionAnimation
{
    if (!_menuButton.isOpen) {
        if (_allowAdsorption) {
            CGPoint adsptionPoint = [self adsorptionPoint];
            [UIView animateWithDuration:_menuButton.duration animations:^{
                _menuButton.center = adsptionPoint;
            }];
        }
    }
}

- (CGPoint)adsorptionPoint
{
    CGPoint point  = _menuButton.center;
    CGFloat value  = IH_DEVICE_WIDTH/2;
    
    //判断y轴吸附
    if ((point.y - _smallRadius) < 20.f) {
        point = CGPointMake(MAX(MIN(point.x, (IH_DEVICE_WIDTH - (ADSORPTIONSPACING + _smallRadius))),
                                (ADSORPTIONSPACING + _smallRadius)),
                            ADSORPTIONSPACING + _smallRadius);
        return point;
    } else if ((IH_DEVICE_HEIGHT - (point.y + _smallRadius)) < 20.0f) {
        point = CGPointMake(MAX(MIN(point.x, IH_DEVICE_WIDTH - (ADSORPTIONSPACING + _smallRadius)),
                                (ADSORPTIONSPACING + _smallRadius)),
                            IH_DEVICE_HEIGHT - (ADSORPTIONSPACING + _smallRadius));
        return point;
    }
    
    //判断x轴吸附
    if (value > (point.x - _smallRadius)) {
        point = CGPointMake((_smallRadius + ADSORPTIONSPACING), MAX(point.y, (ADSORPTIONSPACING + _smallRadius)));
    } else {
        point = CGPointMake(IH_DEVICE_WIDTH - (_smallRadius + ADSORPTIONSPACING), MAX(point.y, (ADSORPTIONSPACING + _smallRadius)));
    }
    return point;
}

static BOOL isClose = false;

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject]locationInView:self];
    CALayer *layer=[_menuButton.layer hitTest:point];
    if (layer != _menuButton.layer) {
        if (isClose){
            if(!_draging){
                [self closeAnimation];
                isClose = false;
            }
        }
    }
}

// mark HyMenuButtonDelegate
- (void)MonitorTouchEventMnueButton:(HyMenuButton *__nonnull)menuButton
{
    if (!_menuButton.isOpen)  [self openAnimation];
}

- (void)animationComplete
{
    isClose = true;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    id obj = [super hitTest:point withEvent:event];
    if ([obj isKindOfClass:[HyMenuButton class]] || [obj isKindOfClass:[HyRoundMenuItme class]]) {
        return obj;
    }
    if (_menuButton.isOpen) {
     return obj;
    }
    return nil;
}

@end
