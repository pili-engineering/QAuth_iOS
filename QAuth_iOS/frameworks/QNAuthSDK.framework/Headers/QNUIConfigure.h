//
//  QNUIConfigure.h
//  QAuth_iOS
//
//  Created by sunmu on 2023/5/25.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QNOrientationLayOut;
NS_ASSUME_NONNULL_BEGIN

/*⚠️⚠️ 注： 授权页一键登录按钮、运营商条款必须显示，不得隐藏，否则取号能力可能被运营商关闭 **/

/// 授权页UI配置
@interface QNUIConfigure : NSObject

/// 要拉起授权页的vc [必填项] (注：SDK不持有接入方VC)
@property(nonatomic,weak) UIViewController *viewController;
/// 授权页背景图片
@property(nonatomic,strong) UIImage *qnBackgroundImg;

/****************************   导航栏相关 ***************************/

/// 导航栏 是否隐藏 BOOL default is NO, 设置优先级高于qnNavigationBackgroundclear eg.@(NO)
@property(nonatomic,strong) NSNumber *qnNavigationBarHidden;
/// 导航栏 背景透明 BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *qnNavigationBackgroundClear;
/// 导航栏标题
@property(nonatomic,strong) NSAttributedString *qnNavigationAttributesTitleText;
/// 导航栏右侧自定义按钮
@property(nonatomic,strong) UIBarButtonItem *qnNavigationRightControl;
/// 导航栏左侧自定义按钮
@property(nonatomic,strong) UIBarButtonItem *qnNavigationLeftControl;

@property(nonatomic,strong) NSNumber *qnNavigationBottomLineHidden;
/// 导航栏 导航栏底部分割线（图片）
@property(nonatomic,strong) UIImage *qnNavigationShadowImage;
/// 导航栏 文字颜色
@property(nonatomic,strong) UIColor *qnNavigationTintColor;
/// 导航栏 背景色 default is white
@property(nonatomic,strong) UIColor *qnNavigationBarTintColor;
/// 导航栏 背景图片
@property(nonatomic,strong) UIImage *qnNavigationBackgroundImage;



/****************************  状态栏相关 ***************************/

/*状态栏样式
 *Info.plist: View controller-based status bar appearance = YES
 *
 *UIStatusBarStyleDefault：状态栏显示 黑
 *UIStatusBarStyleLightContent：状态栏显示 白
 *UIStatusBarStyleDarkContent：状态栏显示 黑 API_AVAILABLE(ios(13.0)) = 3
 **eg. @(UIStatusBarStyleLightContent)
 */
@property(nonatomic,strong) NSNumber *qnPreferredStatusBarStyle;


/****************************  LOGO相关 ***************************/

/// LOGO图片
@property(nonatomic,strong) UIImage *qnLogoImage;
/// LOGO圆角 CGFloat eg.@(2.0)
@property(nonatomic,strong) NSNumber *qnLogoCornerRadius;
/// LOGO显隐 BOOL eg.@(NO)
@property(nonatomic,strong) NSNumber *qnLogoHiden;


/****************************  手机号相关 ***************************/

/// 手机号颜色
@property(nonatomic,strong) UIColor *qnPhoneNumberColor;
/// 手机号字体
@property(nonatomic,strong) UIFont *qnPhoneNumberFont;
/// 手机号对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)
@property(nonatomic,strong) NSNumber *qnPhoneNumberTextAlignment;


/****************************  一键登录按钮相关 ***************************/

