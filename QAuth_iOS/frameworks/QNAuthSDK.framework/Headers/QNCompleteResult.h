//
//  QNCompleteResult.h
//  QNAuthSDK
//
//  Created by sunmu on 2023/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class QNCompleteResult;
typedef void(^QNComplete)(QNCompleteResult * completeResult);


@interface QNCompleteResult : NSObject

@property (nonatomic,assign)NSInteger code;

@property (nonatomic,nullable,copy)NSString * message;

@property (nonatomic,nullable,copy)NSDictionary * data;

@property (nonatomic,nullable,strong)NSError * error;
;


@end

NS_ASSUME_NONNULL_END
