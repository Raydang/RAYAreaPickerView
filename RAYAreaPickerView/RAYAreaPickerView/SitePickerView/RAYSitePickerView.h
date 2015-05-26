//
//  RAYSitePickerView.h
//  RAYAreaPickerView
//
//  Created by richerpay on 15/5/26.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RAYSitePickerMode) {
    RAYSitePickerWithStateAndCity ,                  // StateAndCity
    RAYSitePickerWithStateAndCityAndDistrict         // StateAndCityAndDistrict
};


typedef void(^configurePicker) (NSString * value);

@interface RAYSitePickerView : UIView

@property (nonatomic,copy)configurePicker  configure;   //block
@property (nonatomic)RAYSitePickerMode mode;

+ (RAYSitePickerView *)showPickerView:(configurePicker)callBack
                           motherView:(UIView *)view
                                 mode:(NSInteger)value;

@end
