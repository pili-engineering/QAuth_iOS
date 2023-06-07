//
//  CLConsole.h
//  CLConsole
//
//  Created by wanglijun on 2019/6/13.
//  Copyright © 2019 wanglijun. All rights reserved.
//



#import <Foundation/Foundation.h>

#define CLConsoleLog(frmt,...)  [[CLConsole sharedConsole] function:__PRETTY_FUNCTION__ line:__LINE__ format:[NSString stringWithFormat:frmt, ##__VA_ARGS__]]

@interface CLConsole : NSObject

+ (instancetype)sharedConsole;

- (void)startPrintLog;

- (void)stopPrinting;

- (void)function:(const char *)function
  line:(NSUInteger)line
          format:(NSString *)format;
@end
