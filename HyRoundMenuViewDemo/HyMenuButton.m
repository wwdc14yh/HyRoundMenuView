//
//  HyMenuButton.m
//  Test_Circle_Arranged
//
//  Created by 胡毅 on 17/2/24.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "HyMenuButton.h"
#import "HyRoundShapeLayer.h"

@interface HyMenuButton ()

@property (nonatomic, assign) CGPoint oldPoint;

@property (nonnull, nonatomic, strong) HyRoundShapeLayer *shapeLayer;

@property (nonnull, nonatomic,  copy ) UIColor           *color;

@end

@implementation HyMenuButton

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI
{
    _smallRadius = 30.f;
    _bigRadius   = 120.f;
    _duration    = 0.3f;
    _isOpen      = false;
    _oldPoint    = CGPointZero;
    _smallAnimationComplete = true;
    
    self.frame = CGRectMake(0, [self getCenter].y, _smallRadius*2, _smallRadius*2);
    
    self.layer.shadowOffset =  CGSizeMake(0, 6.0);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor =  [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 5.0f;
    
    _customBigPath   = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, _smallRadius *2, _smallRadius *2)];
    _customSmallPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, _smallRadius *2, _smallRadius *2)];
    _shapeLayer = [HyRoundShapeLayer layer];
    _shapeLayer.path = _customSmallPath.CGPath;
    _shapeLayer.bounds = CGRectMake(0, 0, _smallRadius *2, _smallRadius * 2);
    _shapeLayer.position = CGPointMake(_smallRadius, _smallRadius);
    _shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _shapeLayer.zPosition = -1;
    _shapeLayer.opacity = 0.0f;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
    [self.layer insertSublayer:_shapeLayer atIndex:0];
    
    _imageLayer = [CALayer layer];
    _imageLayer.zPosition = -1;
    _imageLayer.bounds = (CGRect){CGPointZero,{_smallRadius * 2,_smallRadius * 2}};
    _imageLayer.position = _shapeLayer.position;
    [self.layer addSublayer:_imageLayer];
    
    _textlayer = [CATextLayer layer];
    _textlayer.fontSize = 30.0f;
    _textlayer.contentsScale = [UIScreen mainScreen].scale;
    _textlayer.alignmentMode = kCAAlignmentCenter;
    _textlayer.opacity = 0.0f;
    _textlayer.font = (__bridge CFTypeRef)@"KohinoorBangla-Light";
    _textlayer.frame = CGRectMake(-(([UIScreen mainScreen].bounds.size.width - (_bigRadius * 2))/2), -(_bigRadius - 20), [UIScreen mainScreen].bounds.size.width, 35);
    
    [self.layer addSublayer:_textlayer];
    
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSmallRadius:(CGFloat)smallRadius
{
    //_shapeLayer.backgroundColor = [UIColor redColor].CGColor;
    _smallRadius = smallRadius;
    _shapeLayer.bounds = CGRectMake(0, 0, _smallRadius *2, _smallRadius * 2);
    _shapeLayer.position = CGPointMake(_smallRadius, _smallRadius);
    
    _imageLayer.bounds = (CGRect){CGPointZero,{_smallRadius * 2,_smallRadius * 2}};
    _imageLayer.position = _shapeLayer.position;
}

- (void)setCustomSmallPath:(UIBezierPath *)customSmallPath
{
    if (!customSmallPath) {
        customSmallPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, _smallRadius *2, _smallRadius *2)];
    }
    _customSmallPath = customSmallPath;
    [_shapeLayer setValue:(__bridge id)_customSmallPath.CGPath forKey:@"path"];
}

- (void)setCustomBigPath:(UIBezierPath *)customBigPath
{
    if (!customBigPath) {
        customBigPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, _smallRadius *2, _smallRadius *2)];
    }
    _customBigPath = customBigPath;
    if (_isOpen) {
        _shapeLayer.path = _customBigPath.CGPath;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _color = backgroundColor;
    //[super setBackgroundColor:backgroundColor];
    //_shapeLayer.backgroundColor = [UIColor redColor].CGColor;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    _imageLayer.contents = (id)image.CGImage;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    //self.imageView.contentMode    = UIViewContentModeScaleAspectFit;
    //self.imageView.layer.contents = image;
    _shapeLayer.contents = (__bridge id _Nullable)(image.CGImage);
}

- (void)touchUpInside
{
    _shapeLayer.fillColor   =  _color.CGColor;
    if ([self.delegate respondsToSelector:@selector(MonitorTouchEventMnueButton:)]) {
        [self.delegate MonitorTouchEventMnueButton:self];
    }
}

- (void)animationComplete
{
    if ([self.delegate respondsToSelector:@selector(animationComplete)]) {
        [self.delegate animationComplete];
    }
}

