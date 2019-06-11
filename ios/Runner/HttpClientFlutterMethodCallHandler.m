//
//  HttpClientFlutterMethodCallHandler.m
//  Runner
//
//  Created by Yaroslav Zozulia on 6/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "HttpClientFlutterMethodCallHandler.h"
#import "HttpClient.h"
#import <Flutter/Flutter.h>

@interface HttpClientFlutterMethodCallHandler()

@property (nonatomic, readonly) HttpClient* httpClient;

@end

@implementation HttpClientFlutterMethodCallHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        _httpClient = [[HttpClient alloc] init];
    }
    return self;
}

- (NSString *)channel {
    return @"com.develop.zuzik.flutter_rss_reader/httpClient";
}

- (FlutterMethodCallHandler)get {
    return ^(FlutterMethodCall* call, FlutterResult result) {
        if ([@"get" isEqualToString:call.method]) {
            NSDictionary *arguments = call.arguments;
            NSString *url = arguments[@"url"];
            NSDictionary<NSString *, NSString *> *headers = arguments[@"headers"];
            [_httpClient getWithUrl:url headers:headers completion:^(NSString * _Nonnull response, NSError * _Nonnull error) {
                if (response) {
                    result(response);
                } else {
                    result([FlutterError errorWithCode:@"HttpClientMethodCallHandler"
                                               message:error.description
                                               details:nil]);
                }
            }];
        } else {
            result(FlutterMethodNotImplemented);
        }
    };
}

@end
