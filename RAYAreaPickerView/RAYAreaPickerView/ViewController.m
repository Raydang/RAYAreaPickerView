//
//  ViewController.m
//  RAYAreaPickerView
//
//  Created by richerpay on 15/5/25.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "ViewController.h"
#import "RAYAreaPickerView.h"
#import "RAYSitePickerView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *areaButton;
@property (nonatomic, strong) UIButton *siteButton;

@end

@implementation ViewController

#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.areaButton];
    [self.view addSubview:self.siteButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.areaButton.frame = CGRectMake(5, 80, SCREEN_WIDTH - 10, 50);
    self.siteButton.frame = CGRectMake(5, 180, SCREEN_WIDTH - 10, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

#pragma mark - event response
- (void)clickAreaButton {
    NSArray *areaArray = @[@"上海",@"北京"];
    [RAYAreaPickerView showPickerView:^(NSString *value){
        [self.areaButton setTitle:value forState:UIControlStateNormal];
    }
                          motherView:self.view
                                with:areaArray];
}
- (void) clickSiteButton {
    
    [RAYSitePickerView  showPickerView:^(NSString *value){
        [self.siteButton setTitle:value forState:UIControlStateNormal];
    }
                            motherView:self.view
                                  mode:RAYSitePickerWithStateAndCityAndDistrict];
}

#pragma mark - private methods

#pragma mark - getters and setters
- (UIButton *)areaButton {
    if (_areaButton == nil) {
        _areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _areaButton.backgroundColor = [UIColor clearColor];
        [_areaButton setTitle:@"上海" forState:UIControlStateNormal];
        [_areaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_areaButton addTarget:self action:@selector(clickAreaButton) forControlEvents:UIControlEventTouchUpInside];
        
        _areaButton.layer.borderWidth = 2.f;
        _areaButton.layer.borderColor = [UIColor redColor].CGColor;
        _areaButton.layer.cornerRadius = 10;
        
        _areaButton.layer.shadowColor = [UIColor grayColor].CGColor; //阴影颜色
        _areaButton.layer.shadowOffset = CGSizeMake(4, 4);           //阴影偏移，x向右偏移4，y向下偏移4 默认（0 ，－3）这个跟shadowradius配合使用
        _areaButton.layer.shadowOpacity = 0.8;                       //阴影透明度，默认0
        _areaButton.layer.shadowRadius = 4;                          //阴影半径，默认3
    }
    return _areaButton;
}

- (UIButton *)siteButton {
    
    if (_siteButton == nil) {
        _siteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _siteButton.backgroundColor = [UIColor clearColor];
        [_siteButton setTitle:@"--" forState:UIControlStateNormal];
        [_siteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_siteButton addTarget:self action:@selector(clickSiteButton) forControlEvents:UIControlEventTouchUpInside];
        
        _siteButton.layer.borderWidth = 2.f;
        _siteButton.layer.borderColor = [UIColor blueColor].CGColor;
        _siteButton.layer.cornerRadius = 10;
    }
    return _siteButton;
}

@end
