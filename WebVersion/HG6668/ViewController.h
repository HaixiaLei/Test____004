//
//  ViewController.h
//  HG6668
//
//  Created by david on 2018/7/25.
//  Copyright © 2018年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

/*产品区分*/
#if ProductID == 1
#define LinkUrl      @"https://m.hhhg6668.com/"
//#define LinkUrl        @"https://m.hg98985.com/"
#define UpdateUrl      @"https://hg00086.firebaseapp.com/d/d1.json"
#elif ProductID == 2
#define LinkUrl        @"https://m.hg00551.com"
#define UpdateUrl      @"https://hg00086.firebaseapp.com/d/d2.json"
#endif


/*网络环境定义*/
#define Timeout             10                                          //超时
#define Environment         1                                           //环境变量，1：开发

#if (Environment == 1)
#define HOST_P              @"http://192.168.1.15/"                     //域名
#elif (Environment == 2)
#define HOST_P              @"http://m.hg3088.lcn/"                     //域名
#endif

#define API                 @"release.php"                              //接口



@interface ViewController : UIViewController

@property(nonatomic, strong) UIWebView *webView;


@end

