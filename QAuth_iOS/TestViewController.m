//
//  TestViewController.m
//  QAuth_iOS
//
//  Created by sunmu on 2023/5/22.
//

#import "TestViewController.h"
#import "PhoneNumberCheckController.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "QNPhoneNumberDemoCode.h"
#import <CLConsole/CLConsole.h>
#import <NSObject+YYModel.h>
#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>

#import <QNAuthSDK/QNAuthSDK.h>

@interface TestNavViewController ()
@end
@implementation TestNavViewController
@end

@interface TestViewController ()
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@end

@implementation TestViewController

-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    
    UIImageView * qiniuLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_main"]];
    qiniuLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:qiniuLogo];
    [qiniuLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(self.view).multipliedBy(0.35);
        make.centerY.mas_equalTo(-self.view.bounds.size.height*0.25);
    }];
    
    UIButton * openAuthAPI_CustomVC = [[UIButton alloc]init];
    openAuthAPI_CustomVC.layer.cornerRadius = 22.5;
    openAuthAPI_CustomVC.layer.masksToBounds = YES;
    [openAuthAPI_CustomVC setBackgroundColor:[UIColor colorWithRed:38/255.0 green:94/255.0 blue:250/255.0 alpha:1]];
    [openAuthAPI_CustomVC setTitle:@"拉起授权界面" forState:(UIControlStateNormal)];
    [openAuthAPI_CustomVC addTarget:self action:@selector(openAuthAPIClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:openAuthAPI_CustomVC];
    
    UIButton * localPhoneNumberCheckBtn = [[UIButton alloc]init];
    localPhoneNumberCheckBtn.layer.cornerRadius = 22.5;
    localPhoneNumberCheckBtn.layer.masksToBounds = YES;
    [localPhoneNumberCheckBtn setBackgroundColor:[UIColor colorWithRed:38/255.0 green:94/255.0 blue:250/255.0 alpha:1]];
    [localPhoneNumberCheckBtn setTitle:@"七牛本机认证" forState:(UIControlStateNormal)];
    [localPhoneNumberCheckBtn addTarget:self action:@selector(localPhoneNumberCheckBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:localPhoneNumberCheckBtn];

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems: @[@"演示一", @"演示二", @"演示三", @"演示四",@"演示五",@"演示六"]];
    [self.view addSubview:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl = segmentedControl;
    
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0).offset(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(self.view).multipliedBy(0.8);
        make.height.mas_equalTo(45);
    }];
    

    [openAuthAPI_CustomVC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0).offset(100);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(self.view).multipliedBy(0.8);
        make.height.mas_equalTo(45);
    }];
    [localPhoneNumberCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(openAuthAPI_CustomVC);
        make.top.equalTo(openAuthAPI_CustomVC.mas_bottom).offset(30);
    }];
    
    
}


/// 展示授权页
-(void)openAuthAPIClick:(UIButton *)sender{
    //建议做防止快速点击
    [sender setEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender setEnabled:YES];
    });
    [SVProgressHUD show];
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

    __weak typeof(self) weakSelf = self;
    
    static  int a =0;
    
    int i = a%2;

    NSString *st = [@"configureMake" stringByAppendingFormat:@"%d",_segmentedControl.selectedSegmentIndex];

    QNUIConfigure * baseUIConfigure = [self performSelector:NSSelectorFromString(st)];

    a++;

    
    [QNAuthSDKManager quickAuthLoginWithConfigure:baseUIConfigure openLoginAuthListener:^(QNCompleteResult * _Nonnull completeResult) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();

        //建议做防止快速点击
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [sender setEnabled:YES];
        });
        
        if (completeResult.error) {
            CLConsoleLog(@"openLoginAuthListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);
        }else{
            CLConsoleLog(@"openLoginAuthListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);
        }

    } oneKeyLoginListener:^(QNCompleteResult * _Nonnull completeResult) {
        
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();

        __strong typeof(self) strongSelf = weakSelf;
 
        if (completeResult.error) {
            CLConsoleLog(@"oneKeyLoginListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);
            
            
            //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
            if (completeResult.code == 1011){
                //用户取消登录（点返回）
                //处理建议：如无特殊需求可不做处理，仅作为交互状态回调，此时已经回到当前用户自己的页面
                //点击sdk自带的返回，无论是否设置手动销毁，授权页面都会强制关闭
            }  else{
                //处理建议：其他错误代码表示七牛通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
                //1003    一键登录获取token失败
                //其他     其他错误//
                
                //关闭授权页
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        }else{
            
            CLConsoleLog(@"oneKeyLoginListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);

            NSString *token = completeResult.data[@"token"];
            
            //测试置换手机号
            [QNPhoneNumberDemoCode mobileLoginWithtoken:token completion:^(id  _Nullable responseObject, NSError * _Nonnull error) {
               
                //关闭页面
                [QNAuthSDKManager finishAuthControllerAnimated:YES Completion:^{
                }];
                NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
             
                if (code == 0) {
                    CLConsoleLog(@"免密登录成功");
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"免密登录成功"]];
                    
                }else{
                    
                    if (responseObject) {
                        CLConsoleLog(@"免密登录解密失败:%@",responseObject);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"免密登录解密失败:%@",responseObject]];
                    }else{
                        CLConsoleLog(@"免密登录解密失败:%@",error.localizedDescription);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"免密登录解密失败:%@",error.localizedDescription]];
                    }
                }

            }];
        }
    }];
}

