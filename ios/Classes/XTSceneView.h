//
//  XTSceneView.h
//  XTSceneView
//
//  Created by 薛涛 on 2018/6/13.
//  Copyright © 2018年 XT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

@interface XTSceneView : NSObject<FlutterPlatformView>


@property (nonatomic, strong) SCNNode *node;
@property (nonatomic, strong) UIView *returnView;
@property (nonatomic, strong)SCNView *scnView;
@property (nonatomic, strong) NSDictionary *argsDic;

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
