
//
//  XTSceneView.m
//  XTSceneView
//
//  Created by 薛涛 on 2018/6/13.
//  Copyright © 2018年 XT. All rights reserved.
//

#import "XTSceneView.h"
#import <ModelIO/MDLAsset.h>
#import <SceneKit/ModelIO.h>
#define RUN_AFTER(s, b) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s * NSEC_PER_SEC)), dispatch_get_main_queue(), b)

@implementation XTSceneView

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId arguments:(id)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    NSLog(@"%@",args);
    
    if (self = [super init]) {
        _argsDic =[NSDictionary dictionary];
        _argsDic =args;

        [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(getNotificationAction:) name:@"enableTouch" object:nil];
        [self createScene];
    }
    
    return self;
    
}
- (void)getNotificationAction:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    // 这样就得到了我们在发送通知时候传入的字典了
    if([[infoDic objectForKey:@"enableTouch"] isEqualToString:@"1"]){
        self.scnView.userInteractionEnabled=YES;
    }else{
        self.scnView.userInteractionEnabled=NO;
    }
}
#pragma mark - 创建3D模型场景
- (void)createScene {
    
    NSString *tmpPaht = _argsDic[@"src"];
    NSFileManager* fm=[NSFileManager defaultManager];
    NSString *subString = @"";
    if(tmpPaht.length<8){

    }else{
        subString = [tmpPaht substringFromIndex:7];

    }
    BOOL isExist =[fm fileExistsAtPath:subString];
    NSError*ERROR =nil;

    SCNScene *scene = [SCNScene sceneWithURL:[NSURL fileURLWithPath:subString] options:nil error:&ERROR];

    // 取出场景中根结点的第一个结点 目录根结点也就一个子结点
    _node = scene.rootNode;
    [_node runAction: [self addRotateActionWithDuration:10]];
    _node = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:20]];
    _node.position =SCNVector3Make(0, 0, 0);

    // 创建灯光
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeAmbient;
    lightNode.light.color = [UIColor whiteColor];
    [scene.rootNode addChildNode:lightNode];
//
    // 创建一个用来展示场景的SCNView
    self.scnView = [[SCNView alloc] init];
    // 设置场景
    self.scnView.scene = scene;
    // 设置背景
    self.scnView.backgroundColor = [UIColor clearColor];
    // 允许控制摄像机位置
    self.scnView.allowsCameraControl = YES;
    // 不显示数据控制台
    self.scnView.showsStatistics = NO;

}
//5.动画自我旋转

- (SCNAction *)addRotateActionWithDuration:(NSInteger)duration{

    SCNAction *rotateAction = [SCNAction rotateByAngle:1 aroundAxis:SCNVector3Make(0, 1, 0) duration:duration];
    SCNAction *reRotateAction = [SCNAction repeatActionForever:rotateAction];
    return reRotateAction;

}
-(UIView *)view{

    return self.scnView ;

}



//#pragma mark - 点击事件
//- (void)tapCliked {
//
//    if (!_select) {
//
//        [_node runAction:[SCNAction fadeInWithDuration:0.3]];
//        [_node runAction:[SCNAction scaleTo:1.1 duration:0.3]];
//
//    } else {
//
//        [_node runAction:[SCNAction fadeOpacityTo:0.3 duration:0.3]];
//        [_node runAction:[SCNAction scaleTo:1.0 duration:0.3]];
//
//    }
//
//    _select = !_select;
//
//}

//- (nonnull UIView *)view {
//    <#code#>
//}
//
//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearance {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}
//
//- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}
//
//- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}
//
//- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}
//
//- (nonnull NSArray<id<UIFocusItem>> *)focusItemsInRect:(CGRect)rect {
//    <#code#>
//}


@end











