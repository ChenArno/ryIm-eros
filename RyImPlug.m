//
//  RyImPlug.m
//  WeexEros
//
//  Created by chen_arno on 2018/7/3.
//  Copyright © 2018年 benmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RyImPlug.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

WX_PlUGIN_EXPORT_MODULE(ryIm, RyImPlug)

@interface RyImPlug()

@end

@implementation RyImPlug
@synthesize weexInstance;
// 将方法暴露出去
WX_EXPORT_METHOD(@selector(init:succ:))

- (void)init:(NSString *)token succ:(WXModuleCallback)succ{
//    NSLog(@"注册成功:%@",token);
    if(succ){
        succ(@"注册成功");
    }
}

@end
