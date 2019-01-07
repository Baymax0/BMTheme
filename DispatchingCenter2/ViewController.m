//
//  ViewController.m
//  DispatchingCenter2
//
//  Created by yimi on 2019/1/4.
//  Copyright © 2019 baymax. All rights reserved.
//

#import "ViewController.h"
#include <objc/runtime.h>
#import "YYCacheManager.h"


#define kMainScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define KCache_AppList @"KCache_AppList"

@interface App : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *icon;
@property (strong,nonatomic) NSString *schemeId;
@property (strong,nonatomic) NSString *bundleId;
@end
@implementation  App

+(App*)create:(NSString*)name icon:(NSString*)icon schemeId:(NSString*)schemeId{
    App *mod = [[App alloc] init];
    mod.name = name;
    mod.icon = icon;
    mod.schemeId = schemeId;
    return mod;
}

+(App*)create:(NSString*)name icon:(NSString*)icon bundleId:(NSString*)bundleId{
    App *mod = [[App alloc] init];
    mod.name = name;
    mod.icon = icon;
    mod.bundleId = bundleId;
    return mod;
}

@end


@interface ViewController (){
    UIScrollView *sc;
    NSMutableArray<NSMutableArray<App*>*> *appArr;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImge;

@end

@implementation ViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)viewDidLoad {
    [super viewDidLoad];
    sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sc.bounces = YES;
    sc.pagingEnabled = YES;
    sc.contentSize = CGSizeMake(kMainScreenWidth+1, kMainScreenHeight);
    [self.view addSubview:sc];
    
    appArr = [[YYCacheManager unLoginShare] getCacheForKey:KCache_AppList];
    
    if (appArr == nil){
        appArr = @[@[[App create:@"京东" icon:nil bundleId:@"com.360buy.jdmobile"],
                     [App create:@"淘宝" icon:nil bundleId:@"com.taobao.taobao4iphone"],
                     [App create:@"美团" icon:nil bundleId:@"com.meituan.imeituan"],
                     [App create:@"elem" icon:nil bundleId:@"me.ele.ios.eleme"]].mutableCopy,
                   
                   @[[App create:@"滴" icon:nil bundleId:@"com.xiaojukeji.didi"],
                     [App create:@"摩拜" icon:nil bundleId:@"com.mobike.bike"],
                     [App create:@"携程" icon:nil bundleId:@"ctrip.com"],
                     [App create:@"百度map" icon:nil bundleId:@"com.baidu.map"],
                     [App create:@"系统map" icon:nil bundleId:@"com.apple.Maps"]].mutableCopy,
                   
                   @[[App create:@"iqiy" icon:nil bundleId:@"com.qiyi.iphone"],
                     [App create:@"bili" icon:nil bundleId:@"tv.danmaku.bilianime"],
                     [App create:@"微博" icon:nil bundleId:@"com.sina.weibo"]].mutableCopy,
                   @[[App create:@"冈布奥" icon:nil bundleId:@"com.leiting.gumballs"],
                     [App create:@"部落" icon:nil bundleId:@"com.supercell.magic"]].mutableCopy,
                   ].mutableCopy;
        
        NSMutableArray *temp1 = [NSMutableArray array];

        [temp1 addObject:[App create:@"Q" icon:nil bundleId:@"com.tencent.mqq"]];
        [temp1 addObject:[App create:@"wx" icon:nil bundleId:@"com.tencent.xin"]];
        [temp1 addObject:[App create:@"支付宝" icon:nil bundleId:@"com.alipay.iphoneclient"]];
        [temp1 addObject:[App create:@"uc" icon:nil bundleId:@"com.ucweb.iphone.lowversion"]];
        
        [temp1 addObject:[App create:@"云音乐" icon:nil bundleId:@"com.netease.cloudmusic"]];
        [temp1 addObject:[App create:@"邮箱" icon:nil bundleId:@"com.netease.mailmaster"]];
        [temp1 addObject:[App create:@"百度云" icon:nil bundleId:@"com.baidu.netdisk"]];
        
        [temp1 addObject:[App create:@"即刻" icon:nil bundleId:@"com.ruguoapp.jike"]];
        [temp1 addObject:[App create:@"知乎" icon:nil bundleId:@"com.zhihu.ios"]];
        [temp1 addObject:[App create:@"ins" icon:nil bundleId:@"com.burbn.instagram"]];
        
        for(App *mod in temp1 ){
            NSMutableArray *group = [NSMutableArray array];
            [group addObject:mod];
            [appArr addObject:group];
        }
    }
    
    [self initUI];
}

-(void)initUI{
    CGFloat blank = 15;
    CGFloat cols = 5;
    CGFloat x = blank;
    CGFloat y = 65;
    CGFloat w = (kMainScreenWidth-blank) / cols - blank;
    
    int tag = 0;
    for(NSMutableArray *group in appArr){
        UIView *container = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, w)];
        container.tag = tag;
        [sc addSubview:container];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, w)];
        btn.tag = tag;
        [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:btn];
        
        if (group.count == 1){
            App *info = group[0];
            if (info.bundleId){
//                [btn setImage:[UIImage imageNamed:info.bundleId] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"com.tencent.xin"] forState:UIControlStateNormal];
            }
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
        }else{
            for (int i = 0; i < group.count; i++) {
                if (i>8){
                    break;
                }
                CGFloat imgW = (w-20)/3;
                CGFloat imgX = i%3 * (imgW + 5) + 5;
                CGFloat imgY = i/3 * (imgW + 5) + 5;

                UIImageView * img = [[UIImageView alloc] init];
                img.frame = CGRectMake(imgX, imgY, imgW, imgW);
                img.image = [UIImage imageNamed:@"com.tencent.xin"];
                img.contentMode = UIViewContentModeScaleAspectFit;
                [container addSubview:img];
            }
        }
        
        x += (w+blank);
        if (x + 10 > kMainScreenWidth){
            x = blank;
            y += (w+12);
        }
        tag += 1;
    }
    
