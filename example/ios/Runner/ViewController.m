//
//  ViewController.m
//  SceneKit -01
//
//  Created by ShiWen on 2017/6/13.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>
#import "XTSceneView1.h"


@interface ViewController ()
{
    SCNNode *lightNode;
}
@property (nonatomic,strong) SCNView *scenView;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, strong) SCNNode *node;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    XTSceneView1 *view = [[XTSceneView1 alloc]initWithWithFrame:CGRectMake(0, 0, 300, 300) viewIdentifier:nil arguments:nil binaryMessenger:nil ];
//
//    [self.view addSubview:view.returnView];
    
    
    [self.view addSubview:self.scenView];
    
}

-(SCNView*)scenView{
    if (!_scenView) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ship" withExtension:@"obj"];
        SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:nil];

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
        
        // 创建一个用来展示场景的SCNView
        SCNView *scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) ];
        [self.view addSubview:scnView];
        // 设置场景
        scnView.scene = scene;
        // 设置背景
        scnView.backgroundColor = [UIColor redColor];
        // 允许控制摄像机位置
        scnView.allowsCameraControl = YES;
        // 不显示数据控制台
        scnView.showsStatistics = NO;
    //    // 加点击事件
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCliked)];
    //    [scnView addGestureRecognizer:tap];

    }
    return _scenView;
}
- (SCNAction *)addRotateActionWithDuration:(NSInteger)duration{

    SCNAction *rotateAction = [SCNAction rotateByAngle:1 aroundAxis:SCNVector3Make(0, 1, 0) duration:duration];
    SCNAction *reRotateAction = [SCNAction repeatActionForever:rotateAction];
    return reRotateAction;

}
//- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
//    SCNVector3 prePosition = [_preNode convertPosition:_preNode.position toNode:_cameraNode]; // 计算相对坐标
//    SCNVector3 nextPosition = [_nextNode convertPosition:_nextNode.position toNode:_cameraNode];
////    NSLog(@"camera  x;%f,y:%f,z:%f",prePosition.x,prePosition.y,prePosition.z);
//    BOOL preOverlap = prePosition.x > - 0.3 / 2 && prePosition.x < 0.3 / 2 && prePosition.y > - 0.3 / 2 && prePosition.y < 0.3 / 2;
//    if (!_preAnimationEnd && preOverlap) {
//        // 两个node基本重合
//        if (!_isPreAnimating) {
//            [self runPreAnimation];
//        }
//    }else if (!_isNextAnimating && !preOverlap) {
//        _preAnimationEnd = NO;
//        [self removePreAnimation];
//    }
//
//    BOOL nextOverlap = nextPosition.x > - 0.3 / 2 && nextPosition.x < 0.3 / 2 && nextPosition.y > - 0.3 / 2 && nextPosition.y < 0.3 / 2;
//    if (!_nextAnimationEnd && nextOverlap) {
//        // 两个node基本重合
//        if (!_isNextAnimating) {
//            [self runNextAnimation];
//        }
//    }else if (!_isPreAnimating && !nextOverlap) {
//        _nextAnimationEnd = NO;
//        [self removeNextAnimation];
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (void)addMotionFunction {
//
//    CMMotionManager* _motionManager = [[CMMotionManager alloc]init];
//
//    _motionManager.deviceMotionUpdateInterval = 1.0 / 30.0;
//    _motionManager.gyroUpdateInterval = 1.0f / 30;
//    _motionManager.showsDeviceMovementDisplay = YES;
//    if (_motionManager.isDeviceMotionAvailable) {
//    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *_Nullable motion, NSError * _Nullable error) {
//
//    CMAttitude *attitude = motion.attitude;
//    if (attitude == nil) {
//    return;
//    }
//    lightNode.orientation = [self orientationFromCMQuaternion:attitude.quaternion];
//
//    }];
//
//    }
//}
//
//- (SCNQuaternion)orientationFromCMQuaternion:(CMQuaternion)quaternion {
//
//    GLKQuaternion gq1 = GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(- 90), 1, 0, 0);
//       // 这里x轴要同时旋转90度，这是因为手机陀螺仪的坐标系不一致：手机正放于桌面上的坐标为(0,0,0);而scnView坐标系是手机正立的时候为(0,0,0)；
//
//       GLKQuaternion gq2 = GLKQuaternionMake(quaternion.x, quaternion.y, quaternion.z, quaternion.w);
//       GLKQuaternion qp  = GLKQuaternionMultiply(gq1, gq2);
//       return SCNVector4Make(qp.x, qp.y, qp.z, qp.w);
//
//}

@end
