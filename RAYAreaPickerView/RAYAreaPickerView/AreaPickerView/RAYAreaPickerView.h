//
//  RAYAreaPickerView.h
//  RAYAreaPickerView
//
//  Created by richerpay on 15/5/26.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^configurePicker) (NSString * value);

@interface RAYAreaPickerView : UIView

@property (nonatomic,copy)configurePicker  configure;//block

+ (RAYAreaPickerView *)showPickerView:(configurePicker)callBack
                           motherView:(UIView *)view
                                 with:(NSArray *)dataArray;

@end