- (void)bigAnimation
{
    _smallAnimationComplete = false;
    _oldPoint = self.center;
    _isOpen = true;
    self.userInteractionEnabled = false;
    CGFloat scaling = ((_bigRadius*2) / (_smallRadius*2)) ;
    
    
    [UIView animateWithDuration:_duration animations:^{
        _textlayer.opacity = 1.0f;
        //[_shapeLayer setValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(scaling, scaling, scaling)] forKey:@"transform"];
        //[_shapeLayer setValue:[NSValue valueWithCGPoint:CGPointMake(_bigRadius, _bigRadius)] forKey:@"position"];
        self.frame = CGRectMake(0, 0, _bigRadius * 2, _bigRadius * 2);
        self.center = [self getCenter];
        [_shapeLayer setValue:(__bridge id)_customBigPath.CGPath forKey:@"path"];
        
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = finished;
        //_smallAnimationComplete = true;
        
        _shapeLayer.position  = CGPointMake(_bigRadius, _bigRadius);
        _shapeLayer.transform = CATransform3DMakeScale(scaling, scaling, scaling);
        _imageLayer.position  = CGPointMake(_bigRadius, _bigRadius);
        [self animationComplete];
        [UIView animateWithDuration:0.2 animations:^{
            [_shapeLayer setValue:@(_isOpen) forKey:@"opacity"];
        }];
    }];

    CABasicAnimation *an = [self zoomScale:scaling fromValue:1.f];
    [_shapeLayer addAnimation:an forKey:an.keyPath];
    
    CABasicAnimation *pos = [self positionAnimationPosition:CGPointMake(_bigRadius, _bigRadius) fromValue:CGPointMake(_smallRadius, _smallRadius)];
    [_shapeLayer addAnimation:pos forKey:pos.keyPath];
    
    CABasicAnimation *posd = [self positionAnimationPosition:CGPointMake(_bigRadius, _bigRadius) fromValue:CGPointMake(_smallRadius, _smallRadius)];
    [_imageLayer addAnimation:posd forKey:posd.keyPath];
    
//    [UIView animateWithDuration:_duration delay:0.0f usingSpringWithDamping:1 initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
//    } completion:^(BOOL finished) {
//    }];
   // CABasicAnimation *an = [self pathAnimationBezierPath:_customBigPath FromValue:_customSmallPath];
   // [_shapeLayer addAnimation:an forKey:an.keyPath];
}

- (void)bigAnimation2
{
    _oldPoint = self.center;
    _isOpen = true;
    _smallAnimationComplete = false;
    self.userInteractionEnabled = false;
    self.transform = CGAffineTransformIdentity;
    
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        self.frame = CGRectMake(0, 0, _bigRadius * 2, _bigRadius * 2);
        self.center = [self getCenter];
        self.imageLayer.position = CGPointMake(_bigRadius, _bigRadius);
        
        [_shapeLayer setValue:[NSValue valueWithCGPoint:CGPointMake(_bigRadius, _bigRadius)] forKey:@"position"];
        _shapeLayer.path = _customBigPath.CGPath;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self bigAnimationSetup2];
        });
    }];
}

- (void)bigAnimationSetup2
{
    CGFloat scaling = (_bigRadius / _smallRadius) ;
    
    [UIView animateWithDuration:_duration animations:^{
        self.alpha = 1.0f;
        _textlayer.opacity = 1.0f;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = finished;
        _shapeLayer.transform = CATransform3DMakeScale(scaling, scaling, scaling);
        [self animationComplete];
        [UIView animateWithDuration:0.2 animations:^{
            [_shapeLayer setValue:@(_isOpen) forKey:@"opacity"];
        }];
    }];
    
    CABasicAnimation *an = [self zoomScale:scaling fromValue:1.f];
    [_shapeLayer addAnimation:an forKey:an.keyPath];
}

- (void)restorePoint
{
    _isOpen = false;
    self.userInteractionEnabled = false;
    
    CABasicAnimation *an = [self zoomScale:1 fromValue:_bigRadius/_smallRadius];
    [_shapeLayer addAnimation:an forKey:an.keyPath];
    //[UIView animateWithDuration:_duration animations:^{
        
        //[_shapeLayer setValue:[NSValue valueWithCATransform3D:CATransform3DIdentity] forKey:@"transform"];
        //[_shapeLayer setValue:@(0.0f) forKey:@"opacity"];
        //[_shapeLayer setValue:[NSValue valueWithCGPoint:CGPointMake(_bigRadius, _bigRadius)] forKey:@"position"];
        self.alpha = 0.0f;
        _textlayer.opacity = 0.0f;
        
   // } completion:^(BOOL finished) {
        _shapeLayer.position = CGPointMake(_smallRadius, _smallRadius);
        [self.layer removeAllAnimations];
        self.frame = CGRectMake(0, 0, _smallRadius * 2, _smallRadius * 2);
        self.center = _oldPoint;
        self.imageLayer.position = CGPointMake(_smallRadius, _smallRadius);
        _shapeLayer.path = _customSmallPath.CGPath;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self smallAnimationSetup2];
        });
   /// }];
}

