# ryIm-eros
基于eros的融云通信


1、在你需要引入的项目中把你的项目clone到你podfile所在的目录。
git clone https://github.com/ChenArno/ryIm-eros.git ryim
```Ruby
    pod 'ryIm', :git => 'https://github.com/ChenArno/ryIm-eros.git', :tag => '1.0.0'
```
2、执行 pod update
```Ruby
 pod update
```

3、在AppDelegate.m中加入

```Ruby
  //头部引入架包文件
  #import <RongIMKit/RongIMKit.h>
  //融云官网注册的appid:xxxx
    [[RCIM sharedRCIM] initWithAppKey:@"xxxx"];
```

```Ruby
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL result = [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    //do something
    [[RCIM sharedRCIM] initWithAppKey:@"82hegw5u8ympx"];
    
    return result;
}

@end
```


在融云官网注册以后，填入userId获取token(改token应当通过后台获取，测试阶段可以从官网获取)
当应用启动后，获取token，通过ryIm方法注册调用
```Js
const ryIm = weex.requireModule('ryIm')
ryIm.init(token,res => {
          console.log('===>连接成功，userId:' + res)
        },
        err => {
          console.log('===>' + err)
        }
      )
```

聊天列表组件，子组件需包含在该组件下
获取当前聊天对象列表

```Js
<vanz-im-view ref="imview">
  ...
  <div @click="enterRoom(item)">111</div>
  ...
</vanz-im-view>

this.$refs.imview.selectList(r => {
  console.log('===>获取数据成功' + JSON.stringify(r))
})
let type = 1; //单聊模式
//userId为注册时的唯一id，name为进入聊天窗口的标题
this.$refs.imview.enterRoom(type, userId, name)
```

删除该聊天记录

```Js
let type = 1; //单聊模式
this.$refs.imview.deleteItem(type,userId,res=>{
  console.log(res)
})
```
监听聊天页面返回动作
此处可执行刷新动作this.$refs.imview.selectList
```Js
    globalEvent.addEventListener('activity.back', options => {
      //do soming
      //监听会话页面返回
    })
```
监听收到消息动作
此处可执行刷新动作this.$refs.imview.selectList
```Js
    globalEvent.addEventListener('ryMsg.received', options => {
      let { sentTime, content, targetId } = options
      this.selectList()
      //do soming
      //监听收到消息
    })
```
监听发送消息动作
```Js
    globalEvent.addEventListener('ryMsg.send', options => {
      let { targetId, content, sentTime } = options
      // this.selectList()
      //do soming
      //监听发送消息
    })
```

### 20180711-新增头像用户更新功能
```Js
 //当前当前登录用户信息刷新
this.$refs.imview.refreshLoginInfo(userId, name, portraitUri)
//聊天用户信息刷新
this.$refs.imview.refreshUserInfo(userId,name,imgUrl)
```

具体例子详见

- [https://github.com/ChenArno/ryim-eros-source.git] (https://github.com/ChenArno/ryim-eros-source.git)
