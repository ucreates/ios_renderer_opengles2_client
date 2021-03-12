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
#import "CircleTextureViewController1.h"
#import "CircleTextureBehaviour1.h"
#import "iOSObjectiveCFoundation.h"
#import "iOSObjectiveCGLES2Renderer.h"
@interface CircleTextureViewController1 ()
@property GLES2Renderer* renderer;
@property NSMutableArray<CircleTextureBehaviour1*>* behaviours;
@end
@implementation CircleTextureViewController1
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
    [self->renderer.camera setClippingPlane:-1.0f farPlane:1.0f dimension:kDimension2D];
    GLKView* glkView = (GLKView*)self.view;
    glkView.context = self->renderer.context;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    CAEAGLLayer* caglLayer = (CAEAGLLayer*)self.view.layer;
    caglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @NO, kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8};
    [caglLayer setOpaque:YES];
    CGSize size = UIScreen.mainScreen.nativeBounds.size;
    [self->renderer bind:caglLayer width:size.width height:size.height];
    self->behaviours = [[NSMutableArray<CircleTextureBehaviour1*> alloc] init];
    CircleTextureBehaviour1* behaviour = [[CircleTextureBehaviour1 alloc] init];
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
    for (CircleTextureBehaviour1* behaviour in self->behaviours) {
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
    [renderer transform:kDimension2D];
    for (CircleTextureBehaviour1* behaviour in self->behaviours) {
        [behaviour onUpdate:self.timeSinceLastUpdate];
        [renderer render:behaviour.asset delta:self.timeSinceLastUpdate];
    }
    return;
}
@end
