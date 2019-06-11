//
//  HttpClient.m
//  Runner
//
//  Created by Yaroslav Zozulia on 6/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "HttpClient.h"

@interface HttpClient ()

@property (nonatomic, retain) NSURLSession *session;

@end
@implementation HttpClient

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.defaultSessionConfiguration;
        self.session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)getWithUrl:(NSString *) url
           headers:(NSDictionary<NSString *, NSString *> *) headers
        completion:(void(^)(NSString *response, NSError *error)) completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    for (NSString* header in headers) {
        [mutableRequest setValue:headers[header] forHTTPHeaderField:header];
    }
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableRequest completionHandler:[^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            completion(value, nil);
        } else {
            completion(nil, error);
        }
    } copy]];
    [task resume];
}

@end