//本机号认证
- (void)localPhoneNumberCheckBtnClicked {
    PhoneNumberCheckController * vc = [PhoneNumberCheckController new];
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 样式案例

-(QNUIConfigure *)configureMake0{
    
    QNUIConfigure *configure = [[QNUIConfigure alloc] init];
    configure.viewController = self;
    //导航栏设置
    configure.qnNavigationBarHidden = @(YES);
    configure.qnNavigationBottomLineHidden = @(YES);
    configure.qnNavigationBackgroundClear = @(YES);
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    configure.qnNavigationLeftControl = leftItem;
    //右侧按钮
    UIBarButtonItem *rigtItem = [[UIBarButtonItem alloc] initWithTitle:@"密码登录" style:UIBarButtonItemStylePlain target:self action:nil];
    configure.qnNavigationRightControl = rigtItem;
    //logo
    configure.qnLogoImage = [UIImage imageNamed:@"image_main"];
    //手机掩码配置
    configure.qnPhoneNumberFont = [UIFont systemFontOfSize:25 weight:0.8];
    configure.qnPhoneNumberColor = [UIColor blackColor];
    configure.qnPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    //运营商slog
    configure.qnSloganTextFont = [UIFont systemFontOfSize:14];
    configure.qnSlogaTextAlignment = @(NSTextAlignmentRight);
    configure.qnSloganTextColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    
    //一键登录按钮
    configure.qnLoginBtnText = @"本机号码一键登录";
    configure.qnLoginBtnBgColor = [UIColor systemBlueColor];
    configure.qnLoginBtnTextColor = [UIColor whiteColor];
    configure.qnLoginBtnTextFont = [UIFont systemFontOfSize:17];
    
    //协议
    configure.qnCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.qnCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.qnCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.qnCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.qnCheckBoxValue = @(NO);

    configure.qnAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.qnAppPrivacyFirst = @[@"用户协议",[NSURL URLWithString:@"https://www.qiniu.com/user-agreement"]];
    configure.qnAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.qnAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.qnAppPrivacyLineSpacing = @(3.0);
    
    UIColor *normalColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    UIColor *privacyColor = [UIColor systemBlueColor];
    configure.qnAppPrivacyColor = @[normalColor,privacyColor];
    
    
    //布局
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //logo
    QNOrientationLayOut *layOut = [[QNOrientationLayOut alloc] init];
    layOut.qnLayoutLogoCenterX = @(0);
    layOut.qnLayoutLogoTop = @(top + 44 + 40*scale);
    layOut.qnLayoutLogoWidth = @(90*scale);
    layOut.qnLayoutLogoHeight = layOut.qnLayoutLogoWidth;//依据图片的宽高比例
    
    top += 44 + 40*scale + layOut.qnLayoutLogoHeight.floatValue;
    
    //手机掩码
    layOut.qnLayoutPhoneTop = @(top + 60*scale);
    layOut.qnLayoutPhoneCenterX = @(0);
    layOut.qnLayoutPhoneHeight = @(35);
    
    top += 60*scale + layOut.qnLayoutPhoneHeight.floatValue;
    
    //slog
    layOut.qnLayoutSloganTop = @(top +25*scale);
    layOut.qnLayoutSloganHeight = @(25*scale);
    
    CGFloat slogTop = layOut.qnLayoutSloganTop.floatValue;
    CGFloat slogHeigh = layOut.qnLayoutSloganHeight.floatValue;
    
    top += 25*scale + layOut.qnLayoutSloganHeight.floatValue;
    
    //loginbtn
    layOut.qnLayoutLoginBtnTop =  @(top + 25*scale);
    layOut.qnLayoutLoginBtnLeft = @(25*scale);
    layOut.qnLayoutLoginBtnRight = @(-25*scale);
    layOut.qnLayoutLoginBtnHeight = @(45*scale);
    configure.qnLoginBtnCornerRadius = @(layOut.qnLayoutLoginBtnHeight.floatValue/2.0);
    
    layOut.qnLayoutSloganLeft = @(configure.qnLoginBtnCornerRadius.floatValue + layOut.qnLayoutLoginBtnLeft.floatValue);
    
    
    top += 25*scale + layOut.qnLayoutLoginBtnHeight.floatValue;
    
    //协议
    layOut.qnLayoutAppPrivacyTop  = @(top + 25*scale);
    layOut.qnLayoutAppPrivacyLeft = @(25*scale + 25);
    layOut.qnLayoutAppPrivacyRight = @(-25*scale);
    
    
    top += 25*scale + 50;
    
    //自定义控件
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        //使用其他手机号
        UIButton *otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherPhoneButton setTitle:@"使用其他手机 >" forState:UIControlStateNormal];
        [otherPhoneButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [otherPhoneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [otherPhoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [customAreaView addSubview:otherPhoneButton];
        
        [otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(slogTop);
            make.right.mas_equalTo(-25*scale - 22.5*scale);
            make.height.mas_equalTo(slogHeigh);
        }];
        
        //其他方式登录
        UIView *contentView = [[UIView alloc] init];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:leftLineView];
        
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(contentView);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(contentView);
            make.width.mas_equalTo(0.1*width);
        }];
        
        UILabel *otherLabel = [[UILabel alloc] init];
        otherLabel.text = @"使用其他账号登录";
        otherLabel.font = [UIFont systemFontOfSize:14];
        otherLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:otherLabel];
        
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(leftLineView.mas_right).offset(10*scale);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(otherLabel.mas_right).offset(10*scale);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(0.1*width);
            make.right.equalTo(contentView.mas_right);
            make.centerY.equalTo(leftLineView);
        }];
        
        [customAreaView addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(top + 25*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
        //其他按钮视图
        __block UIView *weiXinView;
        __block UIView *qqView;
        __block UIView *weiBoView;
        
        NSArray *imageNames = @[@"weixin",@"qq",@"weibo"];
        NSArray *titiles = @[@"微信",@"QQ",@"微博"];
        
        [imageNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView *buttonContentView = [[UIView alloc] init];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:idx];
            [button setBackgroundImage :[UIImage imageNamed:obj] forState:UIControlStateNormal];
            [buttonContentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(0.15*width);
                make.height.mas_equalTo(0.15*width);
                make.top.left.right.equalTo(buttonContentView).offset(5);
            }];
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.text = titiles[idx];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.font = [UIFont systemFontOfSize:15];
            tipLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            [buttonContentView addSubview:tipLabel];
            
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(button.mas_bottom).offset(10);
                make.left.right.equalTo(buttonContentView);
                make.bottom.equalTo(buttonContentView).offset(-2);
                make.height.mas_equalTo(25);
            }];
            
            if (idx == 0) {
                
                weiXinView = buttonContentView;
            }else if (idx == 1){
                
                qqView = buttonContentView;
            }else{
                
                weiBoView = buttonContentView;
            }
            
        }];
        
        UIView *buttonContentView = [[UIView alloc] init];
        
        [buttonContentView addSubview:weiXinView];
        [weiXinView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.equalTo(buttonContentView);
        }];
        
        
        [buttonContentView addSubview:qqView];
        [qqView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(buttonContentView);
            make.left.equalTo(weiXinView.mas_right).offset(0.13*width);
        }];
        
        
        [buttonContentView addSubview:weiBoView];
        [weiBoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(buttonContentView);
            make.left.equalTo(qqView.mas_right).offset(0.13*width);
        }];
        
        [customAreaView addSubview:buttonContentView];
        
        [buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(contentView.mas_bottom).offset(15*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
    };
    
    
    configure.qnOrientationLayOutPortrait = layOut;
    
    return configure;
    
}


