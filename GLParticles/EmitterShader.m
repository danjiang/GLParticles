//
//  EmitterShader.m
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import "EmitterShader.h"

#import "ShaderProcessor.h"

#define STRINGIFY(A) #A
#include "Emitter.vsh"
#include "Emitter.fsh"

@implementation EmitterShader

- (void)loadShader {
    ShaderProcessor *shaderProcessor = [[ShaderProcessor alloc] init];
    self.program = [shaderProcessor buildProgram:EmitterVS with:EmitterFS];
    
    self.aTheta = glGetAttribLocation(self.program, "aTheta");
    self.aShade = glGetAttribLocation(self.program, "aShade");

    self.uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
    self.uK = glGetUniformLocation(self.program, "uK");
    self.uColor = glGetUniformLocation(self.program, "uColor");
    self.uTime = glGetUniformLocation(self.program, "uTime");
    self.uTexture = glGetUniformLocation(self.program, "uTexture");
}

@end
