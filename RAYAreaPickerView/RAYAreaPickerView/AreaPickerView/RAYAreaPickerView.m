//
//  RAYAreaPickerView.m
//  RAYAreaPickerView
//
//  Created by richerpay on 15/5/26.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYAreaPickerView.h"

static RAYAreaPickerView  *areaPickerView;

@interface RAYAreaPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate> {
    
    NSInteger       selectedRow;
}

@property (nonatomic, strong) UIControl     *pickerBackground;
@property (nonatomic, strong) UIPickerView  *pickerView;
@property (nonatomic, strong) UIToolbar     *toolBar;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;
@property (nonatomic, strong) UIBarButtonItem *hiddenItem;
@property (nonatomic, strong) UIBarButtonItem *spaceItem;

@property (nonatomic, strong) NSArray       *showArray;


@end

@implementation RAYAreaPickerView

#pragma mark - class mothod
+ (RAYAreaPickerView *)showPickerView:(configurePicker)callBack
                           motherView:(UIView *)view
                                 with:(NSArray *)dataArray {
    
    areaPickerView = [[RAYAreaPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    areaPickerView.configure = callBack;
    areaPickerView.showArray = dataArray;
    [view addSubview:areaPickerView];
    return areaPickerView;
}

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pickerBackground];
        self.pickerBackground.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [self addSubview:self.pickerView];
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        
        [self addSubview:self.toolBar];
        self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
        
        self.toolBar.items = @[self.previousItem ,self.nextItem ,self.spaceItem, self.hiddenItem];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self showPickerView];
        });
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _showArray.count;
}

#pragma mark - UIPickerViewDelegate
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [_showArray objectAtIndex:row];
}
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0);
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    selectedRow = row;
    
    if (selectedRow == 0) {
        self.previousItem.enabled = NO;
        self.nextItem.enabled = YES;
        
    }
    else {
        self.previousItem.enabled = YES;
        self.nextItem.enabled = NO;
    }
}

#pragma mark - event response
- (void)showPickerView {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBackground.alpha = 0.3;
        self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 44);
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
    }];
}

- (void)hidePickerView {
    
    [self setPickerValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBackground.alpha = 0.0;
        self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
    }completion:^(BOOL finsihed){
        [self.toolBar removeFromSuperview];
        [self.pickerView removeFromSuperview];
        [self.pickerBackground removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)showPrevious {
    if (selectedRow == 0) {
        return;
    }
    else {
        selectedRow = 0;
        self.previousItem.enabled = NO;
        self.nextItem.enabled = YES;
    }
    [self.pickerView selectRow:selectedRow inComponent:0 animated:YES];
}

- (void)showNext {

    if (selectedRow == 0) {
        selectedRow = 1;
        self.previousItem.enabled = YES;
        self.nextItem.enabled = NO;
    }
    else {
        return;
    }
    [self.pickerView selectRow:selectedRow inComponent:0 animated:NO];
}


#pragma mark - private methods
- (void)setPickerValue {
    NSString *selectValue = _showArray[selectedRow];
    if (self.configure) {
        self.configure(selectValue);
    }
}

#pragma mark - getters and setters
- (UIControl  *)pickerBackground{
    if (_pickerBackground == nil) {
        _pickerBackground = [[UIControl alloc]initWithFrame:CGRectZero];
        _pickerBackground.backgroundColor = [UIColor grayColor];
        _pickerBackground.alpha = 0.7;
        [_pickerBackground addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerBackground;
}

- (UIPickerView *)pickerView {
    if (_pickerView==nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _pickerView.backgroundColor = [UIColor lightGrayColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}
- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectZero];
        _toolBar.barStyle = UIBarStyleBlack;
    }
    return _toolBar;
}

- (UIBarButtonItem *)previousItem{
    
    if (_previousItem == nil) {
        _previousItem = [[UIBarButtonItem alloc]initWithTitle:@"上一项" style:UIBarButtonItemStylePlain target:self action:@selector(showPrevious)];
        _previousItem.enabled = NO;
    }
    return _previousItem;
}

- (UIBarButtonItem *)nextItem{
    if (_nextItem== nil) {
        _nextItem = [[UIBarButtonItem alloc]initWithTitle:@"下一项" style:UIBarButtonItemStyleDone target:self action:@selector(showNext)];
    }
    
    return _nextItem;
}

- (UIBarButtonItem *)hiddenItem{
    if (_hiddenItem == nil) {
        _hiddenItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hidePickerView)];
    }
    
    return _hiddenItem;
}

- (UIBarButtonItem *)spaceItem{
    if (_spaceItem == nil) {
        _spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    
    return _spaceItem;
}

@end