/// 按钮文字
@property(nonatomic,copy) NSString *qnLoginBtnText;
/// 按钮文字颜色
@property(nonatomic,strong) UIColor*qnLoginBtnTextColor;
/// 按钮背景颜色
@property(nonatomic,strong) UIColor*qnLoginBtnBgColor;
/// 按钮文字字体
@property(nonatomic,strong) UIFont *qnLoginBtnTextFont;
/// 按钮背景图片
@property(nonatomic,strong) UIImage*qnLoginBtnNormalBgImage;
/// 按钮背景高亮图片
@property(nonatomic,strong) UIImage*qnLoginBtnHightLightBgImage;
/// 按钮背景不可用图片
@property(nonatomic,strong) UIImage*qnLoginBtnDisabledBgImage;
/// 按钮边框颜色
@property(nonatomic,strong) UIColor*qnLoginBtnBorderColor;
/// 按钮圆角 CGFloat eg.@(5)
@property(nonatomic,strong) NSNumber *qnLoginBtnCornerRadius;
/// 按钮边框 CGFloat eg.@(2.0)
@property(nonatomic,strong) NSNumber *qnLoginBtnBorderWidth;


/****************************  隐私条款相关 ***************************/

/*隐私条款Privacy
 注： 运营商隐私条款 不得隐藏
 用户条款不限制
 **/
/// 隐私条款名称颜色：@[基础文字颜色UIColor*,条款颜色UIColor*] eg.@[[UIColor lightGrayColor],[UIColor greenColor]]
@property(nonatomic,strong) NSArray<UIColor*> *qnAppPrivacyColor;
/// 隐私条款文字字体
@property(nonatomic,strong) UIFont*qnAppPrivacyTextFont;
/// 隐私条款文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)
@property(nonatomic,strong) NSNumber *qnAppPrivacyTextAlignment;
/// 运营商隐私条款书名号 默认NO 不显示 BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *qnAppPrivacyPunctuationMarks;

/// 多行时行距 CGFloat eg.@(2.0)
@property(nonatomic,strong) NSNumber*qnAppPrivacyLineSpacing;
/*
 *隐私条款Y一:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
 *@[NSSting,NSURL];
 */
@property(nonatomic,strong) NSArray *qnAppPrivacyFirst;
/*
 *隐私条款二:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
 *@[NSSting,NSURL];
 */
@property(nonatomic,strong) NSArray *qnAppPrivacySecond;
/*
 *隐私条款三:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
 *@[NSSting,NSURL];
 */
@property(nonatomic,strong) NSArray *qnAppPrivacyThird;

/*
 隐私协议文本拼接: DesTextFirst+运营商条款+DesTextSecond+隐私条款一+DesTextThird+隐私条款二+DesTextFourth+隐私条款三+DesTextLast
 **/
/// 描述文本 首部 default:"同意"
@property(nonatomic,copy) NSString *qnAppPrivacyNormalDesTextFirst;
/// 描述文本二 default:"和"m
@property(nonatomic,copy) NSString *qnAppPrivacyNormalDesTextSecond;
/// 描述文本三 default:"、"
@property(nonatomic,copy) NSString *qnAppPrivacyNormalDesTextThird;
/// 描述文本四 default:"、"
@property(nonatomic,copy) NSString *qnAppPrivacyNormalDesTextFourth;

@property(nonatomic,copy) NSString *qnAppPrivacyNormalDesTextLast;

/// 隐私协议WEB页面导航返回按钮图片
@property(nonatomic,strong) UIImage *qnAppPrivacyWebBackBtnImage;

/// UINavigationTintColor
@property(nonatomic,strong) UIColor*qnAppPrivacyWebNavigationTintColor;

/// 隐私协议标题文本属性（用户协议&&运营商协议）
@property(nonatomic,strong) NSDictionary *qnAppPrivacyWebAttributes;

/****************************  SLOGAN相关 ***************************/

/*SLOGAN
 注： 运营商品牌标签("中国**提供认证服务")，不得隐藏
 **/
// slogan文字字体
@property(nonatomic,strong) UIFont *qnSloganTextFont;
/// slogan文字颜色
@property(nonatomic,strong) UIColor*qnSloganTextColor;
/// slogan文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)
@property(nonatomic,strong) NSNumber *qnSlogaTextAlignment;
/// slogan默认不隐藏 eg.@(NO)
@property(nonatomic,strong) NSNumber *qnSloganTextHidden;
;