-(QNUIConfigure *)configureMake1{
    
    QNUIConfigure *configure = [[QNUIConfigure alloc] init];
    configure.viewController = self;
    configure.qnNavigationBarHidden = @(YES);
    configure.qnLogoHiden = @(YES);
    configure.qnBackgroundImg = [UIImage imageNamed:@"bb886219260f91b2be4ad0a913616be2"];
    //手机掩码
    configure.qnPhoneNumberFont = [UIFont systemFontOfSize:18 weight:0.5];
    configure.qnPhoneNumberColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    configure.qnPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    
    //一件登录按钮
    configure.qnLoginBtnText = @"一键登录";
    configure.qnLoginBtnTextColor = [UIColor whiteColor];
    configure.qnLoginBtnTextFont = [UIFont systemFontOfSize:16 weight:0.2];
    configure.qnLoginBtnBgColor = [UIColor colorWithRed:225/255.0 green:0 blue:56/255.0 alpha:1.0];
    
    //运营商slog
    configure.qnSlogaTextAlignment = @(NSTextAlignmentCenter);
    configure.qnSloganTextFont = [UIFont systemFontOfSize:15];
    configure.qnSloganTextColor = [UIColor lightGrayColor];
    
    //协议
    configure.qnCheckBoxHidden = @(YES);
    configure.qnCheckBoxValue = @(YES);
    configure.qnAppPrivacyNormalDesTextFirst = @"同意";
    configure.qnAppPrivacyNormalDesTextSecond = @"和";
    configure.qnAppPrivacyFirst = @[@"《用户协议》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyNormalDesTextThird = @"、";
    configure.qnAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyPunctuationMarks = @(YES);
    configure.qnAppPrivacyColor = @[[UIColor lightGrayColor],[UIColor lightGrayColor]];
    configure.qnAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.qnAppPrivacyLineSpacing = @(3.0);
    configure.qnAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    
    //布局
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    

    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    CGFloat top = height - 255*scale;
    
    CGFloat currentY = top;
    
    QNOrientationLayOut *clOrientationLayOut = [[QNOrientationLayOut alloc] init];
    
    //手机掩码
    clOrientationLayOut.qnLayoutPhoneTop = @(top);
    clOrientationLayOut.qnLayoutPhoneLeft = @(40*scale);
    clOrientationLayOut.qnLayoutPhoneRight = @(-40*scale);
    clOrientationLayOut.qnLayoutPhoneHeight = @(25*scale);
    
    currentY = clOrientationLayOut.qnLayoutPhoneTop.floatValue + clOrientationLayOut.qnLayoutPhoneHeight.floatValue;
    
    //一件登录按钮
    clOrientationLayOut.qnLayoutLoginBtnTop = @(currentY + 20*scale);
    clOrientationLayOut.qnLayoutLoginBtnLeft = @(40*scale);
    clOrientationLayOut.qnLayoutLoginBtnRight = @(-40*scale);
    clOrientationLayOut.qnLayoutLoginBtnHeight = @(50*scale);
    
    configure.qnLoginBtnCornerRadius = @(clOrientationLayOut.qnLayoutLoginBtnHeight.floatValue/2.0);
    
    
    currentY =  clOrientationLayOut.qnLayoutLoginBtnTop.floatValue + clOrientationLayOut.qnLayoutLoginBtnHeight.floatValue;
    
    //slog
    clOrientationLayOut.qnLayoutSloganTop = @(currentY + 20*scale);
    clOrientationLayOut.qnLayoutSloganLeft = @(40*scale);
    clOrientationLayOut.qnLayoutSloganRight = @(-40*scale);
    clOrientationLayOut.qnLayoutSloganHeight = @(20*scale);
    
    currentY = clOrientationLayOut.qnLayoutSloganTop.floatValue + clOrientationLayOut.qnLayoutSloganHeight.floatValue;
    
    //协议
    clOrientationLayOut.qnLayoutAppPrivacyTop = @(currentY +20*scale);
    clOrientationLayOut.qnLayoutAppPrivacyLeft = @(40*scale);
    clOrientationLayOut.qnLayoutAppPrivacyRight = @(-40*scale);
    clOrientationLayOut.qnLayoutAppPrivacyHeight = @(50*scale);
    
    currentY  = clOrientationLayOut.qnLayoutAppPrivacyTop.floatValue + clOrientationLayOut.qnLayoutAppPrivacyHeight.floatValue;
    
    currentY += 20*scale;
    
    
    
    configure.qnOrientationLayOutPortrait = clOrientationLayOut;
    
    
    __weak typeof(self) weakSelf = self;
    
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        UIView *cornerView = [[UIView alloc] init];
        cornerView.layer.masksToBounds = YES;
        cornerView.layer.cornerRadius  = 10.0;
        cornerView.backgroundColor = [UIColor whiteColor];
        [customAreaView addSubview:cornerView];
        
        [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(top - 30*scale);
            make.left.mas_equalTo(20*scale);
            make.right.mas_equalTo(-20*scale);
            make.height.mas_equalTo(currentY - top + 30*scale);
        }];
        
//        UIButton *cannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cannelButton setTitle:@"取消登录" forState:UIControlStateNormal];
//        [cannelButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
//        [cannelButton setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [cannelButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
//        [customAreaView addSubview:cannelButton];
//        [cannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.mas_offset(top);
//            make.left.equalTo(cornerView).offset(20*scale);
//            make.height.mas_equalTo(30*scale);
//
//        }];
        
        
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherButton setTitle:@"更换号码" forState:UIControlStateNormal];
        [otherButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [otherButton setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
        [otherButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:otherButton];
        [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(top);
            make.right.equalTo(cornerView).offset(-20*scale);
            make.height.mas_equalTo(25*scale);
            
        }];
        
        
    };
    
    return configure;
    
}


