//
//  EmitterObject.m
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import "EmitterObject.h"

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
    float eSize;
    GLKVector3 eColor;
} Emitter;

@implementation EmitterObject

- (id)initEmitterObject {
    if (self = [super init]) {
        self.gravity = GLKVector2Make(0.0f, 0.0f);
        self.life = 0.0f;
        self.time = 0.0f;
    }
    return self;
}

- (void)renderWithProjection:(GLKMatrix4)projectionMatrix {
    
}

- (void)updateLifeCycle:(float)timeElapsed {
    
}

@end