/****************************  CheckBox相关 ***************************/

/*CheckBox
 *协议勾选框，默认选中且在协议前显示
 *可在sdk_oauth.bundle中替换checkBox_unSelected、checkBox_selected图片
 *也可以通过属性设置选中和未选择图片
 **/
/// 协议勾选框（默认显示,放置在协议之前）BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *qnCheckBoxHidden;
/// 协议勾选框默认值（默认选中）BOOL eg.@(YES)
@property(nonatomic,strong) NSNumber *qnCheckBoxValue;
/// 协议勾选框 尺寸 NSValue->CGSize eg.[NSValue valueWithCGSize:CGSizeMake(25, 25)]
@property(nonatomic,strong) NSValue *qnCheckBoxSize;
/// 协议勾选框 UIButton.image图片缩进 UIEdgeInset eg.[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)]
@property(nonatomic,strong) NSValue *qnCheckBoxImageEdgeInsets;
/// 协议勾选框 设置CheckBox顶部与隐私协议控件顶部对齐 YES或大于0生效 eg.@(YES)
@property(nonatomic,strong) NSNumber *qnCheckBoxVerticalAlignmentToAppPrivacyTop;
/// 协议勾选框 设置CheckBox对齐后的偏移量,相对于对齐后的中心距离在当前垂直方向上的偏移
@property(nonatomic,strong) NSNumber *qnCheckBoxVerticalAlignmentOffset;

/// 协议勾选框 设置CheckBox顶部与隐私协议控件竖向中心对齐 YES或大于0生效 eg.@(YES)
@property(nonatomic,strong) NSNumber *qnCheckBoxVerticalAlignmentToAppPrivacyCenterY;
/// 协议勾选框 非选中状态图片
@property(nonatomic,strong) UIImage*qnCheckBoxUncheckedImage;
/// 协议勾选框 选中状态图片
@property(nonatomic,strong) UIImage*qnCheckBoxCheckedImage;

/**授权页自定义 "请勾选协议"提示框
 - containerView为loading的全屏蒙版view
 - 请自行在containerView添加自定义提示
 */
@property(nonatomic,copy)void(^checkBoxTipView)(UIView *containerView);
/// checkBox 未勾选时 提示文本，默认："请勾选协议"
@property(nonatomic,copy) NSString *qnCheckBoxTipMsg;
/// 使用sdk内部“一键登录”按钮点击时的吐丝提示("请勾选协议") - NO:默认使用sdk内部吐丝 YES:禁止使用
@property(nonatomic,strong) NSNumber *qnCheckBoxTipDisable;


/****************************  Loading相关 ***************************/

/// Loading 大小 CGSize eg.[NSValue valueWithCGSize:CGSizeMake(50, 50)]
//@property(nonatomic,strong) NSValue *qnLoadingSize;
///// Loading 圆角 float eg.@(5)
//@property(nonatomic,strong) NSNumber *qnLoadingCornerRadius;
///// Loading 背景色 UIColor eg.[UIColor colorWithRed:0.8 green:0.5 blue:0.8 alpha:0.8];
//@property(nonatomic,strong) UIColor *qnLoadingBackgroundColor;
///// UIActivityIndicatorViewStyle eg.@(UIActivityIndicatorViewStyleWhiteLarge)
//@property(nonatomic,strong) NSNumber *qnLoadingIndicatorStyle;
///// Loading Indicator渲染色 UIColor eg.[UIColor greenColor];
//@property(nonatomic,strong) UIColor *qnLoadingTintColor;
/**授权页自定义Loading
 - containerView为loading的全屏蒙版view
 - 请自行在containerView添加自定义loading
 - 设置block后，上述loading属性将无效
 */
@property(nonatomic,copy)void(^loadingView)(UIView *containerView);

// 添加自定义控件
/// 可设置背景色及添加控件
@property(nonatomic,copy)void(^customAreaView)(UIView *customAreaView);

