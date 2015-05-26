//
//  RAYSitePickerView.m
//  RAYAreaPickerView
//
//  Created by richerpay on 15/5/26.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYSitePickerView.h"
#import "RAYSite.h"

static RAYSitePickerView  *sitePickerView;

@interface RAYSitePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate> {
    
    NSArray *states,*cities,*districts;
}

@property (nonatomic, strong) UIControl     *pickerBackground;
@property (nonatomic, strong) UIPickerView  *pickerView;
@property (nonatomic, strong) UIToolbar     *toolBar;

@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic, strong) UIBarButtonItem *hiddenItem;
@property (nonatomic, strong) UIBarButtonItem *spaceItem;

@property (nonatomic, strong) RAYSite         *raySite;

@end

@implementation RAYSitePickerView

#pragma mark - class mothod
+ (RAYSitePickerView *)showPickerView:(configurePicker)callBack
                           motherView:(UIView *)view
                                 mode:(NSInteger)value {

    sitePickerView = [[RAYSitePickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    sitePickerView.configure = callBack;
    sitePickerView.mode = value;
    [view addSubview:sitePickerView];
    return sitePickerView;
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
        self.toolBar.items = @[self.cancelItem, self.spaceItem, self.hiddenItem];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self asyncData];
        });
        


    }
    return self;
}
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_mode == RAYSitePickerWithStateAndCityAndDistrict ) {
        return 3;
    }
    else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return [states count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            if (_mode == RAYSitePickerWithStateAndCityAndDistrict) {
                return [districts count];
                break;
            }

            
        default:
            return 0;
            break;
    }
}

#pragma mark - UIPickerViewDelegate
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return [states[row] objectForKey:@"state"];
            break;
        case 1:
            if (_mode == RAYSitePickerWithStateAndCityAndDistrict) {
                return [cities[row] objectForKey:@"city"];
                break;
            }
            else {
                return cities[row];
                break;
            }
        case 2:
                if ([districts count]>0) {
                    return districts[row];
                    break;
                }


        default:
            return 0;
            break;
    }

}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_mode == RAYSitePickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                cities = [[states objectAtIndex:row] objectForKey:@"cities"];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:1];
                
                 districts = [[cities objectAtIndex:0] objectForKey:@"areas"];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                [self.pickerView reloadComponent:2];
                
                self.raySite.state = [[states objectAtIndex:row] objectForKey:@"state"];
                self.raySite.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                if ([districts count] > 0) {
                    self.raySite.district = [districts objectAtIndex:0];
                } else{
                    self.raySite.district = @"";
                }
                break;
            case 1:
                districts = [[cities objectAtIndex:row] objectForKey:@"areas"];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                [self.pickerView reloadComponent:2];
                
                self.raySite.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([districts count] > 0) {
                    self.raySite.district = [districts objectAtIndex:0];
                } else{
                    self.raySite.district = @"";
                }
                break;
            case 2:
                if ([districts count] > 0) {
                    self.raySite.district = [districts objectAtIndex:row];
                } else{
                    self.raySite.district = @"";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                cities = [[states objectAtIndex:row] objectForKey:@"cities"];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:1];
                
                self.raySite.state = [[states objectAtIndex:row] objectForKey:@"state"];
                self.raySite.city = [cities objectAtIndex:0];
                break;
            case 1:
                self.raySite.city = [cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
//    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
//        [self.delegate pickerDidChaneStatus:self];
//    }
    NSLog(@"1==%@",self.raySite.district);
}

#pragma mark - event response
- (void)showPickerView {
    

    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.pickerBackground.alpha = 0.3;
        self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 44);
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
    }];
}

- (void) cancelPickerView {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBackground.alpha = 0.0;
        self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        
    }completion:^(BOOL finsihed){
        states = nil;cities = nil;districts =nil;
        
        
        [self.toolBar removeFromSuperview];
        [self.pickerView removeFromSuperview];
        [self.pickerBackground removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)hidePickerView {
    
    [self setPickerValue];
    [self cancelPickerView];

}
#pragma mark - private methods
- (void)setPickerValue {
    NSString *selectValue = [NSString stringWithFormat:@"%@     %@     %@",self.raySite.state,self.raySite.city, self.raySite.district];
    if (self.configure) {
        self.configure(selectValue);
    }
}
//
- (void)asyncData {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        if (_mode == RAYSitePickerWithStateAndCityAndDistrict ) {
            states = [[NSArray alloc] initWithContentsOfFile:FILE(@"area.plist")];
            cities = [[states firstObject] objectForKey:@"cities"];
            districts =[[cities firstObject] objectForKey:@"areas"];
            
            self.raySite.state = [[states firstObject] objectForKey:@"state"];
            self.raySite.city  = [[cities firstObject] objectForKey:@"city"];
            
            if (districts.count >0) {
                self.raySite.district = [districts firstObject];
            }
            else {
                self.raySite.district = @"";
            }
            
        }
        else {
            states = [[NSArray alloc] initWithContentsOfFile:FILE(@"city.plist")];
            cities = [[states objectAtIndex:0] objectForKey:@"cities"];
            
            self.raySite.state = [[states firstObject] objectForKey:@"state"];
            self.raySite.city  = [cities firstObject];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.pickerView.dataSource = self;
            self.pickerView.delegate = self;
            [self showPickerView];
        });
    });
}

#pragma mark - getters and setters
- (UIControl  *)pickerBackground{
    if (_pickerBackground == nil) {
        _pickerBackground = [[UIControl alloc]initWithFrame:CGRectZero];
        _pickerBackground.backgroundColor = [UIColor grayColor];
        _pickerBackground.alpha = 0.7;
        [_pickerBackground addTarget:self action:@selector(cancelPickerView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerBackground;
}

- (UIPickerView *)pickerView {
    if (_pickerView==nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _pickerView.backgroundColor = [UIColor lightGrayColor];

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

- (UIBarButtonItem *)cancelItem {
    if (_cancelItem == nil) {
        _cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPickerView)];
    }
    
    return _cancelItem;
}

- (UIBarButtonItem *)hiddenItem {
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

- (RAYSite *)raySite {
    if (_raySite == nil) {
        _raySite = [[RAYSite alloc]init];
    }
    return _raySite;
}

@end
