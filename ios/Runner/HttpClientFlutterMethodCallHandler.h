//
//  HttpClientFlutterMethodCallHandler.h
//  Runner
//
//  Created by Yaroslav Zozulia on 6/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpClientFlutterMethodCallHandler : NSObject

- (NSString *)channel;
- (FlutterMethodCallHandler)get;

@end

NS_ASSUME_NONNULL_END