//    for (App *info in appArr) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, w)];
//        [btn setTitle:info.name forState:UIControlStateNormal];
//        x += (w+blank);
//        if (x + 10 > kMainScreenWidth){
//            x = blank;
//            y += (w+12);
//        }
//        btn.tag = tag;
//        btn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//        tag += 1;
//    }
}

-(void)jump:(UIButton*)btn{
    NSMutableArray *group =appArr[btn.tag];
    if (group.count == 1){
        App *mode = group[0];
        if (mode.bundleId != nil){
            [self openBundle:mode.bundleId completionHandler:^(BOOL success) {
                NSLog(@"%d",success);
            }];
        }else{
            [self openScheme:mode.schemeId completionHandler:^(BOOL success) {
                NSLog(@"%d",success);
            }];
        }
    }
    
}


-(void)openScheme:(NSString*)str completionHandler:(void (^ __nullable)(BOOL success))completion{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",str]];
    [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
        completion(success);
    }];
}

-(void)openBundle:(NSString*)str completionHandler:(void (^ __nullable)(BOOL success))completion{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:str];
    completion(isopen);
}

- (IBAction)jumpAction:(id)sender {
    
}


-(void)printBundleId{
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 12.0){
    //        Class lsawsc = objc_getClass("LSApplicationWorkspace");
    //        NSObject* workspace = [lsawsc performSelector:NSSelectorFromString(@"defaultWorkspace")];
    //        NSArray *plugins = [workspace performSelector:NSSelectorFromString(@"allInstalledApplications")]; //列出所有plugins
    //        [plugins enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            NSString *pluginID = [obj performSelector:(@selector(pluginIdentifier))];
    //            NSString *pluginID = [obj performSelector:NSSelectorFromString(@"pluginIdentifier")];
    //            NSLog(@"%@",obj);
    //        }];
    //    }
    
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    NSMethodSignature *methodSignature = [NSClassFromString(@"LSApplicationWorkspace") methodSignatureForSelector:NSSelectorFromString(@"defaultWorkspace")];
    NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invoke setSelector:NSSelectorFromString(@"defaultWorkspace")];
    [invoke setTarget:NSClassFromString(@"LSApplicationWorkspace")];
    [invoke invoke];
    NSObject * objc;
    [invoke getReturnValue:&objc];
    
    NSMethodSignature *installedPluginsmethodSignature = [NSClassFromString(@"LSApplicationWorkspace") instanceMethodSignatureForSelector:NSSelectorFromString(@"installedPlugins")];
    NSInvocation *installed = [NSInvocation invocationWithMethodSignature:installedPluginsmethodSignature];
    [installed setSelector:NSSelectorFromString(@"installedPlugins")];
    [installed setTarget:objc];
    
    [installed invoke];
    NSObject * arr;
    [installed getReturnValue:&arr];
    
    for (NSObject *objc in arr) {
        NSMethodSignature *installedPluginsmethodSignature = [NSClassFromString(@"LSPlugInKitProxy") instanceMethodSignatureForSelector:NSSelectorFromString(@"containingBundle")];
        NSInvocation *installed = [NSInvocation invocationWithMethodSignature:installedPluginsmethodSignature];
        [installed setSelector:NSSelectorFromString(@"containingBundle")];
        [installed setTarget:objc];
        [installed invoke];
        NSObject * app;
        [installed getReturnValue:&app];
        if (app != nil){
            NSString *appBundleId = [app performSelector:NSSelectorFromString(@"applicationIdentifier")];
            if (![set containsObject:appBundleId]){
                NSLog(@"%@",appBundleId);
                [set addObject:appBundleId];
            }
        }
    }
}
#pragma clang diagnostic pop

@end




//com.apple.reminders
//com.apple.DocumentsApp
//com.apple.social.SLYahooAuth
//com.apple.mobileslideshow
//com.apple.Health
//com.apple.DiagnosticsService
//com.apple.icloud.apps.messages.business

//com.apple.mobilecal
//com.apple.springboard
//com.apple.InCallService
//com.apple.camera
//com.apple.Jellyfish
//com.apple.Diagnostics
//com.apple.VoiceMemos
//com.apple.mobiletimer
//com.apple.FunCamera.ShapesPicker
//com.apple.ActivityMessagesApp
//com.apple.mobilenotes
//com.apple.mobileme.fmip1
//com.apple.Passbook
//com.apple.mobilesafari
//com.apple.FunCamera.TextPicker
//com.apple.AppStore
//com.apple.weather
//com.apple.PassbookUIService
//com.apple.MobileSMS

//cn.10086.app
//com.ss.iphone.ugc.Aweme

//com.dianping.dpscope
//com.sogou.sogouinput

//com.ss.iphone.article.News

//com.xiaomi.mihome

//com.nike.niketrainingclub
//com.apple.mobilephone
//youdaoPro

//me.ceeci.GreatWingy
//
//com.baidu.BaiduMobile
//com.xingin.discover

//com.tencent.QQ-Mobile-Token-2-0

//com.armelgibson.vignettes
//com.redefinFubei.ios
//com.apple.social.SLGoogleAuth
