//
//  ViewController.m
//  HyRoundMenuViewDemo
//
//  Created by 胡毅 on 17/2/25.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "ViewController.h"
#import "HyRoundMenuView.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource, HyRoundMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) HyRoundMenuView *menuView;
@property (nonatomic, strong) NSArray *reloadArray;
@end

@implementation ViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _menuView.delegate = self;
    _menuView.blurEffectStyle = UIBlurEffectStyleDark;
    UIColor *color = [UIColor colorWithRed:23.f/255.f green:107.f/255.f blue:213.f/255.f alpha:1.0f];
    _menuView.shapeColor = color;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuView = [HyRoundMenuView shareInstance];
    
    _data = @[
              [HyRoundMenuModel title:@"FaceBook"  iconImage:[UIImage imageNamed:@"ICON_SNS_facebook"] transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
              [HyRoundMenuModel title:@"Link"      iconImage:[UIImage imageNamed:@"ICON_SNS_Link"] transitionType:HyRoundMenuModelTransitionTypeNormal],
              [HyRoundMenuModel title:@"微信朋友圈"  iconImage:[UIImage imageNamed:@"ICON_SNS_Moment"] transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
              [HyRoundMenuModel title:@"QQ"        iconImage:[UIImage imageNamed:@"ICON_SNS_QQ"] transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
              [HyRoundMenuModel title:@"Twitter"   iconImage:[UIImage imageNamed:@"ICON_SNS_twitter"] transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
              [HyRoundMenuModel title:@"微信"       iconImage:[UIImage imageNamed:@"ICON_SNS_Wechat"] transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge],
              [HyRoundMenuModel title:@"微博"       iconImage:[UIImage imageNamed:@"ICON_SNS_Weibo"] transitionType:HyRoundMenuModelTransitionTypeMenuEnlarge]
             ].mutableCopy;
    
    _menuView.bigRadius   = 120.0f;
    _menuView.smallRadius = 30.0f;
    HyRoundMenuModel *centerModel = [HyRoundMenuModel title:@"What you want to do?" iconImage:[UIImage imageNamed:@"SendRound"] transitionType:HyRoundMenuModelTransitionTypeNormal];
    centerModel.type = HyRoundMenuModelItmeTypeCenter;
    [_data addObject:centerModel];
    _menuView.dataSources = _data;
    UIColor *color = [UIColor colorWithRed:23.f/255.f green:107.f/255.f blue:213.f/255.f alpha:1.0f];
    //UIColor *color2 = [UIColor colorWithWhite:1 alpha:0.2];
    _menuView.shapeColor = color;
    
    _menuView.backgroundViewType = HyRoundMenuViewBackgroundViewTypeBlur;
    _menuView.customBackgroundViewColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    _menuView.delegate = self;
    
    _reloadArray = @[@{@"title":@"Animation type",@"list":@[@"HyRoundMenuViewAnimationTypeValue1",@"HyRoundMenuViewAnimationTypeValue2"]},
                             @{@"title":@"Custom shape",@"list":@[@"默认", @"Matrix fillet", @"Pentagon"]},
                             @{@"title":@"BackgroundViewType",@"list":@[@"HyRoundMenuViewBackgroundViewTypeBlur",@"HyRoundMenuViewBackgroundViewTypeCustomColors"]},
                             ];
    
    // Do any additional setup after loading the view, typically from a nib.
}

// 音频文件的ID
static SystemSoundID shake_sound_male_id = 0;

-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"prlm_sound_triggering" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
static HyRoundMenuModel *tempModel = nil;
- (void)roundMenuView:(HyRoundMenuView* __nonnull)roundMenuView dragAfterModel:(HyRoundMenuModel* __nonnull)model
{
    [self playSound];
}

- (void)roundMenuView:(HyRoundMenuView* __nonnull)roundMenuView didSelectRoundMenuModel:(HyRoundMenuModel* __nonnull)model
{
    UIViewController *two = [self.storyboard instantiateViewControllerWithIdentifier:@"twoViewController"];
    [self.navigationController pushViewController:two animated:model.transitionType != HyRoundMenuModelTransitionTypeMenuEnlarge];
}

static NSInteger indexZ = 0;

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = _reloadArray.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
        {
            NSDictionary *dic = _reloadArray[indexZ];
            NSArray *list = [dic objectForKey:@"list"];
            result = list.count;
        }
            break;
    }
    
    return result;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary *dic = _reloadArray[row];
        return [dic objectForKey:@"title"];
    }else{
        NSDictionary *dic = _reloadArray[indexZ];
        NSArray *list = [dic objectForKey:@"list"];
        return [list objectAtIndex:row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:1];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont fontWithName:@"KohinoorBangla-Light" size:20]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        indexZ = [pickerView selectedRowInComponent:0];
        [pickerView reloadComponent:1];
    }
    
    if (indexZ == 0) _menuView.animationType = row;
    if (indexZ == 2) _menuView.backgroundViewType = row;
    
    if (indexZ != 1) {
        return ;
    }
    if (row == 0) {
        
        _menuView.customBigShapeBezierPath   = nil;
        
    }else if (row == 1){
            
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 60, 60) cornerRadius: 19];
        _menuView.customBigShapeBezierPath = rectanglePath;
            
    }else if (row == 2){
        
        UIBezierPath* polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint: CGPointMake(30, -0)];
        [polygonPath addLineToPoint: CGPointMake(0, 22.92)];
        [polygonPath addLineToPoint: CGPointMake(11.46, 60)];
        [polygonPath addLineToPoint: CGPointMake(48.54, 60)];
        [polygonPath addLineToPoint: CGPointMake(60, 22.92)];
        [polygonPath addLineToPoint: CGPointMake(30, -0)];
        [polygonPath closePath];
        
        _menuView.customBigShapeBezierPath = polygonPath;
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
