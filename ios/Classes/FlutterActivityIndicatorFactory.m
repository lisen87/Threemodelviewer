//
//  FlutterActivityIndicatorFactory.m
//  path_provider_ios
//
//  Created by 崔小存 on 2022/3/26.
//

#import "FlutterActivityIndicatorFactory.h"
#import "XTSceneView.h"
@implementation FlutterActivityIndicatorFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;

}
-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    _messenger = messager;

    self = [super init];
    if (self) {
    }
    return self;
}

//设置参数的编码方式
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];

}
-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
//    NSLog(@"宽度%f",frame.size.width);
//    NSLog(@"高度%f",frame.size.height);

    XTSceneView *scence = [[XTSceneView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return scence;
}


@end