/**横竖屏*/
/// 是否支持自动旋转 BOOL
//@property(nonatomic,strong) NSNumber *shouldAutorotate;
/*支持方向 UIInterfaceOrientationMask
 - 如果设置只支持竖屏，只需设置qnOrientationLayOutPortrait竖屏布局对象
 - 如果设置只支持横屏，只需设置qnOrientationLayOutLandscape横屏布局对象
 - 横竖屏均支持，需同时设置qnOrientationLayOutPortrait和qnOrientationLayOutLandscape
 */
//@property(nonatomic,strong) NSNumber *supportedInterfaceOrientations;
/// 默认方向 UIInterfaceOrientation
@property(nonatomic,strong) NSNumber *preferredInterfaceOrientationForPresentation;

/**以窗口方式显示授权页
 */
/// 以窗口方式显示 BOOL, default is NO
@property(nonatomic,strong) NSNumber *qnAuthTypeUseWindow;
/// 窗口圆角 float
@property(nonatomic,strong) NSNumber *qnAuthWindowCornerRadius;

/**qnAuthWindowModalTransitionStyle系统自带的弹出方式 仅支持以下三种
 UIModalTransitionStyleCoverVertical 底部弹出
 UIModalTransitionStyleCrossDissolve 淡入
 UIModalTransitionStyleFlipHorizontal 翻转显示
 */
@property(nonatomic,strong) NSNumber *qnAuthWindowModalTransitionStyle;

/**UIModalPresentationStyle
 *若使用窗口模式，请设置为UIModalPresentationOverFullScreen 或不设置
 *iOS13强制全屏，请设置为UIModalPresentationFullScreen
 *UIModalPresentationAutomatic API_AVAILABLE(ios(13.0)) = -2
 *默认UIModalPresentationFullScreen
 *eg. @(UIModalPresentationOverFullScreen)
 */
/// 授权页 ModalPresentationStyle
@property(nonatomic,strong) NSNumber *qnAuthWindowModalPresentationStyle;
/// 协议页 ModalPresentationStyle （授权页使用窗口模式时，协议页强制使用模态弹出）
@property(nonatomic,strong) NSNumber *qnAppPrivacyWebModalPresentationStyle;


/// 授权页面present弹出时animate动画设置，默认带动画，eg. @(YES)
@property(nonatomic,strong) NSNumber *qnAuthWindowPresentingAnimate;
/// sdk自带返回键：授权页面dismiss时animate动画设置，默认带动画，eg. @(YES)
@property(nonatomic,strong) NSNumber *qnAuthWindowDismissAnimate;
/// 弹窗的MaskLayer，用于自定义窗口形状

//竖屏布局配置对象 -->创建一个布局对象，设置好控件约束属性值，再设置到此属性中
/**竖屏：UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown
 *eg.   qnUIConfigure *baseUIConfigure = [qnUIConfigure new];
 *     qnOrientationLayOut *qnOrientationLayOutPortrait = [qnOrientationLayOut new];
 *     qnOrientationLayOutPortrait.qnLayoutPhoneCenterY = @(0);
 *     qnOrientationLayOutPortrait.qnLayoutPhoneLeft = @(50*screenScale);
 *     ...
 *     baseUIConfigure.qnOrientationLayOutPortrait = qnOrientationLayOutPortrait;
 */
@property(nonatomic,strong) QNOrientationLayOut *qnOrientationLayOutPortrait;

//横屏布局配置对象 -->创建一个布局对象，设置好控件约束属性值，再设置到此属性中
/**横屏：UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight
 *eg.   qnUIConfigure *baseUIConfigure = [qnUIConfigure new];
 *     qnOrientationLayOut *qnOrientationLayOutLandscape = [qnOrientationLayOut new];
 *     qnOrientationLayOutLandscape.qnLayoutPhoneCenterY = @(0);
 *     qnOrientationLayOutLandscape.qnLayoutPhoneLeft = @(50*screenScale);
 *     ...
 *     baseUIConfigure.qnOrientationLayOutLandscape = qnOrientationLayOutLandscape;
 */
