//
//  ShareFlutterMethodCallHandler.m
//  Runner
//
//  Created by Yaroslav Zozulia on 6/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "ShareFlutterMethodCallHandler.h"
#import <Flutter/Flutter.h>

@interface ShareFlutterMethodCallHandler ()

@property (nonatomic, readonly, weak) UIViewController *viewController;

@end
@implementation ShareFlutterMethodCallHandler

- (instancetype)initWithViewContoller:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (NSString *)channel {
    return @"com.develop.zuzik.flutter_rss_reader/share";
}

- (FlutterMethodCallHandler)get {
    return ^(FlutterMethodCall* call, FlutterResult result) {
        if ([@"url" isEqualToString:call.method]) {
            if (_viewController) {
                NSDictionary *arguments = call.arguments;
                NSString *url = arguments[@"url"];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
                [_viewController presentViewController:activityVC
                                              animated:YES
                                            completion:^{
                                               result(nil);
                                            }];
            } else {
                result([FlutterError errorWithCode:@"ShareFlutterMethodCallHandler"
                                           message:@"Can't share url"
                                           details:nil]);
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
    };
}

@end
