//
//  FlutterActivityIndicatorFactory.h
//  path_provider_ios
//
//  Created by 崔小存 on 2022/3/26.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface FlutterActivityIndicatorFactory : NSObject<FlutterPlatformViewFactory>
@property (nonatomic, copy) void (^blockChangeTouchStatusClick)(BOOL isTouch);/**< 按钮block*/

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;

@end

NS_ASSUME_NONNULL_END
