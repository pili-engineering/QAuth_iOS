//
//  UIColor+DymaicColor.h
//  QAuth_iOS_Demo
//
//  Created by wanglijun on 2020/7/30.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DymaicColor)
+(UIColor*)generateDynamicColor:(UIColor*)lightColor darkColor:(UIColor *)darkColor;
@end

NS_ASSUME_NONNULL_END
