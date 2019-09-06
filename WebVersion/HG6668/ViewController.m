//
//  ViewController.m
//  HG6668
//
//  Created by david on 2018/7/25.
//  Copyright © 2018年 david. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <WebKit/WebKit.h>

@interface ViewController ()<UIWebViewDelegate,WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;

@property(nonatomic, assign) BOOL successLoad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    _webView.delegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    
    
//    WKUserContentController *userCC = config.userContentController;
//    //意思是网页中需要传递的参数是通过这个JS中的showMessage方法来传递的
//    [userCC addScriptMessageHandler:self name:@"showMessage"];
    
//    /*把url保存起来*/
//    NSString *localurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
//    if (!localurl || !localurl.length) {
//        [[NSUserDefaults standardUserDefaults] setObject:LinkUrl forKey:@"url"];
//    }
    
    
    /*加载网页*/
    [self loadWebView];
    
//    /*请求更新*/
//    [self requestUpdate];
//
//    /*侦测网络*/
////    __block __weak ViewController *ws = self;
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status == AFNetworkReachabilityStatusNotReachable) {
//            UIAlertController *alertc = [UIAlertController alertControllerWithTitle:@"网络已断开" message:@"请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alertc addAction:action];
//            [self presentViewController:alertc animated:YES completion:nil];
//        }
//        if (status > 0) {
//        }
//    }];
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

    NSURL *url = [NSURL URLWithString:LinkUrl];
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




//WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"是否允许这个导航：允许");
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //    Decides whether to allow or cancel a navigation after its response is known.
    
    NSLog(@"知道返回内容之后，是否允许加载：允许加载");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    //    self.progress.alpha  = 1;
    
    NSLog(@"开始加载地址===>%@",webView.URL.absoluteString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"跳转到其他的服务器");
    NSLog(@"跳转到其他的服务器===>%@",webView.URL.absoluteString);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"网页由于某些原因加载失败");
    NSLog(@"网页由于某些原因加载失败===>%@",webView.URL.absoluteString);

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页开始接收网页内容");
    NSLog(@"网页开始接收网页内容===>%@",webView.URL.absoluteString);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页导航加载完毕");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable ss, NSError * _Nullable error) {
        NSLog(@"网页导航加载完毕,加载----document.title:%@---webView title:%@",ss,webView.title);
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败,失败原因:%@",[error description]);
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"网页加载内容进程终止");
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",message);
    NSLog(@"%@",message.body);
    NSLog(@"%@",message.name);
    
    //这个是注入JS代码后的处理效果,尽管html已经有实现了,但是没用,还是执行JS中的实现
    if ([message.name isEqualToString:@"showMessage"]) {
        NSArray *array = message.body;
        NSLog(@"%@",array.firstObject);
        NSString *str = [NSString stringWithFormat:@"产品ID是: %@",array.firstObject];
        
    }
}
@end
