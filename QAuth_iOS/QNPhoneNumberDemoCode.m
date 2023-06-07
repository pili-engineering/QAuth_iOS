//
//  QNPhoneNumberDemoCode.m
//  QAuth_iOS
//
//  Created by sunmu on 2023/5/22.
//

#import "QNPhoneNumberDemoCode.h"
#import <CocoaSecurity.h>
#import <AFNetworking.h>
#import <NSObject+YYModel.h>
@implementation QNPhoneNumberDemoCode

#define qn_SDK_URL_MobileLogin   @"https://niucube-api.qiniu.com/v1/mobileLogin"
#define qn_SDK_URL_MobileCheck   @"https://niucube-api.qiniu.com/v1/verify/check"

+ (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:
                                                              @"application/xml",
                                                              @"text/xml",
                                                              @"text/html",
                                                              @"application/json",
                                                              @"text/plain",
                                                              @"image/jpeg",
                                                              @"image/png",
                                                              @"application/octet-stream",
                                                              @"text/json",
                                                              @"charset=utf-8",nil];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Q-Plat"];
    [manager.requestSerializer setValue:@"1.0.0" forHTTPHeaderField:@"Q-Ver"];

    return manager;
}

//一键登录token置换手机号示例
//此处模拟客户服务端调用七牛服务端，依照七牛服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)mobileLoginWithtoken:(NSString *)token completion:(nullable void (^)(id  _Nullable responseObject, NSError * _Nullable error))completion{

    NSMutableDictionary * paramr = [NSMutableDictionary dictionary];
    paramr[@"token"] = token;

    NSLog(@"%@",paramr);
    
    AFHTTPSessionManager *manager = [self manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    [manager POST:qn_SDK_URL_MobileLogin parameters:paramr headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil,error);
        }
    }];

}

//本机校验token验证手机号示例
//此处模拟客户服务端调用七牛服务端，依照七牛服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)validatePhonenumber:(NSString*)phoneNumberToCheck token:(NSString*)token completion:(nullable void (^)(NSNumber * isValidated, id  _Nullable responseObject, NSError * _Nullable error))completion{

//    NSLog(@"tokenParamr:%@",completeResultData);

//    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSMutableDictionary * paramr = [NSMutableDictionary dictionary];
    paramr[@"token"] = token;
    paramr[@"mobile"] = phoneNumberToCheck;


    AFHTTPSessionManager *manager = [self manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:qn_SDK_URL_MobileCheck parameters:paramr headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        if (code == 0) {
            //本机校验成功，号码一致
            if (completion) {
                completion(@(YES),responseObject,nil);
            }
        }else{
            //本机校验失败
            if (completion) {
                completion(nil,responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil,nil,error);
        }
    }];

}



@end
