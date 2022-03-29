#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <threemodelviewer/FlutterActivityIndicatorFactory.h>
#import <threemodelviewer/ThreeModelViewerPlugin.h>
#import <Flutter/Flutter.h>
#import "ViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

//    ViewController *homePage = [[ViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController :homePage];
//    self.window.rootViewController =nav;
//    [self.window makeKeyAndVisible];
//
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
