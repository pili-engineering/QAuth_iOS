//
//  PhoneNumberCheckController.m
//  QAuth_iOS_Demo
//
//  Created by sunmu on 2023/5/22.
//
#import "PhoneNumberCheckController.h"
#import "QNPhoneNumberDemoCode.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <QNAuthSDK/QNAuthSDK.h>
#import <NSObject+YYModel.h>
#import <CLConsole/CLConsole.h>

@interface PhoneNumberCheckController ()
@property(nonatomic,strong)UITextField * phoneNumberField ;
@end

@implementation PhoneNumberCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"七牛本机号校验";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }

    _phoneNumberField = [[UITextField alloc]init];
    [self.view addSubview:_phoneNumberField];
    [_phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-60);
        make.width.mas_equalTo(self.view).multipliedBy(0.8);
        make.height.mas_equalTo(45);
    }];
//    _phoneNumberField.hidden = YES;
    _phoneNumberField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor grayColor]}];
    _phoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
    _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    
    UIButton * check = [[UIButton alloc]init];
    check.layer.cornerRadius = 22.5;
    [self.view addSubview:check];
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.mas_equalTo(self.phoneNumberField);
        make.top.mas_equalTo(self.phoneNumberField.mas_bottom).offset(30);
    }];
    [check setTitle:@"本机号校验" forState:(UIControlStateNormal)];
    [check setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    [check setBackgroundColor:[UIColor colorWithRed:38/255.0 green:94/255.0 blue:250/255.0 alpha:1]];
    [check addTarget:self action:@selector(phoneNumberCheck:) forControlEvents:(UIControlEventTouchUpInside)];
    _phoneNumberField.text = @"18095608365";
}




-(void)phoneNumberCheck:(UIButton *)sender{
    [self.view endEditing:YES];
    
    
    CLConsoleLog(@"mobileCheckWithLocalPhoneNumber:本机校验开始");

    [sender setEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender setEnabled:YES];
    });
    
//    _phoneNumberField.text = [_phoneNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [QNAuthSDKManager mobileCheckWithLocalPhoneNumberComplete:^(QNCompleteResult * _Nonnull completeResult) {
        
        if (completeResult.error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                CLConsoleLog(@"本机校验回调失败:%@\n",completeResult.error.description);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"本机校验回调失败:%@\n",completeResult.error.description]];

            });

        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CLConsoleLog(@"本机校验回调成功:%@\n",completeResult.yy_modelToJSONObject);
                
                NSString * validatePhonenumber = self->_phoneNumberField.text;
                NSString *token = completeResult.data[@"token"];
                
                [QNPhoneNumberDemoCode validatePhonenumber:validatePhonenumber token:token completion:^(NSNumber * _Nonnull isValidated, id  _Nullable responseObject, NSError * _Nullable error) {
                    
                    NSString * message ;
                    
                    if (isValidated) {
                        if (isValidated.boolValue == YES) {
                            message = [NSString stringWithFormat:@"本机校验成功，号码一致,手机号：%@",validatePhonenumber];
                        }else{
                            message = [NSString stringWithFormat:@"本机校验失败，号码不一致：%@",responseObject];
                        }
                    }else{
                        if (responseObject) {
                            message = [NSString stringWithFormat:@"本机校验失败:%@",responseObject];
                        }else{
                            message = [NSString stringWithFormat:@"本机校验失败:%@",error.localizedDescription];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CLConsoleLog(@"%@",message);
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showInfoWithStatus:message];
                    });

                }];
            });
            
            
        }
    }];
}

// 正则匹配手机号
- (BOOL)checkTelNumber:(NSString *) telNumber{
    // 输入开头为1的11位数字限制
    NSString *pattern = @"^1+\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

// 手机号输入时长度限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.phoneNumberField.text.length >= 11 && string.length) {
        [SVProgressHUD showInfoWithStatus:@"Length limited Error"];
        return NO;
    }
    
    return YES;
}
@end
