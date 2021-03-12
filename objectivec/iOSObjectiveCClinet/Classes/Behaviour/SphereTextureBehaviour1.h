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
#ifndef TestBehaviour13_h
#define TestBehaviour13_h
#import "iOSObjectiveCFoundation.h"
#import "iOSObjectiveCGLES2Renderer.h"
@interface SphereTextureBehaviour1 : BaseBehaviour
@property FiniteStateMachine<SphereTextureBehaviour1*>* stateMachine;
@property GLES2BaseAsset* asset;
- (id)init;
- (void)onCreate:(Parameter*)parameter;
- (void)onUpdate:(NSTimeInterval)delta;
- (void)onDestroy;
@end
#endif /* TestBehaviour13_h */
