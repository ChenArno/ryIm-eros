//
//  VanzImView.m
//  WeexEros
//
//  Created by chen_arno on 2018/7/5.
//  Copyright © 2018年 benmu. All rights reserved.
//

#import "VanzImView.h"
#import "VanzIm.h"
#import <RongIMKit/RongIMKit.h>
#import <WeexPluginLoader/WeexPluginLoader/WeexPluginLoader.h>
#import "chatViewController.h"

@interface VanzImView()
@end

NSString *myUserId;
//NSString *otherUuid;
RCUserInfo *mySelf;
RCUserInfo *otherInfo;
WX_PlUGIN_EXPORT_COMPONENT(vanz-im-view, VanzImView)
@implementation VanzImView

//初始化
- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    _instance = weexInstance;
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        [RCIM sharedRCIM].receiveMessageDelegate = self; //接受消息监听
        //  设置头像为圆形
        [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
        //   显示用户头像和名称  getUserInfoWithUserId
//        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [RCIM sharedRCIM].userInfoDataSource = self;
        otherInfo = [[RCUserInfo alloc]init];
        mySelf = [[RCUserInfo alloc]init];
//        if(attributes[@"targetId"]){
////            NSLog(@"=====1%@",attributes[@"targetId"]);
//            myUserId = [WXConvert NSString:attributes[@"targetId"]];
//            if(myUserId == NULL){
//                return self;
//            }
//        }
    }
    return self;
}
- (void)updateAttributes:(NSDictionary *)attributes{
//    if (attributes[@"targetId"]) {
//        myUserId = attributes[@"targetId"];
//        NSLog(@"=====2%@",myUserId);
//    }
}

//开始
- (void)viewDidLoad {
    //    [self setButton];
    
}

WX_EXPORT_METHOD(@selector(enterRoom:targetId:title:)) // 暴露该方法给js
- (void)enterRoom:(NSString *)type targetId:(NSString *)targetId title:(NSString *)title{
    //新建一个聊天会话View Controller对象,建议这样初始化
//    RCConversationType conversationType = ConversationType_PRIVATE;
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    RCConversationType conType = ConversationType_PRIVATE;
//    NSLog(@"enterRoom:%@,%@",targetId,type);
    if([type isEqual:@"1"]){
        /*!单聊*/
        conType = ConversationType_PRIVATE;
    }else if([type isEqual:@"2"]){
        /*!讨论组*/
        conType = ConversationType_DISCUSSION;
    }else if([type isEqual:@"3"]){
        /*!群组*/
        conType = ConversationType_GROUP;
    }else if([type isEqual:@"4"]){
        /*!聊天室*/
        conType = ConversationType_CHATROOM;
    }else if([type isEqual:@"5"]){
        /*!客服*/
        conType = ConversationType_CUSTOMERSERVICE;
    }else if([type isEqual:@"6"]){
        /*!系统*/
        conType = ConversationType_SYSTEM;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        chatViewController *chat = [[chatViewController alloc] initWithConversationType:conType targetId:targetId];
        chat.conversationType = conType;
        chat.instance = _instance;
        chat.title = title;
        [[_instance.viewController navigationController] pushViewController:chat animated:YES];
    });
}
WX_EXPORT_METHOD(@selector(selectList:))
- (void) selectList:(WXModuleCallback)success{
    NSArray *array = [[NSArray alloc]init];
    NSMutableArray *usersArray = [NSMutableArray array];
    array = [[RCIMClient sharedRCIMClient]getConversationList:@[@(ConversationType_PRIVATE)]];
    
    for (RCConversation *con in array) {
        NSMutableDictionary *obj=[[NSMutableDictionary alloc] init];
        NSString *content = @"";
        if([con.lastestMessage isMemberOfClass:[RCTextMessage class]]){
            RCTextMessage *textMessage = (RCTextMessage *)con.lastestMessage;
            content = textMessage.content;
        }
//        RCUserInfo *user = [self selectById:con.targetId];
        if(usersArray == nil){
            break;
        }
        NSString *typeName = con.objectName;
        if(content.length == 0 && typeName.length == 0){
            break;
        }
        NSString *sentTime = [NSString stringWithFormat:@"%lld",con.sentTime];
        [obj setObject:con.targetId forKey:@"userId"];
//        [obj setObject:con.objectName forKey:@"name"];
        [obj setObject:typeName forKey:@"typeName"];
        [obj setObject:content forKey:@"content"];
        [obj setObject:sentTime forKey:@"lastTime"];
        [obj setObject:[NSString stringWithFormat:@"%d",con.unreadMessageCount] forKey:@"unreadCount"];
//        [obj setObject:con. forKey:@"avatarUrl"];
        [usersArray addObject:obj];
    }
    if(success){
        success(usersArray);
    }
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//应用在前台
    {
        NSLog(@"content:%@",message.content);
        NSMutableDictionary *obj=[[NSMutableDictionary alloc] init];
        NSString *sentTime = [NSString stringWithFormat:@"%lld",message.sentTime];
        [obj setObject:message.content forKey:@"content"];
        [obj setObject:sentTime forKey:@"sentTime"];
        [obj setObject:message.targetId forKey:@"targetId"];
        [_instance fireGlobalEvent:@"ryMsg.received" params:obj];
    }
    else//应用在后台
    {
        int allunread = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];//获取消息数量
        if(allunread > 0)
        {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:allunread];//修改应用图标上的数字
        }
    }
}
WX_EXPORT_METHOD(@selector(refreshLoginInfo:name:portraitUri:))
- (void)refreshLoginInfo:(NSString *)targetId name:(NSString *)name portraitUri:(NSString *)portraitUri{
    mySelf.userId = targetId;
    mySelf.name = name;
    mySelf.portraitUri = portraitUri;
    [[RCIM sharedRCIM] refreshUserInfoCache:mySelf withUserId:targetId];
}
WX_EXPORT_METHOD(@selector(refreshUserInfo:name:portraitUri:))
- (void)refreshUserInfo:(NSString *)targetId name:(NSString *)name portraitUri:(NSString *)portraitUri{
    otherInfo.userId = targetId;
    otherInfo.name = name;
    otherInfo.portraitUri = portraitUri;
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    if([otherInfo.userId isEqual:userId]){
        return completion(otherInfo);
    }else if([mySelf.userId isEqual:userId]){
        return completion(mySelf);
    }
}

- (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString{
    NSDictionary *retDict = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  retDict;
    }else{
        return retDict;
    }
}

@end
