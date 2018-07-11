//
//  VanzIm.m
//  WeexEros
//
//  Created by chen_arno on 2018/7/5.
//  Copyright © 2018年 benmu. All rights reserved.
//

#import "VanzIm.h"
#import <RongIMKit/RongIMKit.h>
#import <WeexPluginLoader/WeexPluginLoader/WeexPluginLoader.h>

@interface VanzIm()

@end

WX_PlUGIN_EXPORT_MODULE(ryIm, VanzIm)
@implementation VanzIm
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(init:success:error:))

- (void)init:(NSString *)token success:(WXModuleCallback)success error:(WXModuleCallback)error{
    [self logout];
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        success(userId);
    } error:^(RCConnectErrorCode status) {
        if(error){
            error([@"登陆的错误码为:" stringByAppendingFormat:@"%l",status]);
        }
    } tokenIncorrect:^{
        if(error){
            error(@"token错误");
        }
    }];
}
//登出
WX_EXPORT_METHOD(@selector(logout))
- (void)logout{
    [[RCIM sharedRCIM]logout];
}

@end
