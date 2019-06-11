#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <Flutter/Flutter.h>
#include "HttpClientFlutterMethodCallHandler.h"
#include "ShareFlutterMethodCallHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    HttpClientFlutterMethodCallHandler* httpClientHandler = [[HttpClientFlutterMethodCallHandler alloc] init];
    FlutterMethodChannel* httpClientChannel = [FlutterMethodChannel methodChannelWithName:[httpClientHandler channel] binaryMessenger:controller];
    [httpClientChannel setMethodCallHandler:[httpClientHandler get]];
    
    ShareFlutterMethodCallHandler* shareHandler = [[ShareFlutterMethodCallHandler alloc] initWithViewContoller:controller];
    FlutterMethodChannel* shareChannel = [FlutterMethodChannel methodChannelWithName:[shareHandler channel] binaryMessenger:controller];
    [shareChannel setMethodCallHandler:[shareHandler get]];
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
