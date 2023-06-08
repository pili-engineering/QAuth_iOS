//
//  UIColor+DymaicColor.m
//  QAuth_iOS_Demo
//
//  Created by wanglijun on 2020/7/30.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import "UIColor+DymaicColor.h"

@implementation UIColor (DymaicColor)
+(UIColor*)generateDynamicColor:(UIColor*)lightColor darkColor:(UIColor *)darkColor{
    
    if (@available(iOS 13.0, *)) {
        return [[UIColor alloc]initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor;
            }else {
                return lightColor;
            }
        }];
    } else {
        return lightColor;
    }
}
@end
