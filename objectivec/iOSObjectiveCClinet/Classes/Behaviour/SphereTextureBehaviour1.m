// ======================================================================
// Project Name    : ios_renderer_opengles1_client
//
// Copyright © 2020 U-CREATES. All rights reserved.
//
// This source code is the property of U-CREATES.
// If such findings are accepted at any time.
// We hope the tips and helpful in developing.
// Cube1
// ======================================================================
#import "SphereTextureBehaviour1.h"
@interface SphereTextureBehaviour1 ()
@property double rotate;
@end
@implementation SphereTextureBehaviour1
@synthesize asset;
@synthesize rotate;
- (id)init {
    self = [super init];
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* vertexShaderPath = [bundle pathForResource:@"vertex" ofType:@"glsl"];
    NSString* fragmentShaderPath = [bundle pathForResource:@"fragment" ofType:@"glsl"];
    bindCallBack cb = ^(double delta) {
      [self->asset.vertex setRandomColor:@"v_randomColor" programObject:self->asset.po];
      return;
    };
    GLES2ProgramObject* programObject = [[GLES2ProgramObject alloc] init];
    [programObject setVertexShader:vertexShaderPath];
    [programObject setFragmentShader:fragmentShaderPath];
    [programObject setPositionName:@"a_position"];
    [programObject setColorName:@"a_color"];
    [programObject setUVName:@"a_uv"];
    [programObject setNormalName:@"a_normal"];
    [programObject link];
    int primitiveType = (int)[Random range:0.0 max:2.0];
    int bufferType = 0 == (int)[Random range:0.0 max:10.0] % 2 ? kVBO : kVAO;
    if (0 == primitiveType) {
        self->asset = [[GLES2SphereAsset1 alloc] init:0.5f divideCount:100 color:GLES2Color.white bufferType:bufferType];
    } else {
        self->asset = [[GLES2SphereAsset2 alloc] init:0.5f divideCount:100 color:GLES2Color.white bufferType:bufferType];
    }
    [self->asset setProgramObject:programObject];
    [self->asset setBindCallback:cb];
    [self->asset create:@"texture01.jpg" textureUnitName:@"u_texture" textureUnitNumber:0];
    return self;
}
- (void)onCreate:(Parameter*)parameter {
    return;
}
- (void)onUpdate:(NSTimeInterval)delta {
    [self->asset.transform setPosition:0.0f y:0.0f z:0.0f];
    [self->asset.transform setScale:1.0f y:1.0f z:1.0f];
    [self->asset.transform setRotation:self->rotate y:self->rotate z:self->rotate];
    [self.timeLine next:delta];
    self->rotate += 1.0f;
    return;
}
- (void)onDestroy {
    //[self->asset dispose];
    return;
}
@end
