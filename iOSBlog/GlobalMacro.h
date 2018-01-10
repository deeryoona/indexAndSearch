//
//  GlobalMacro.h
//  Qsend
//
//  Created by l.h on 14-6-18.
//  Copyright (c) 2014年 WeiXingApp. All rights reserved.
//

#ifndef Qsend_GlobalMacro_h
#define Qsend_GlobalMacro_h


/**
 *邮箱
 */
#define REGULAR_EMAIL @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$"

/**
 *网址
 */
#define REGULAR_URL @"^(?i)(http:\\/\\/){0,1}([A-Za-z0-9-\\_]+)\\.taobao\\.com$"


//判断是NSString 返回 该String 否则返回 @""
#define kIsString(str) [str isKindOfClass:[NSString class]] ? str : @""


//----------------------系统----------------------------
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#define  Divide_Scale_Iphone5   1136/960

//是否是iOS 7 及 以上版本
#define iOS_Version_7  [[[UIDevice currentDevice] systemVersion] floatValue] > 7.0
//是否是iOS 8 及 以上版本
#define iOS_Version_8  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define Is_iOS_Version_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)?YES:NO
//是否是 iPhone5 屏幕尺寸
//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )



//判断iphone4
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone5
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6
#define IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6+  iPhone6 plus分辨率 标准模式分辨率为1242x2208，放大模式分辨率为1125x2001
#define IS_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)||CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

//----------------------系统----------------------------
//获取设备版本
#define ipad  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad
#define IdiomPhone  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

//-------------------获取设备大小尺寸-------------------------
//获取 屏幕Size
//设备屏幕尺寸 屏幕Size
#define kScreen_Size      [[UIScreen mainScreen] bounds].size
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
//获取 屏幕Frame
#define kScreen_Frame   [UIScreen mainScreen].applicationFrame
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

//获取状态栏Frame
#define kScreen_StatusBarFrame   [[UIApplication sharedApplication] statusBarFrame]


//获取中间内容高度（除去状态栏，UITabBar，UINavigationBar）
//#define kContent_Height [[UIScreen mainScreen] bounds].size.height-44-49-20


//应用尺寸(不包括状态栏,通话时状态栏高度不是20，所以需要知道具体尺寸)
#define kContent_Height   ([UIScreen mainScreen].applicationFrame.size.height)
#define kContent_Width    ([UIScreen mainScreen].applicationFrame.size.width)
#define kContent_Frame    (CGRectMake(0, 0 ,kContent_Width,kContent_Height))
#define kContent_CenterX  kContent_Width/2
#define kContent_CenterY  kContent_Height/2



//简写系统中一些方法
#define kAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define kNavigationController ((AppDelegate *)[UIApplication sharedApplication].delegate.navigationController)
#define kWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define kKeyWindow          [[UIApplication sharedApplication] keyWindow]


//定义GCD的后台线程和主线程
//后台运行
#define BACK_GCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

//主线程运行
#define MAIN_GCD(block) dispatch_async(dispatch_get_main_queue(),block)


//-------------------获取设备大小-------------------------


//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define WXBACKGROUND_COLOR [UIColor colorWithRed:231.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//黑色
#define BLACKCOLOR [UIColor colorWithHexString:@"#2c2c2b"]

//灰色
#define GRAYCOLOR [UIColor colorWithHexString:@"#7f7d7a"]

//----------------------颜色类--------------------------




//----------------------App缓存目录--------------------------
//沙盒Documents目录
#define APP_DOC_DIR     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
//沙盒Library目录
#define APP_LIB_DIR     [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
//沙盒Library下的cache目录
#define APP_LIB_CACHE_DIR  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
//沙盒tmp下的cache目录,这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息
#define APP_TMP_DIR        NSTemporaryDirectory()
//----------------------App缓存目录--------------------------




//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

#define LoadImage(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[file stringByDeletingPathExtension] ofType:[file pathExtension]]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者


//可拉伸的图片

#define ResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]
//----------------------图片----------------------------

/**
 *  ARC  相关
 */
#define WEAKSELF __weak __typeof(self) weakSelf = self  
#define AFWEAKSELF __weak __typeof(&*self) weakSelf = self  // AFNetworking的写法__weak __typeof(&*self)weakSelf = self;这种写法不局限于某个viewcontroller



/**
 *  功能相关
 *
 */

//System  剪贴板
#define PasteString(string)   [[UIPasteboard generalPasteboard] setString:string];
#define PasteImage(image)     [[UIPasteboard generalPasteboard] setImage:image];


//拨打电话
#define canTel                 ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]])
#define tel(phoneNumber)       ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]])
#define telprompt(phoneNumber) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]]])

//打开URL
#define canOpenURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])
#define openURL(appScheme) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]])


//输出frame(frame是结构体，没法%@)
#define LOGFRAME(f) DLOG(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define LOGBOOL(b)  DLOG(@"%@",b?@"YES":@"NO");


//自动布局计算
#define AutoWidth 320.0*[UIScreen mainScreen].bounds.size.width

//获取用户信息
#define USERMobile [[NSUserDefaults standardUserDefaults]objectForKey:@"lastMobile"]?:@""
#define USERINFO [[NSUserDefaults standardUserDefaults]objectForKey:@"userinfo"]
#define USERToken [USERINFO objectForKey:@"token"]?:@""
#define USERUid [USERINFO objectForKey:@"uid"]?:@""
//#define USERToken @"go"
//#define USERUid @"42"
#define SBTextColor [UIColor colorWithHexString:@"#f90000"]
#define SBBackgroundColor [UIColor colorWithHexString:@"#f5f5f5"]

//关闭键盘
#define CloseKeyboard [[UIApplication sharedApplication].keyWindow endEditing:YES]

/**
 *  设置字体为13
 */
#define FONT13 [UIFont systemFontOfSize:13]
/**
 *  设置字体为14
 */
#define FONT14 [UIFont systemFontOfSize:14]
/**
 *  设置颜色为#2c2c2b
 */
#define COLOL2c2c2b [UIColor colorWithHexString:@"#2c2c2b"]
/**
 *  设置颜色为#4c4a4b
 */
#define COLOL4c4a4b [UIColor colorWithHexString:@"#4c4a4b"]
/**
 *  设置颜色为#fc4848
 */
#define COLOLfc4848 [UIColor colorWithHexString:@"#fc4848"]
/**
 *  失败请求打印
 */
#define ERRORDLOG  DLOG(@"error=%@",error)
/**
 *  失败请求提示
 */

#define ERRORALERT  [SBEasyAlert showNickySingleButtonAlertWithTitle:@"网络失败,请稍后再试" andMessage:nil andblock:nil]

/** 弹出登录视图 */
#define SBLOGINPRESENTACTION SBUserLoginViewController *loginVC = [[SBUserLoginViewController alloc]init];CustomNavController *loginNav = [[CustomNavController alloc]initWithRootViewController:loginVC];[self.navigationController presentViewController:loginNav animated:YES completion:nil];


/*网络相关*/
#define  AFNetworkStatus  [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus

//无网络
#define  AFNetworkNotReachable  [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus==AFNetworkReachabilityStatusNotReachable


#endif
