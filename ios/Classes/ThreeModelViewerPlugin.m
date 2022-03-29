#import "ThreeModelViewerPlugin.h"
#import "FlutterActivityIndicatorFactory.h"
@implementation ThreeModelViewerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ThreeModelViewerPlugin"
            binaryMessenger:[registrar messenger]];
  ThreeModelViewerPlugin* instance = [[ThreeModelViewerPlugin alloc] init];

  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar registerViewFactory:[[FlutterActivityIndicatorFactory alloc] initWithMessenger:registrar.messenger] withId:@"3dModelViewer"];
    
//  [registrar registerViewFactory:[[IOSFlutterPlatformViewFactory alloc] init] withId:@"3dModelViewer"];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;

    NSLog(@"=======================%@",dic);
    
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
      
  }if ([@"enableTouch" isEqualToString:call.method]) {
      
      NSDictionary *dic = call.arguments;
      
      BOOL enableTouch =[[dic objectForKey:@"enableTouch"] boolValue];//是否裁剪
      NSDictionary * object=[NSDictionary dictionary];
      if(enableTouch==true){
          object =@{
              @"enableTouch":@"1"
          };
      }else{
          object =@{
              @"enableTouch":@"0"
          };
      }
      [[NSNotificationCenter defaultCenter] postNotificationName:@"enableTouch" object:object];
        
    } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
