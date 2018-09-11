//
//  EmitterObject.m
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import "EmitterObject.h"
#import "EmitterShader.h"

#define NUM_PARTICLES 180

typedef struct Particle
{
    float pID;
    float pRadiusOffset;
    float pVelocityOffset;
    float pDecayOffset;
    float pSizeOffset;
    GLKVector3 pColorOffset;
} Particle;

typedef struct Emitter
{
    Particle eParticles[NUM_PARTICLES];
    float eRadius;
    float eVelocity;
    float eDecay;
    float eSizeStart;
    float eSizeEnd;
    GLKVector3 eColorStart;
    GLKVector3 eColorEnd;
    GLKVector2 ePosition;
} Emitter;

@interface EmitterObject ()

@property (nonatomic, assign) Emitter emitter;
@property (nonatomic, strong) EmitterShader *shader;

@end

@implementation EmitterObject

- (id)initWithTexture:(NSString *)fileName at:(GLKVector2)position {
    if (self = [super init]) {
        self.gravity = GLKVector2Make(0.0f, 0.0f);
        self.life = 0.0f;
        self.time = 0.0f;
        self.particleBuffer = 0;
        [self loadShader];
        [self loadTexture:fileName];
        [self loadParticleSystem:position];
    }
    return self;
}

- (void)renderWithProjection:(GLKMatrix4)projectionMatrix {
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);

    glUniformMatrix4fv(self.shader.u_ProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniform2f(self.shader.u_Gravity, self.gravity.x, self.gravity.y);
    glUniform1f(self.shader.u_Time, self.time);
    glUniform1f(self.shader.u_eRadius, self.emitter.eRadius);
    glUniform1f(self.shader.u_eVelocity, self.emitter.eVelocity);
    glUniform1f(self.shader.u_eDecay, self.emitter.eDecay);
    glUniform1f(self.shader.u_eSizeStart, self.emitter.eSizeStart);
    glUniform1f(self.shader.u_eSizeEnd, self.emitter.eSizeEnd);
    glUniform3f(self.shader.u_eColorStart, self.emitter.eColorStart.r, self.emitter.eColorStart.g, self.emitter.eColorStart.b);
    glUniform3f(self.shader.u_eColorEnd, self.emitter.eColorEnd.r, self.emitter.eColorEnd.g, self.emitter.eColorEnd.b);
    glUniform1i(self.shader.u_Texture, 0);
    glUniform2f(self.shader.u_ePosition, self.emitter.ePosition.x, self.emitter.ePosition.y);

    glEnableVertexAttribArray(self.shader.a_pID);
    glEnableVertexAttribArray(self.shader.a_pRadiusOffset);
    glEnableVertexAttribArray(self.shader.a_pVelocityOffset);
    glEnableVertexAttribArray(self.shader.a_pDecayOffset);
    glEnableVertexAttribArray(self.shader.a_pColorOffset);
    
    glVertexAttribPointer(self.shader.a_pID, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pID)));
    glVertexAttribPointer(self.shader.a_pRadiusOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pRadiusOffset)));
    glVertexAttribPointer(self.shader.a_pVelocityOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pVelocityOffset)));
    glVertexAttribPointer(self.shader.a_pDecayOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pDecayOffset)));
    glVertexAttribPointer(self.shader.a_pSizeOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pSizeOffset)));
    glVertexAttribPointer(self.shader.a_pColorOffset, 3, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pColorOffset)));

    glDrawArrays(GL_POINTS, 0, NUM_PARTICLES);
    glDisableVertexAttribArray(self.shader.a_pID);
    glDisableVertexAttribArray(self.shader.a_pRadiusOffset);
    glDisableVertexAttribArray(self.shader.a_pVelocityOffset);
    glDisableVertexAttribArray(self.shader.a_pDecayOffset);
    glDisableVertexAttribArray(self.shader.a_pSizeOffset);
    glDisableVertexAttribArray(self.shader.a_pColorOffset);
}

- (BOOL)updateLifeCycle:(float)timeElapsed {
    self.time += timeElapsed;
    if (self.time < self.life) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadShader {
    self.shader = [EmitterShader new];
    [self.shader loadShader];
    glUseProgram(self.shader.program);
}

- (float)randomFloatBetween:(float)min and:(float)max {
    float range = max - min;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * range) + min;
}

- (void)loadParticleSystem:(GLKVector2)position {
    Emitter newEmitter = {0.0f};
    
    float oRadius = 0.10f;
    float oVelocity = 0.50f;
    float oDecay = 0.25f;
    float oSize = 8.00f;
    float oColor = 0.25f;

    for (int i = 0; i < NUM_PARTICLES; i++) {
        newEmitter.eParticles[i].pID = GLKMathDegreesToRadians(((float)i/(float)NUM_PARTICLES)*360.0f);
        newEmitter.eParticles[i].pRadiusOffset = [self randomFloatBetween:oRadius and:1.00f];
        newEmitter.eParticles[i].pVelocityOffset = [self randomFloatBetween:-oVelocity and:oVelocity];
        newEmitter.eParticles[i].pDecayOffset = [self randomFloatBetween:-oDecay and:oDecay];
        newEmitter.eParticles[i].pSizeOffset = [self randomFloatBetween:-oSize and:oSize];
        float r = [self randomFloatBetween:-oColor and:oColor];
        float g = [self randomFloatBetween:-oColor and:oColor];
        float b = [self randomFloatBetween:-oColor and:oColor];
        newEmitter.eParticles[i].pColorOffset = GLKVector3Make(r, g, b);
    }
    
    newEmitter.eRadius = 0.75f;
    newEmitter.eVelocity = 3.00f;
    newEmitter.eDecay = 2.00f;
    newEmitter.eSizeStart = 32.00f;
    newEmitter.eColorStart = GLKVector3Make(1.00f, 0.50f, 0.00f);
    newEmitter.eSizeEnd = 8.00f;
    newEmitter.eColorEnd = GLKVector3Make(0.25f, 0.00f, 0.00f);
    newEmitter.ePosition = position;
    
    float growth = newEmitter.eRadius / newEmitter.eVelocity;
    _life = growth + newEmitter.eDecay + oDecay;
    
    float drag = 10.00f;
    _gravity = GLKVector2Make(0.00f, -9.81f*(1.0f/drag));

    self.emitter = newEmitter;
    glGenBuffers(1, &_particleBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(self.emitter.eParticles), self.emitter.eParticles, GL_STATIC_DRAW);
}

- (void)loadTexture:(NSString *)fileName {
    NSDictionary *options = @{@YES: GLKTextureLoaderOriginBottomLeft};
    
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    GLKTextureInfo *texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (texture == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    
    glBindTexture(GL_TEXTURE_2D, texture.name);
}

@end