- (void)smallAnimation
{
    _isOpen = false;
    self.userInteractionEnabled = false;
    [UIView animateWithDuration:_duration animations:^{
        
        _textlayer.opacity = 0.0f;
        [_shapeLayer setValue:(__bridge id)_customSmallPath.CGPath forKey:@"path"];

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:_duration animations:^{
            self.frame = CGRectMake(0, 0, _smallRadius * 2, _smallRadius * 2);
            self.center = _oldPoint;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = finished;
            _smallAnimationComplete = true;
            _shapeLayer.position = CGPointMake(_smallRadius, _smallRadius);
            _shapeLayer.transform = CATransform3DMakeScale(1, 1, 1);
            _imageLayer.position = CGPointMake(_smallRadius, _smallRadius);
            [UIView animateWithDuration:0.2 animations:^{
                [_shapeLayer setValue:@(_isOpen) forKey:@"opacity"];
            }];
            
        }];
        CGFloat scaling = ((_bigRadius*2) / (_smallRadius*2));
        CABasicAnimation *an = [self zoomScale:1 fromValue:scaling];
        CABasicAnimation *pos = [self positionAnimationPosition:CGPointMake(_smallRadius, _smallRadius) fromValue:CGPointMake(_bigRadius, _bigRadius)];
        CABasicAnimation *posd = [self positionAnimationPosition:CGPointMake(_smallRadius, _smallRadius) fromValue:CGPointMake(_bigRadius, _bigRadius)];
        
        [_shapeLayer addAnimation:an forKey:an.keyPath];
        [_shapeLayer addAnimation:pos forKey:pos.keyPath];
        [_imageLayer addAnimation:posd forKey:posd.keyPath];
    }];
}

- (void)smallAnimation2
{
    _isOpen = false;
    self.userInteractionEnabled = false;
    
    CABasicAnimation *an = [self zoomScale:1 fromValue:_bigRadius/_smallRadius];
    [_shapeLayer addAnimation:an forKey:an.keyPath];
    [UIView animateWithDuration:_duration animations:^{
       
        //[_shapeLayer setValue:[NSValue valueWithCATransform3D:CATransform3DIdentity] forKey:@"transform"];
        //[_shapeLayer setValue:@(0.0f) forKey:@"opacity"];
        //[_shapeLayer setValue:[NSValue valueWithCGPoint:CGPointMake(_bigRadius, _bigRadius)] forKey:@"position"];
        self.alpha = 0.0f;
        _textlayer.opacity = 0.0f;
        
    } completion:^(BOOL finished) {
        _shapeLayer.position = CGPointMake(_smallRadius, _smallRadius);
        [self.layer removeAllAnimations];
        self.frame = CGRectMake(0, 0, _smallRadius * 2, _smallRadius * 2);
        self.center = _oldPoint;
        self.imageLayer.position = CGPointMake(_smallRadius, _smallRadius);
        _shapeLayer.path = _customSmallPath.CGPath;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self smallAnimationSetup2];
        });
    }];
}

- (void)smallAnimationSetup2
{
    [UIView animateWithDuration:_duration animations:^{
        
        self.alpha = 1.0f;
        //[_shapeLayer setValue:@(1.0f) forKey:@"opacity"];
        
    } completion:^(BOOL finished) {
        
        //            self.center = _oldPoint;
        _smallAnimationComplete = true;
        self.userInteractionEnabled = YES;
        
        //shadowOpacity
        CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowOpacityAnimation.duration = _duration;
        [shadowOpacityAnimation setFromValue:@(0.3f)];
        [shadowOpacityAnimation setToValue:@(1.0f)];
        shadowOpacityAnimation.autoreverses = true;
        shadowOpacityAnimation.removedOnCompletion = true;
        [self.layer addAnimation:shadowOpacityAnimation forKey:shadowOpacityAnimation.keyPath];
        [UIView animateWithDuration:0.2 animations:^{
            [_shapeLayer setValue:@(_isOpen) forKey:@"opacity"];
        }];
    }];
}

- (CABasicAnimation *)pathAnimationBezierPath:(UIBezierPath *)bezierPath FromValue:(UIBezierPath *)fromValue
{
    CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.toValue = (__bridge id)bezierPath.CGPath;
    pathAnimation.fromValue = (__bridge id)fromValue.CGPath;
    pathAnimation.duration = _duration;
    pathAnimation.removedOnCompletion = false;
    pathAnimation.fillMode = kCAFillModeForwards;
    return pathAnimation;
}

- (CABasicAnimation *)zoomScale:(CGFloat)scale fromValue:(CGFloat)fromValue;
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:fromValue];
    animation.toValue=[NSNumber numberWithFloat:scale];
    animation.duration=_duration;
    animation.autoreverses=NO;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

- (CABasicAnimation *)positionAnimationPosition:(CGPoint)position fromValue:(CGPoint)fromValue;
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue=[NSValue valueWithCGPoint:fromValue];
    animation.toValue=[NSValue valueWithCGPoint:position];
    animation.duration=_duration ;
    animation.autoreverses=NO;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

- (CGPoint)getCenter
{
    return CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
