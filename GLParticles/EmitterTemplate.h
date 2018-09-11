//
//  EmitterTemplate.h
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/11.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#define NUM_PARTICLES 360

typedef struct Particle
{
    float       theta;
    float       shade[3];
}
Particle;

typedef struct Emitter
{
    Particle    particles[NUM_PARTICLES];
    int         k;
    float       color[3];
}
Emitter;

Emitter emitter = {0.0f};