-(QNUIConfigure *)configureMake2{
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    //黑
    UIColor *color1 = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    //灰
    UIColor *color2 = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    //墨绿
    UIColor *color3 = [UIColor colorWithRed:54/255.0 green:134/255.0 blue:141/255.0 alpha:1.0];
    
    
    QNUIConfigure *configure = [[QNUIConfigure alloc] init];
    configure.viewController = self;
    //导航栏
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(dismis)];
    configure.qnNavigationLeftControl = closeButtonItem;
    configure.qnNavigationBackgroundClear = @(YES);
    configure.qnNavigationBottomLineHidden = @(YES);
    
    //隐藏logo
    configure.qnLogoHiden = @(YES);
    
    //掩码
    configure.qnPhoneNumberFont = [UIFont systemFontOfSize:22];
    configure.qnPhoneNumberColor = color1;
    configure.qnPhoneNumberTextAlignment = @(NSTextAlignmentLeft);
    
    //登录按钮
    configure.qnLoginBtnText = @"立即登录";
    configure.qnLoginBtnBgColor = color3;
    configure.qnLoginBtnTextFont = [UIFont systemFontOfSize:16 weight:0.3];
    configure.qnLoginBtnCornerRadius = @(5.0);
    configure.qnLoginBtnTextColor = [UIColor whiteColor];
    
    //slog
    configure.qnSloganTextFont = [UIFont systemFontOfSize:14 weight:0.2];
    configure.qnSloganTextColor = color2;
    
    //协议
    configure.qnCheckBoxHidden = @(YES);
    configure.qnCheckBoxValue = @(YES);
    configure.qnAppPrivacyNormalDesTextFirst = @"注册/登录即代表您年满18岁，已认真阅读并同意接受七牛";
    configure.qnAppPrivacyFirst = @[@"《服务条款》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyNormalDesTextSecond = @"、";
    configure.qnAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyNormalDesTextThird= @",以及同意";
    configure.qnAppPrivacyPunctuationMarks = @(YES);
    configure.qnAppPrivacyLineSpacing = @(3.0);
    configure.qnAppPrivacyTextFont = [UIFont systemFontOfSize:16 weight:0.3];
    configure.qnAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.qnAppPrivacyColor = @[color2,color3];
    
    
    QNOrientationLayOut *layout = [[QNOrientationLayOut alloc] init];
    configure.qnOrientationLayOutPortrait = layout;
    
    
    CGFloat top = 180*scale + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44;//顶部视图的高度以及间距只和
    
    //掩码
    layout.qnLayoutPhoneTop = @(top) ;
    layout.qnLayoutPhoneLeft = @(30*scale);
    layout.qnLayoutLogoHeight = @(30*scale);
    
    
    top  = layout.qnLayoutPhoneTop.floatValue + layout.qnLayoutLogoHeight.floatValue;
    
    //登录按钮
    layout.qnLayoutLoginBtnTop = @(top + 30*scale);
    layout.qnLayoutLoginBtnLeft = @(30*scale);
    layout.qnLayoutLoginBtnRight = @(-30*scale);
    layout.qnLayoutLoginBtnHeight = @(50*scale);
    
    
    top = layout.qnLayoutLoginBtnTop.floatValue + layout.qnLayoutLoginBtnHeight.floatValue;
    
    //slog
    layout.qnLayoutSloganTop = @(top + 10*scale);
    layout.qnLayoutSloganLeft = @(30*scale);
    layout.qnLayoutLogoHeight = @(25*scale);
        
    top  = layout.qnLayoutSloganTop.floatValue + layout.qnLayoutLogoHeight.floatValue;
    
    CGFloat slogBottom = top;
    
    
    top += 110*scale + 0.15*width;
    
    
    //协议
    layout.qnLayoutAppPrivacyTop = @(top + 20*scale);
    layout.qnLayoutAppPrivacyLeft = @(30*scale);
    layout.qnLayoutAppPrivacyRight = @(-30*scale);
    
    __weak typeof(self) weakSelf = self;
    
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        customAreaView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *tipLabel1 = [[UILabel alloc] init];
        tipLabel1.text = @"本机号码快捷登录";
        tipLabel1.font = [UIFont systemFontOfSize:30 weight:1.0];
        tipLabel1.textColor = color1;
        [customAreaView addSubview:tipLabel1];
        
        [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(50*scale + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44);
            make.left.mas_equalTo(30*scale);
            make.height.mas_equalTo(40*scale);
        }];
        
        
        UILabel *tipLabel2 = [[UILabel alloc] init];
        tipLabel2.text = @"本机号码未注册将自动创建新账号";
        tipLabel2.font = [UIFont systemFontOfSize:16 weight:0.2];
        tipLabel2.textColor = color2;
        [customAreaView addSubview:tipLabel2];
        
        [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.equalTo(tipLabel1.mas_bottom).offset(5*scale);
            make.left.equalTo(tipLabel1);
            make.height.mas_equalTo(25*scale);
        }];
        
        UILabel *tipLabel3 = [[UILabel alloc] init];
        tipLabel3.text = @"本机号码";
        tipLabel3.font = [UIFont systemFontOfSize:16 weight:0.2];
        tipLabel3.textColor = color1;
        [customAreaView addSubview:tipLabel3];
        
        [tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(tipLabel2);
            make.top.equalTo(tipLabel2.mas_bottom).offset(30*scale);
            make.height.mas_equalTo(25*scale);
        }];
        
        //其他手机号登录
        UIButton *otherPhone = [UIButton buttonWithType:UIButtonTypeSystem];
        [otherPhone setTitle:@"使用其他手机号" forState:UIControlStateNormal];
        [otherPhone.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.3]];
        [otherPhone setTitleColor:color3 forState:UIControlStateNormal];
        [otherPhone addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:otherPhone];
        
        [otherPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo( slogBottom + 20*scale);
            make.left.mas_equalTo(30*scale);
            make.height.mas_equalTo(25*scale);
        }];
        
        //或者使用微信登录
        UILabel *weixinLabel = [[UILabel alloc] init];
        weixinLabel.text = @"或使用微信登录";
        weixinLabel.textColor = color2;
        weixinLabel.font = [UIFont systemFontOfSize:16 weight:0.3];
        [customAreaView addSubview:weixinLabel];
        
        [weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(otherPhone.mas_bottom).offset(20*scale);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(25*scale);
            
        }];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage :[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [customAreaView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0.15*width);
            make.height.mas_equalTo(0.15*width);
            make.top.equalTo(weixinLabel.mas_bottom).offset(20*scale);
            make.centerX.mas_equalTo(0);
            
        }];
    
    };
    
    
    return configure;
}


