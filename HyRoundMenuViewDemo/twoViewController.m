//
//  twoViewController.m
//  HyRoundMenuViewDemo
//
//  Created by 胡毅 on 17/2/27.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "twoViewController.h"
#import "HyRoundMenuView.h"

@interface twoViewController ()<HyRoundMenuViewDelegate>

@end

@implementation twoViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    HyRoundMenuView *menu = [HyRoundMenuView shareInstance];
    menu.delegate = self;
    menu.blurEffectStyle = UIBlurEffectStyleLight;
    //UIColor *color = [UIColor colorWithWhite:1 alpha:0.2f];
    UIColor *color = [UIColor colorWithRed:251.f/255.0f green:9.f/255.0f blue:80.f/255.0f alpha:0.5f];
    menu.shapeColor = color;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)roundMenuView:(HyRoundMenuView* __nonnull)roundMenuView didSelectRoundMenuModel:(HyRoundMenuModel* __nonnull)model
{
    [self.navigationController popViewControllerAnimated:model.transitionType != HyRoundMenuModelTransitionTypeMenuEnlarge];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
