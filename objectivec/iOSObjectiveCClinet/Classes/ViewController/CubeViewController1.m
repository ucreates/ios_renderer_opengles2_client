// ======================================================================
// Project Name    : ios_renderer_opengles1_client
//
// Copyright © 2019 U-CREATES. All rights reserved.
//
// This source code is the property of U-CREATES.
// If such findings are accepted at any time.
// We hope the tips and helpful in developing.
// ======================================================================
#define BUFFER_OFFSET(i) ((char*)NULL + (i))
#import "CubeViewController1.h"
#import "CubeBehaviour1.h"
#import "iOSObjectiveCFoundation.h"
#import "iOSObjectiveCGLES2Renderer.h"
@interface CubeViewController1 ()
@property GLES2Renderer* renderer;
@property NSMutableArray<CubeBehaviour1*>* behaviours;
@end
@implementation CubeViewController1
@synthesize renderer;
@synthesize behaviours;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.preferredFramesPerSecond = 60;
    self->renderer = [[GLES2Renderer alloc] init];
    [self->renderer setProjectionMatrixAttributeName:@"u_projectionMatrix"];
    [self->renderer setModelMatrixAttributeName:@"u_modelMatrix"];
    [self->renderer setViewMatrixAttributeName:@"u_viewMatrix"];
    [self->renderer create];
    [self->renderer.camera setClearColor:GLES2Color.black];
    [self->renderer.camera setFov:60.0f];
    [self->renderer.camera setClippingPlane:0.1f farPlane:100.0f dimension:kDimension3D];
    [self->renderer.camera setLookAt:GLKVector3Make(0.0f, 0.0f, -5.0f) center:GLKVector3Make(0.0f, 0.0f, 0.0f) up:GLKVector3Make(0.0f, 1.0f, 0.0f)];
    GLKView* glkView = (GLKView*)self.view;
    glkView.context = self->renderer.context;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    CAEAGLLayer* caglLayer = (CAEAGLLayer*)self.view.layer;
    caglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @NO, kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8};
    [caglLayer setOpaque:YES];
    CGSize size = UIScreen.mainScreen.nativeBounds.size;
    [self->renderer bind:caglLayer width:size.width height:size.height];
    self->behaviours = [[NSMutableArray<CubeBehaviour1*> alloc] init];
    CubeBehaviour1* behaviour = [[CubeBehaviour1 alloc] init];
    [self->behaviours addObject:behaviour];
    return;
}
- (void)viewWillLayoutSubviews {
    CAEAGLLayer* caglLayer = (CAEAGLLayer*)self.view.layer;
    [self->renderer rebind:caglLayer];
    return;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (CubeBehaviour1* behaviour in self->behaviours) {
        [behaviour onDestroy];
    }
    [self->renderer dispose];
    return;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)glkViewControllerUpdate:(nonnull GLKViewController*)controller {
    [renderer clear];
    [renderer transform:kDimension3D];
    for (CubeBehaviour1* behaviour in self->behaviours) {
        [behaviour onUpdate:self.timeSinceLastUpdate];
        [renderer render:behaviour.asset delta:self.timeSinceLastUpdate];
    }
    return;
}
@end
