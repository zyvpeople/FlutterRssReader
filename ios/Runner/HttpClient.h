//
//  HttpClient.h
//  Runner
//
//  Created by Yaroslav Zozulia on 6/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpClient : NSObject

- (void)getWithUrl:(NSString *) url
        headers:(NSDictionary<NSString *, NSString *> *) headers
        completion:(void(^)(NSString *response, NSError *error)) completion;

@end

NS_ASSUME_NONNULL_END
