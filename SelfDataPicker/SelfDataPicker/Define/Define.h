//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//

#import <Foundation/Foundation.h>

#pragma mark --screen
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define DATEFORM @"yyyy-MM-dd HH:mm"

#pragma mark --device
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
// 是否iPad
#define ISPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//Device
#endif
#if TARGET_IPHONE_SIMULATOR
//Simulator
#endif
//是否retina屏
#define ISRETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#pragma mark --system version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//系统型号识别
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS7                        (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))


#pragma mark --image
//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//定义UIImage对象
#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]


#pragma mark --color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXRGBCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark --av
#define SHOWAV (NSString *message) { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消"]; [alert show]; }

//设置视图
/** 设置视图大小，原点不变 */
//
//static inline void UIViewSetSize(UIView *view, CGSize size) { CGRect frame = view.frame; frame.size = size; view.frame = frame;}
//
///** 设置视图宽度，其他不变 */
//
//static inline void UIViewSetSizeWidth(UIView *view, CGFloat width) { CGRect frame = view.frame; frame.size.width = width; view.frame = frame; }
//
///** 设置视图高度，其他不变 */
//
//static inline void UIViewSetSizeHeight(UIView *view, CGFloat height) { CGRect frame = view.frame; frame.size.height = height; view.frame = frame; }
//
///** 设置视图原点，大小不变 */
//
//static inline void UIViewSetOrigin(UIView *view, CGPoint pt) { CGRect frame = view.frame; frame.origin = pt; view.frame = frame; }
//
///** 设置视图原点x坐标，大小不变 */
//
//static inline void UIViewSetOriginX(UIView *view, CGFloat x) { CGRect frame = view.frame; frame.origin.x = x; view.frame = frame; }
//
///** 设置视图原点y坐标，大小不变 */
//
//static inline void UIViewSetOriginY(UIView *view, CGFloat y) { CGRect frame = view.frame; frame.origin.y = y; view.frame = frame; }
//

//DEBUG  模式下打印日志,当前行
#pragma mark --nslog
#ifdef DEBUG
#define NSLog(format, ...) do {                                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(...)
#endif
//输出语句
#define CWNSLOG(object) ([NSString stringWithFormat:@"%@",object])


#pragma mark -- notification
#define NotificationAddObserver(TITLE, SELECTOR) [[NSNotificationCenter defaultCenter] addObserver:self selector:SELECTOR name:TITLE object:nil]
#define NotificationRemoveObserver(id) [[NSNotificationCenter defaultCenter] removeObserver:id]
#define NotificationPostNotify(TITLE,OBJ,PARAM) [[NSNotificationCenter defaultCenter] postNotificationName:TITLE object:OBJ userInfo:PARAM]

#define MYWIDTH (SCREEN_WIDTH / 2.0 - 10)
#define MYHEIGHT (MYWIDTH * 1.32)
#define MYSIGLEHEIGHT ((SCREEN_HEIGHT / 4.0))
#define WIDTHPRO (SCREEN_WIDTH / 375)
#define HEIGHTPRO (SCREEN_HEIGHT / 667)
@interface Define : NSObject

@end