-(QNUIConfigure *)configureMake3{
    
    //黑
    UIColor *color1 = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    //灰
    UIColor *color2 = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    //天蓝
    UIColor *color3 = [UIColor colorWithRed:60/255.0 green:160/255.0 blue:247/255.0 alpha:1.0];
    
    
    QNUIConfigure *configure = [[QNUIConfigure alloc] init];
    configure.viewController = self;
    
    //导航设置
    configure.qnNavigationBarHidden = @(YES);
    
    //logo
    configure.qnLogoHiden = @(YES);
    
    //掩码
    configure.qnPhoneNumberFont = [UIFont systemFontOfSize:22];
    configure.qnPhoneNumberColor = color1;
    configure.qnPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    
    //slog
    configure.qnSloganTextFont = [UIFont systemFontOfSize:14];
    configure.qnSloganTextColor = color2;
    configure.qnSlogaTextAlignment = @(NSTextAlignmentCenter);
    
    //登录按钮
    configure.qnLoginBtnText = @"本机号一键登录";
    configure.qnLoginBtnTextFont = [UIFont systemFontOfSize:18 weight:0.2];
    configure.qnLoginBtnTextColor = [UIColor whiteColor];
    configure.qnLoginBtnBgColor = color3;
    configure.qnLoginBtnCornerRadius = @(5);
    
    //协议
    configure.qnCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.qnCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.qnCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.qnCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.qnCheckBoxValue = @(YES);

    configure.qnAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.qnAppPrivacyFirst = @[@"《用户协议》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyNormalDesTextSecond = @"、";
    configure.qnAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyNormalDesTextThird = @"和";
    configure.qnAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.qnAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.qnAppPrivacyLineSpacing = @(3.0);
    configure.qnAppPrivacyPunctuationMarks = @(YES);
    configure.qnAppPrivacyColor = @[color2,color3];
    configure.qnAuthTypeUseWindow = @(YES);
    
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height  = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    QNOrientationLayOut *cLOrientationLayOut = [[QNOrientationLayOut alloc] init];
    configure.qnOrientationLayOutPortrait = cLOrientationLayOut;
        
    CGFloat top = height/2.0 - 340*scale/2.0;
    
    //手机掩码
    cLOrientationLayOut.qnLayoutPhoneTop = @(top + 70*scale);
    cLOrientationLayOut.qnLayoutPhoneLeft = @(50*scale);
    cLOrientationLayOut.qnLayoutPhoneCenterX = @(0);
    cLOrientationLayOut.qnLayoutPhoneHeight = @(30*scale);
    
    top = cLOrientationLayOut.qnLayoutPhoneTop.floatValue + cLOrientationLayOut.qnLayoutPhoneHeight.floatValue;
    
    //slog
    cLOrientationLayOut.qnLayoutSloganTop = @(top + 20*scale);
    cLOrientationLayOut.qnLayoutSloganLeft = @(50*scale);
    cLOrientationLayOut.qnLayoutSloganCenterX = @(0);
    cLOrientationLayOut.qnLayoutSloganHeight = @(25*scale);
    
    
    top = cLOrientationLayOut.qnLayoutSloganTop.floatValue + cLOrientationLayOut.qnLayoutSloganHeight.floatValue;
    
    //登录按钮
    cLOrientationLayOut.qnLayoutLoginBtnTop = @(top + 25*scale);
    cLOrientationLayOut.qnLayoutLoginBtnLeft = @(50*scale);
    cLOrientationLayOut.qnLayoutLoginBtnRight = @(-50*scale);
    cLOrientationLayOut.qnLayoutLoginBtnHeight = @(45*scale);
    
    top = cLOrientationLayOut.qnLayoutLoginBtnTop.floatValue + cLOrientationLayOut.qnLayoutLoginBtnHeight.floatValue;
    
    //协议
    cLOrientationLayOut.qnLayoutAppPrivacyTop = @(top + 70*scale);
    cLOrientationLayOut.qnLayoutAppPrivacyLeft = @(50*scale + 30);
    cLOrientationLayOut.qnLayoutAppPrivacyRight = @(-50*scale);
    
    top  = cLOrientationLayOut.qnLayoutAppPrivacyTop.floatValue + cLOrientationLayOut.qnLayoutAppPrivacyHeight.floatValue;
    
    
    __weak typeof(self) weakSelf = self;
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        customAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UIView *conerView = [[UIView alloc] init];
        conerView.backgroundColor = [UIColor whiteColor];
        conerView.layer.cornerRadius = 10.0;
        [customAreaView addSubview:conerView];
        
        [conerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.mas_equalTo(cLOrientationLayOut.qnLayoutPhoneTop.floatValue - 70*scale);
            make.left.mas_equalTo(30*scale);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(340*scale + 35*scale);
            
        }];
        
        //关闭按钮
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [close addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [conerView addSubview:close];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(10*scale);
            make.right.mas_offset(-10*scale);
            make.width.height.mas_equalTo(25*scale);
        }];
        
        
        UILabel *welcomLabel = [[UILabel alloc] init];
        welcomLabel.text = @"欢迎使用七牛";
        welcomLabel.font = [UIFont systemFontOfSize:15];
        welcomLabel.textColor = color1;
        welcomLabel.textAlignment = NSTextAlignmentCenter;
        [customAreaView addSubview:welcomLabel];
        
        [welcomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.centerY.mas_equalTo(conerView.mas_top).offset(40*scale);
            make.left.mas_equalTo(50*scale);
            make.centerX.mas_equalTo(0);
            make.height.mas_offset(25*scale);
             
        }];
        
        //其他方式登录
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherButton setTitle:@"其他方式登录" forState:UIControlStateNormal];
        [otherButton setTitleColor:color1 forState:UIControlStateNormal];
        [otherButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [otherButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:otherButton];
        
        [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(customAreaView.mas_top).offset(cLOrientationLayOut.qnLayoutLoginBtnTop.floatValue + cLOrientationLayOut.qnLayoutLoginBtnHeight.floatValue + 35*scale);

            
        }];
    };
    
    return configure;
    
}

