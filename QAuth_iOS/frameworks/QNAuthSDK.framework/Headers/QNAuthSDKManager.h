//
//  QNAuthSDKManager.h
//  QNAuthSDK
//
//  Created by sunmu on 2023/6/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <QNAuthSDK/QNUIConfigure.h>
#import <QNAuthSDK/QNCompleteResult.h>

typedef void(^UAFContinueLoginEvent)(BOOL shouldContinueLogin);

@protocol QNAuthSDKManagerDelegate <NSObject>

@optional
- (void)qnSDKManagerAuthPageWillPresent;
@end


NS_ASSUME_NONNULL_BEGIN

@interface QNAuthSDKManager : NSObject

/// 设置点击协议代理
/// @param delegate         代理
+ (void)setQNAuthSDKManagerDelegate:(id<QNAuthSDKManagerDelegate>)delegate;

/// 初始化
/// @param appId            七牛后台申请的appId
/// @param complete         预初始化回调block（⚠️在子线程中回调）
+ (void)initWithAppId:(NSString *)appId appKey:(NSString *)appKey
             complete:(nullable QNComplete)complete;

///**
// 设置初始化超时 单位:s
// 大于0有效
// 建议4s左右，默认4s
// */
//+ (void)setInitTimeOut:(NSTimeInterval)initTimeOut;

/// 设置预取号超时 单位:s（大于0有效；建议4s左右，默认4s）
/// @param preGetPhoneTimeOut 预取号超时时间
+ (void)setPreGetPhonenumberTimeOut:(NSTimeInterval)preGetPhoneTimeOut;

/// 预取号
///此调用将有助于提高七牛拉起授权页的速度和成功率
///建议在一键登录前提前调用此方法，比如调一键登录的vc的viewdidload中
///不建议在拉起授权页后调用
///⚠️‼️以 if (completeResult.error == nil) 为判断成功的依据，而非返回码
/// @param complete         回调block（⚠️在子线程中回调）
+ (void)preGetPhonenumber:(nullable QNComplete)complete;

/// 一键登录拉起内置授权页&获取Token( 区分拉起授权页之前和之后的回调)
/// @param clUIConfigure    七牛授权页参数配置
/// @param openLoginAuthListener    拉起授权页监听：拉起授权页面成功或失败的回调，拉起成功或失败均触发。当拉起失败时，oneKeyLoginListener不会触发。此回调的内部触发时机是presentViewController:的完成block（⚠️在子线程中回调）
/// @param oneKeyLoginListener      一键登录监听：拉起授权页成功后的后续操作回调，包括点击SDK内置的(非外部自定义)取消登录按钮，以及点击本机号码一键登录的回调。点击授权页自定义按钮不触发此回调（⚠️在子线程中回调）
+ (void)quickAuthLoginWithConfigure:(QNUIConfigure *)qnUIConfigure
              openLoginAuthListener:(QNComplete)openLoginAuthListener
                oneKeyLoginListener:(QNComplete)oneKeyLoginListener;

/// 关闭授权页
///注：若授权页未拉起或已经提前关闭，此方法调用无效果，complete不触发。内部实现为调用系统方法dismissViewcontroller:Complete
/// @param flag             dismissViewcontroller`Animated, default is YES.
/// @param completion       dismissViewcontroller`completion（⚠️在子线程中回调）
+ (void)finishAuthControllerAnimated:(BOOL)flag
                          Completion:(void(^_Nullable)(void))completion;

/// 本机号认证获取token
/// @param complete         本机号认证回调（⚠️在子线程中回调）
+ (void)mobileCheckWithLocalPhoneNumberComplete:(QNComplete)complete;

/// 获取当前流量卡运营商，结果仅供参考（CTCC：电信、CMCC：移动、CUCC：联通、UNKNOW：未知）
+ (NSString *)getOperatorType;

/// 清除预取号缓存
+ (void)clearScripCache;


@end


NS_ASSUME_NONNULL_END
