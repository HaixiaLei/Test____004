//
//  ViewController.m
//  HG6668
//
//  Created by david on 2018/7/25.
//  Copyright © 2018年 david. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic, assign) BOOL successLoad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    /*把url保存起来*/
    NSString *localurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
    if (!localurl || !localurl.length) {
        [[NSUserDefaults standardUserDefaults] setObject:LinkUrl forKey:@"url"];
    }
    
    
    /*加载网页*/
    [self loadWebView];
    
    /*请求更新*/
    [self requestUpdate];
    
    /*侦测网络*/
//    __block __weak ViewController *ws = self;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertController *alertc = [UIAlertController alertControllerWithTitle:@"网络已断开" message:@"请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertc addAction:action];
            [self presentViewController:alertc animated:YES completion:nil];
        }
        if (status > 0) {
        }
    }];
}

- (void)requestUpdate {
    __block NSString *urlstring;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        NSError *error;
        urlstring = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:UpdateUrl] encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSLog(@"下载到的字符串:%@",urlstring);
            if ([urlstring rangeOfString:@"http"].location == 0) {
                NSString *loadurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
                NSLog(@"本地的的字符串:%@",loadurl);
                if ([urlstring isEqualToString:loadurl]) {
                    NSLog(@"下载到的字符串与本地字符串相同，不处理!");
                } else {
                    NSLog(@"下载到的字符串与本地字符串不同！更新web");
                    dispatch_async(dispatch_get_main_queue(),^{//返回主线程
                        [[NSUserDefaults standardUserDefaults] setObject:urlstring forKey:@"url"];
                        [self loadWebView];
                    });
                }
            } else {
                NSLog(@"下载到的字符串不是已http开头，不处理!");
            }
        } else {
            NSLog(@"访问出错:%@",error.description);
        }
    });
}


/*加载网页*/
- (void)loadWebView {
    NSString *urlstring = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
    if (!urlstring || !urlstring.length) {
        urlstring = LinkUrl;
    }
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark UIWebviewDelegate 代理方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _successLoad = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _successLoad = YES;
}

#pragma mark UIAlertView 代理方法

@end
