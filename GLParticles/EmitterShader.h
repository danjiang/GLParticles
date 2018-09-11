//
//  EmitterShader.h
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface EmitterShader : NSObject

@property (nonatomic, assign) GLint program;

@property (nonatomic, assign) GLint aTheta;
@property (nonatomic, assign) GLint aShade;

@property (nonatomic, assign) GLint uProjectionMatrix;
@property (nonatomic, assign) GLint uK;
@property (nonatomic, assign) GLint uColor;
@property (nonatomic, assign) GLint uTime;
@property (nonatomic, assign) GLint uTexture;

- (void)loadShader;

@end