-(QNUIConfigure *)configureMake4{
    
    QNUIConfigure *configure = [[QNUIConfigure alloc] init];
    configure.viewController = self;
    //导航栏设置
    configure.qnNavigationBarHidden = @(NO);
    configure.qnNavigationBottomLineHidden = @(YES);
    configure.qnNavigationBackgroundClear = @(YES);
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    configure.qnNavigationLeftControl = leftItem;
    //logo
    configure.qnLogoImage = [UIImage imageNamed:@"image_main"];
    //手机掩码配置
    configure.qnPhoneNumberFont = [UIFont systemFontOfSize:25 weight:0.8];
    configure.qnPhoneNumberColor = [UIColor blackColor];
    configure.qnPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    //运营商slog
    configure.qnSloganTextFont = [UIFont systemFontOfSize:14];
    configure.qnSlogaTextAlignment = @(NSTextAlignmentCenter);
    configure.qnSloganTextColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    
    //一键登录按钮
    configure.qnLoginBtnText = @"本机号码一键登录";
    configure.qnLoginBtnBgColor = [UIColor systemBlueColor];
    configure.qnLoginBtnTextColor = [UIColor whiteColor];
    configure.qnLoginBtnTextFont = [UIFont systemFontOfSize:17];
    
    //协议
    configure.qnCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.qnCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.qnCheckBoxHidden = @(YES);
    configure.qnCheckBoxValue = @(YES);
    configure.qnAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.qnAppPrivacyFirst = @[@"用户协议",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.qnAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.qnAppPrivacyLineSpacing = @(3.0);
    
    UIColor *normalColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    UIColor *privacyColor = [UIColor systemBlueColor];
    configure.qnAppPrivacyColor = @[normalColor,privacyColor];
    
    
    //布局
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //logo
    QNOrientationLayOut *layOut = [[QNOrientationLayOut alloc] init];
    layOut.qnLayoutLogoCenterX = @(0);
    layOut.qnLayoutLogoTop = @(top + 44 + 40*scale);
    layOut.qnLayoutLogoWidth = @(90*scale);
    layOut.qnLayoutLogoHeight = layOut.qnLayoutLogoWidth;//依据图片的宽高比例
    
    top += 44 + 40*scale + layOut.qnLayoutLogoHeight.floatValue;
    
    //手机掩码
    layOut.qnLayoutPhoneTop = @(top + 60*scale);
    layOut.qnLayoutPhoneCenterX = @(0);
    layOut.qnLayoutPhoneHeight = @(35);
    
    top += 60*scale + layOut.qnLayoutPhoneHeight.floatValue;
    
    //slog
    layOut.qnLayoutSloganTop = @(top +25*scale);
    layOut.qnLayoutSloganHeight = @(25*scale);
    layOut.qnLayoutSloganLeft = @(25*scale);
    layOut.qnLayoutSloganRight = @(-25*scale);
    
    top += 25*scale + layOut.qnLayoutSloganHeight.floatValue;
    
    //loginbtn
    layOut.qnLayoutLoginBtnTop =  @(top + 25*scale);
    layOut.qnLayoutLoginBtnLeft = @(25*scale);
    layOut.qnLayoutLoginBtnRight = @(-25*scale);
    layOut.qnLayoutLoginBtnHeight = @(45*scale);
    configure.qnLoginBtnCornerRadius = @(layOut.qnLayoutLoginBtnHeight.floatValue/2.0);
    
    layOut.qnLayoutSloganLeft = @(configure.qnLoginBtnCornerRadius.floatValue + layOut.qnLayoutLoginBtnLeft.floatValue);
    
    top += 25*scale + layOut.qnLayoutLoginBtnHeight.floatValue;
    
    
    //协议
    layOut.qnLayoutAppPrivacyLeft = @(25*scale);
    layOut.qnLayoutAppPrivacyRight = @(-25*scale);
    layOut.qnLayoutAppPrivacyBottom = @(-50*scale);
    
    //自定义控件
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        //使用其他手机号
        UIButton *otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherPhoneButton setTitle:@"其他方式登录" forState:UIControlStateNormal];
        [otherPhoneButton addTarget:self action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [otherPhoneButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [otherPhoneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [otherPhoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [customAreaView addSubview:otherPhoneButton];

        [otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(top + 40*scale);
            make.centerX.mas_equalTo(0);
        }];
        
        
    };
    
    
    configure.qnOrientationLayOutPortrait = layOut;
    
    return configure;
}

-(QNUIConfigure *)configureMake5{
    
    //黑
    UIColor *color1 = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    //灰
    UIColor *color2 = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    //天蓝
    UIColor *color3 = [UIColor colorWithRed:60/255.0 green:160/255.0 blue:247/255.0 alpha:1.0];
    
    
    QNUIConfigure *configure = [[QNUIConfigure alloc] init];
    configure.viewController = self;
    
    //导航设置
    configure.qnNavigationBarHidden = @(YES);
    
    //logo
    configure.qnLogoHiden = @(YES);
    
    //掩码
    configure.qnPhoneNumberFont = [UIFont systemFontOfSize:22];
    configure.qnPhoneNumberColor = color1;
    configure.qnPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    
    //slog
    configure.qnSloganTextFont = [UIFont systemFontOfSize:14];
    configure.qnSloganTextColor = color2;
    configure.qnSlogaTextAlignment = @(NSTextAlignmentCenter);
    
    //登录按钮
    configure.qnLoginBtnText = @"本机号一键登录";
    configure.qnLoginBtnTextFont = [UIFont systemFontOfSize:18 weight:0.2];
    configure.qnLoginBtnTextColor = [UIColor whiteColor];
    configure.qnLoginBtnBgColor = color3;
    configure.qnLoginBtnCornerRadius = @(5);
    
    //协议
    configure.qnCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.qnCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.qnCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.qnCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.qnCheckBoxValue = @(NO);

    configure.qnAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.qnAppPrivacyFirst = @[@"《用户协议》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyNormalDesTextSecond = @"、";
    configure.qnAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyNormalDesTextThird = @"和";
    configure.qnAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.qnAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.qnAppPrivacyLineSpacing = @(3.0);
    configure.qnAppPrivacyPunctuationMarks = @(YES);
    configure.qnAppPrivacyColor = @[color2,color3];
    configure.qnAuthTypeUseWindow = @(YES);
    
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height  = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准

    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    

    QNOrientationLayOut *cLOrientationLayOutPortrait = [[QNOrientationLayOut alloc] init];
    configure.qnOrientationLayOutPortrait = cLOrientationLayOutPortrait;
        
    CGFloat top = height/2.0 - 340*scale/2.0;
    
    //手机掩码
    cLOrientationLayOutPortrait.qnLayoutPhoneTop = @(top + 70*scale);
    cLOrientationLayOutPortrait.qnLayoutPhoneLeft = @(50*scale);
    cLOrientationLayOutPortrait.qnLayoutPhoneCenterX = @(0);
    cLOrientationLayOutPortrait.qnLayoutPhoneHeight = @(30*scale);
    
    top = cLOrientationLayOutPortrait.qnLayoutPhoneTop.floatValue + cLOrientationLayOutPortrait.qnLayoutPhoneHeight.floatValue;
    
    //slog
    cLOrientationLayOutPortrait.qnLayoutSloganTop = @(top + 20*scale);
    cLOrientationLayOutPortrait.qnLayoutSloganLeft = @(50*scale);
    cLOrientationLayOutPortrait.qnLayoutSloganCenterX = @(0);
    cLOrientationLayOutPortrait.qnLayoutSloganHeight = @(25*scale);
    
    
    top = cLOrientationLayOutPortrait.qnLayoutSloganTop.floatValue + cLOrientationLayOutPortrait.qnLayoutSloganHeight.floatValue;
    
    //登录按钮
    cLOrientationLayOutPortrait.qnLayoutLoginBtnTop = @(top + 25*scale);
    cLOrientationLayOutPortrait.qnLayoutLoginBtnLeft = @(50*scale);
    cLOrientationLayOutPortrait.qnLayoutLoginBtnRight = @(-50*scale);
    cLOrientationLayOutPortrait.qnLayoutLoginBtnHeight = @(45*scale);
    
    top = cLOrientationLayOutPortrait.qnLayoutLoginBtnTop.floatValue + cLOrientationLayOutPortrait.qnLayoutLoginBtnHeight.floatValue;
    
    //协议
    cLOrientationLayOutPortrait.qnLayoutAppPrivacyTop = @(top + 70*scale);
    cLOrientationLayOutPortrait.qnLayoutAppPrivacyLeft = @(50*scale + 30);
    cLOrientationLayOutPortrait.qnLayoutAppPrivacyRight = @(-50*scale);
    
    top  = cLOrientationLayOutPortrait.qnLayoutAppPrivacyTop.floatValue + cLOrientationLayOutPortrait.qnLayoutAppPrivacyHeight.floatValue;
    
    __weak typeof(self) weakSelf = self;
    
    
    //横屏
    CGFloat heightLandscape  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat widthLandscape  = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat topLandscape = heightLandscape/2.0 - 300*scale/2.0;
    
    QNOrientationLayOut *clOrientationLayOutLandscape = [[QNOrientationLayOut alloc] init];
    configure.qnOrientationLayOutLandscape = clOrientationLayOutLandscape;
    
    //手机掩码
    clOrientationLayOutLandscape.qnLayoutPhoneTop = @(topLandscape + 60*scale);
    clOrientationLayOutLandscape.qnLayoutPhoneCenterX = @(0);
    clOrientationLayOutLandscape.qnLayoutPhoneWidth = @(heightLandscape - 100*scale);
    clOrientationLayOutLandscape.qnLayoutPhoneHeight = @(30*scale);
    
    topLandscape = clOrientationLayOutLandscape.qnLayoutPhoneTop.floatValue + clOrientationLayOutLandscape.qnLayoutPhoneHeight.floatValue;
    
    //slog
    clOrientationLayOutLandscape.qnLayoutSloganTop = @(topLandscape + 10*scale);
    clOrientationLayOutLandscape.qnLayoutSloganWidth = @(heightLandscape - 100*scale);
    clOrientationLayOutLandscape.qnLayoutSloganCenterX = @(0);
    clOrientationLayOutLandscape.qnLayoutSloganHeight = @(20*scale);
    
    
    topLandscape = clOrientationLayOutLandscape.qnLayoutSloganTop.floatValue + clOrientationLayOutLandscape.qnLayoutSloganHeight.floatValue;
    
    //登录按钮
    clOrientationLayOutLandscape.qnLayoutLoginBtnTop = @(topLandscape + 15*scale);
    clOrientationLayOutLandscape.qnLayoutLoginBtnWidth = @(heightLandscape - 100*scale);
    clOrientationLayOutLandscape.qnLayoutLoginBtnCenterX = @(0);
    clOrientationLayOutLandscape.qnLayoutLoginBtnHeight = @(45*scale);
    
    topLandscape = clOrientationLayOutLandscape.qnLayoutLoginBtnTop.floatValue + clOrientationLayOutLandscape.qnLayoutLoginBtnHeight.floatValue;
    
    //协议
    clOrientationLayOutLandscape.qnLayoutAppPrivacyTop = @(topLandscape + 60*scale);
    clOrientationLayOutLandscape.qnLayoutAppPrivacyWidth = @(heightLandscape - 100*scale-30);
    clOrientationLayOutLandscape.qnLayoutAppPrivacyCenterX = @(15);

    topLandscape  = clOrientationLayOutLandscape.qnLayoutAppPrivacyTop.floatValue + clOrientationLayOutLandscape.qnLayoutAppPrivacyHeight.floatValue;
    
    __block UIView *conerViewBlock;
    __block UIButton *closeBlock;
    __block UILabel *welcomLabelBlock;
    __block UIButton *otherButtonBlock;
    
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        
        customAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
       
        
        void (^ rientationPortraitBlcok) (UIInterfaceOrientation orientation) = ^(UIInterfaceOrientation orientation){
            
            
            UIView *conerView = [[UIView alloc] init];
            conerView.backgroundColor = [UIColor whiteColor];
            conerView.layer.cornerRadius = 10.0;
            [customAreaView addSubview:conerView];
            conerViewBlock = conerView;
            
            //关闭按钮
            UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
            [close setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [close addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
            [conerView addSubview:close];
            closeBlock = close;
            
            
            UILabel *welcomLabel = [[UILabel alloc] init];
            welcomLabel.text = @"欢迎使用七牛";
            welcomLabel.font = [UIFont systemFontOfSize:15];
            welcomLabel.textColor = color1;
            welcomLabel.textAlignment = NSTextAlignmentCenter;
            [customAreaView addSubview:welcomLabel];
            welcomLabelBlock = welcomLabel;
            
            
            UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [otherButton setTitle:@"其他方式登录" forState:UIControlStateNormal];
            [otherButton setTitleColor:color1 forState:UIControlStateNormal];
            [otherButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [otherButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
            [customAreaView addSubview:otherButton];
            otherButtonBlock = otherButton;
            
        
            //竖屏
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            
                [conerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_equalTo(cLOrientationLayOutPortrait.qnLayoutPhoneTop.floatValue - 70*scale);
                    make.left.mas_equalTo(30*scale);
                    make.centerX.mas_equalTo(0);
                    make.height.mas_equalTo(340*scale + 35*scale);
                    
                }];
                
                [close mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_offset(10*scale);
                    make.right.mas_offset(-10*scale);
                    make.width.height.mas_equalTo(25*scale);
                }];
                
                [welcomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                    make.centerY.mas_equalTo(conerView.mas_top).offset(40*scale);
                    make.left.mas_equalTo(50*scale);
                    make.centerX.mas_equalTo(0);
                    make.height.mas_offset(25*scale);
                     
                }];
                
                //其他方式登录
                [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.mas_equalTo(0);
                    make.centerY.equalTo(customAreaView.mas_top).offset(cLOrientationLayOutPortrait.qnLayoutLoginBtnTop.floatValue + cLOrientationLayOutPortrait.qnLayoutLoginBtnHeight.floatValue + 35*scale);
                }];
                
            }else{
            //横屏
                
                [conerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    
                    make.top.mas_equalTo(clOrientationLayOutLandscape.qnLayoutPhoneTop.floatValue - 60*scale);
                    make.width.mas_equalTo(heightLandscape - 60*scale);
                    make.centerX.mas_equalTo(0);
                   
                    make.bottom.mas_offset(-clOrientationLayOutLandscape.qnLayoutPhoneTop.floatValue + 60*scale+10*scale);
                    
                }];
                
                [close mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_offset(10*scale);
                    make.right.mas_offset(-10*scale);
                    make.width.height.mas_equalTo(25*scale);
                }];
                
                [welcomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                    make.centerY.mas_equalTo(conerView.mas_top).offset(40*scale);
                    make.left.mas_equalTo(50*scale);
                    make.centerX.mas_equalTo(0);
                    make.height.mas_offset(25*scale);
                     
                }];
                
                //其他方式登录
                [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.mas_equalTo(0);
                    make.centerY.equalTo(customAreaView.mas_top).offset(clOrientationLayOutLandscape.qnLayoutLoginBtnTop.floatValue + clOrientationLayOutLandscape.qnLayoutLoginBtnHeight.floatValue + 35*scale);
                }];
                
            }
            
        };
        
        
        rientationPortraitBlcok(orientation);
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            
            UIInterfaceOrientation orientationIn = [UIApplication sharedApplication].statusBarOrientation;
            
            //删除以前约束
            [conerViewBlock removeFromSuperview];
            [closeBlock  removeFromSuperview];
            [welcomLabelBlock removeFromSuperview];
            [otherButtonBlock removeFromSuperview];
            
            rientationPortraitBlcok(orientationIn);
        }];
    };
    
    return configure;
    
}

