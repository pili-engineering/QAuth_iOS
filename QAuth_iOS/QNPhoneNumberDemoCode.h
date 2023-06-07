//
//  QNPhoneNumberDemoCode.h
//  QAuth_iOS
//
//  Created by sunmu on 2023/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNPhoneNumberDemoCode : NSObject
//一键登录token置换手机号示例
//此处模拟客户服务端调用七牛服务端，依照七牛服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)mobileLoginWithtoken:(NSString *)token completion:(nullable void (^)(id  _Nullable responseObject, NSError * _Nonnull error))completion;

//本机校验token验证手机号示例
//此处模拟客户服务端调用七牛服务端，依照七牛服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)validatePhonenumber:(NSString*)phoneNumberToCheck token:(NSString*)token completion:(nullable void (^)(NSNumber * isValidated, id  _Nullable responseObject, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