@property(nonatomic,strong) QNOrientationLayOut *qnOrientationLayOutLandscape;

/// 默认界面配置
+ (QNOrientationLayOut *)qnDefaultUIConfigure;

@end



/**横竖屏布局配置对象
 配置页面布局相关属性
 */
@interface QNOrientationLayOut : NSObject
/**LOGO图片*/
/// 约束均相对vc.view
@property(nonatomic,strong) NSNumber *qnLayoutLogoLeft;
@property(nonatomic,strong) NSNumber *qnLayoutLogoTop;
@property(nonatomic,strong) NSNumber *qnLayoutLogoRight;
@property(nonatomic,strong) NSNumber *qnLayoutLogoBottom;
@property(nonatomic,strong) NSNumber *qnLayoutLogoWidth;
@property(nonatomic,strong) NSNumber *qnLayoutLogoHeight;
@property(nonatomic,strong) NSNumber *qnLayoutLogoCenterX;
@property(nonatomic,strong) NSNumber *qnLayoutLogoCenterY;

/**手机号显示控件*/
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *qnLayoutPhoneLeft;
@property(nonatomic,strong) NSNumber *qnLayoutPhoneTop;
@property(nonatomic,strong) NSNumber *qnLayoutPhoneRight;
@property(nonatomic,strong) NSNumber *qnLayoutPhoneBottom;
@property(nonatomic,strong) NSNumber *qnLayoutPhoneWidth;
@property(nonatomic,strong) NSNumber *qnLayoutPhoneHeight;
@property(nonatomic,strong) NSNumber *qnLayoutPhoneCenterX;
@property(nonatomic,strong) NSNumber *qnLayoutPhoneCenterY;

/** 一键登录按钮 控件
 注： 一键登录授权按钮 不得隐藏
 */
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnLeft;
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnTop;
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnRight;
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnBottom;
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnWidth;
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnHeight;
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnCenterX;
@property(nonatomic,strong) NSNumber *qnLayoutLoginBtnCenterY;

/** 隐私条款Privacy
 注： 运营商隐私条款 不得隐藏， 用户条款不限制
 */
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyLeft;
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyTop;
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyRight;
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyBottom;
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyWidth;
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyHeight;
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyCenterX;
@property(nonatomic,strong) NSNumber *qnLayoutAppPrivacyCenterY;

/** Slogan 运营商品牌标签："认证服务由中国移动/联通/电信提供" label
 注： 运营商品牌标签，不得隐藏
 */
/// layout 约束均相对vc.view
@property(nonatomic,strong) NSNumber *qnLayoutSloganLeft;
@property(nonatomic,strong) NSNumber *qnLayoutSloganTop;
@property(nonatomic,strong) NSNumber *qnLayoutSloganRight;
@property(nonatomic,strong) NSNumber *qnLayoutSloganBottom;
@property(nonatomic,strong) NSNumber *qnLayoutSloganWidth;
@property(nonatomic,strong) NSNumber *qnLayoutSloganHeight;
@property(nonatomic,strong) NSNumber *qnLayoutSloganCenterX;
@property(nonatomic,strong) NSNumber *qnLayoutSloganCenterY;


/** 窗口模式 */
/// 窗口中心：CGPoint X Y
@property(nonatomic,strong) NSValue *qnAuthWindowOrientationCenter;
/// 窗口左上角：frame.origin：CGPoint X Y
@property(nonatomic,strong) NSValue *qnAuthWindowOrientationOrigin;
/// 窗口大小：宽 float
@property(nonatomic,strong) NSNumber *qnAuthWindowOrientationWidth;
/// 窗口大小：高 float
@property(nonatomic,strong) NSNumber *qnAuthWindowOrientationHeight;


@end

NS_ASSUME_NONNULL_END