-(QNUIConfigure *)configureMake6{
    
    
    QNUIConfigure *configure = [[QNUIConfigure alloc] init];
    configure.viewController = self;
    
    //导航栏设置
    configure.qnNavigationBarHidden = @(NO);
    configure.qnNavigationBottomLineHidden = @(YES);
    configure.qnNavigationBackgroundClear = @(YES);
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    configure.qnNavigationLeftControl = leftItem;
    //右侧按钮
    UIBarButtonItem *rigtItem = [[UIBarButtonItem alloc] initWithTitle:@"密码登录" style:UIBarButtonItemStylePlain target:self action:nil];
    configure.qnNavigationRightControl = rigtItem;
    //logo
    configure.qnLogoImage = [UIImage imageNamed:@"image_main"];
    //手机掩码配置
    configure.qnPhoneNumberFont = [UIFont systemFontOfSize:25 weight:0.8];
    configure.qnPhoneNumberColor = [UIColor whiteColor];
    configure.qnPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    //运营商slog
    configure.qnSloganTextFont = [UIFont systemFontOfSize:14];
    configure.qnSlogaTextAlignment = @(NSTextAlignmentRight);
    configure.qnSloganTextColor = [UIColor whiteColor];
    
    //一键登录按钮
    configure.qnLoginBtnText = @"本机号码一键登录";
    configure.qnLoginBtnBgColor = [UIColor systemBlueColor];
    configure.qnLoginBtnTextColor = [UIColor whiteColor];
    configure.qnLoginBtnTextFont = [UIFont systemFontOfSize:17];
    
    //协议
    configure.qnCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.qnCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.qnCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.qnCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.qnCheckBoxValue = @(YES);

    configure.qnAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.qnAppPrivacyFirst = @[@"用户协议",[NSURL URLWithString:@"https://www.qiniu.com/agreements/user-agreement"]];
    configure.qnAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.qnAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.qnAppPrivacyLineSpacing = @(3.0);
    
    UIColor *normalColor = [UIColor whiteColor];
    UIColor *privacyColor = [UIColor systemBlueColor];
    configure.qnAppPrivacyColor = @[normalColor,privacyColor];
    
    
    //布局
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //logo
    QNOrientationLayOut *layOut = [[QNOrientationLayOut alloc] init];
    layOut.qnLayoutLogoCenterX = @(0);
    layOut.qnLayoutLogoTop = @(top + 44 + 40*scale);
    layOut.qnLayoutLogoWidth = @(90*scale);
    layOut.qnLayoutLogoHeight = layOut.qnLayoutLogoWidth;//依据图片的宽高比例
    
    top += 44 + 40*scale + layOut.qnLayoutLogoHeight.floatValue;
    
    //手机掩码
    layOut.qnLayoutPhoneTop = @(top + 60*scale);
    layOut.qnLayoutPhoneCenterX = @(0);
    layOut.qnLayoutPhoneHeight = @(35);
    
    top += 60*scale + layOut.qnLayoutPhoneHeight.floatValue;
    
    //slog
    layOut.qnLayoutSloganTop = @(top +25*scale);
    layOut.qnLayoutSloganHeight = @(25*scale);
    
    CGFloat slogTop = layOut.qnLayoutSloganTop.floatValue;
    CGFloat slogHeigh = layOut.qnLayoutSloganHeight.floatValue;
    
    top += 25*scale + layOut.qnLayoutSloganHeight.floatValue;
    
    //loginbtn
    layOut.qnLayoutLoginBtnTop =  @(top + 25*scale);
    layOut.qnLayoutLoginBtnLeft = @(25*scale);
    layOut.qnLayoutLoginBtnRight = @(-25*scale);
    layOut.qnLayoutLoginBtnHeight = @(45*scale);
    configure.qnLoginBtnCornerRadius = @(layOut.qnLayoutLoginBtnHeight.floatValue/2.0);
    
    layOut.qnLayoutSloganLeft = @(configure.qnLoginBtnCornerRadius.floatValue + layOut.qnLayoutLoginBtnLeft.floatValue);
    
    
    top += 25*scale + layOut.qnLayoutLoginBtnHeight.floatValue;
    
    //协议
    layOut.qnLayoutAppPrivacyTop  = @(top + 25*scale);
    layOut.qnLayoutAppPrivacyLeft = @(25*scale + 25);
    layOut.qnLayoutAppPrivacyRight = @(-25*scale);
    
    
    top += 25*scale + 50;
    
    //自定义控件
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        PlayerView *playerView = [[PlayerView alloc] init];
        [customAreaView addSubview:playerView];
        
        [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.top.left.bottom.right.equalTo(customAreaView);
        }];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"颜色遮罩_x264" ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVPlayerItem *playeItem = [[AVPlayerItem alloc] initWithURL:url];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playeItem];
        
    
        AVPlayerLayer *playerLayer = (AVPlayerLayer *)playerView.layer;
        playerLayer.player = player;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        
        [player play];
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            
            CMTime time  = CMTimeMake(0, 1);
            
            [player seekToTime:time];
            
            [player play];
            
        }];
        //使用其他手机号
        UIButton *otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherPhoneButton setTitle:@"使用其他手机 >" forState:UIControlStateNormal];
        [otherPhoneButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [otherPhoneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [otherPhoneButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [customAreaView addSubview:otherPhoneButton];
        
        [otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(slogTop);
            make.right.mas_equalTo(-25*scale - 22.5*scale);
            make.height.mas_equalTo(slogHeigh);
        }];
        
        //其他方式登录
        UIView *contentView = [[UIView alloc] init];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:leftLineView];
        
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(contentView);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(contentView);
            make.width.mas_equalTo(0.1*width);
        }];
        
        UILabel *otherLabel = [[UILabel alloc] init];
        otherLabel.text = @"使用其他账号登录";
        otherLabel.font = [UIFont systemFontOfSize:14];
        otherLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:otherLabel];
        
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(leftLineView.mas_right).offset(10*scale);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(otherLabel.mas_right).offset(10*scale);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(0.1*width);
            make.right.equalTo(contentView.mas_right);
            make.centerY.equalTo(leftLineView);
        }];
        
        [customAreaView addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(top + 25*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
        //其他按钮视图
        __block UIView *weiXinView;
        __block UIView *qqView;
        __block UIView *weiBoView;
        
        NSArray *imageNames = @[@"weixin",@"qq",@"weibo"];
        NSArray *titiles = @[@"微信",@"QQ",@"微博"];
        
        [imageNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView *buttonContentView = [[UIView alloc] init];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:idx];
            [button setBackgroundImage :[UIImage imageNamed:obj] forState:UIControlStateNormal];
            [buttonContentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(0.15*width);
                make.height.mas_equalTo(0.15*width);
                make.top.left.right.equalTo(buttonContentView).offset(5);
            }];
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.text = titiles[idx];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.font = [UIFont systemFontOfSize:15];
            tipLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            [buttonContentView addSubview:tipLabel];
            
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(button.mas_bottom).offset(10);
                make.left.right.equalTo(buttonContentView);
                make.bottom.equalTo(buttonContentView).offset(-2);
                make.height.mas_equalTo(25);
            }];
            
            if (idx == 0) {
                
                weiXinView = buttonContentView;
            }else if (idx == 1){
                
                qqView = buttonContentView;
            }else{
                
                weiBoView = buttonContentView;
            }
            
        }];
        
        UIView *buttonContentView = [[UIView alloc] init];
        
        [buttonContentView addSubview:weiXinView];
        [weiXinView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.equalTo(buttonContentView);
        }];
        
        
        [buttonContentView addSubview:qqView];
        [qqView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(buttonContentView);
            make.left.equalTo(weiXinView.mas_right).offset(0.13*width);
        }];
        
        
        [buttonContentView addSubview:weiBoView];
        [weiBoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(buttonContentView);
            make.left.equalTo(qqView.mas_right).offset(0.13*width);
        }];
        
        [customAreaView addSubview:buttonContentView];
        
        [buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(contentView.mas_bottom).offset(15*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
    };
    
    
    configure.qnOrientationLayOutPortrait = layOut;
    
    return configure;
    
}
- (void)dismis{
    [QNAuthSDKManager finishAuthControllerAnimated:NO Completion:nil];
}



@end
