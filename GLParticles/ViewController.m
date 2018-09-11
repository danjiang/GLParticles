//
//  ViewController.m
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import "ViewController.h"
#import "EmitterTemplate.h"
#import "EmitterShader.h"

@interface ViewController ()

@property (nonatomic, strong) EmitterShader *emitterShader;

@property (nonatomic, assign) float timeCurrent;
@property (nonatomic, assign) float timeMax;
@property (nonatomic, assign) float timeDirection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    
    self.timeCurrent = 0.0f;
    self.timeMax = 3.0f;
    self.timeDirection = 1.0f;
    
    [self loadTexture:@"texture_32.png"];
    [self loadShader];
    [self loadParticles];
    [self loadEmitter];
}

- (void)update {
    if (self.timeCurrent > self.timeMax) {
        self.timeDirection = -1;
    } else if (self.timeCurrent < 0.0f) {
        self.timeDirection = 1;
    }
    self.timeCurrent += self.timeDirection * self.timeSinceLastUpdate;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.30f, 0.74f, 0.20f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    float aspectRatio = view.frame.size.width / view.frame.size.height;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeScale(1.0f, aspectRatio, 1.0f);
    
    glUniformMatrix4fv(self.emitterShader.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniform1f(self.emitterShader.uK, emitter.k);
    glUniform3f(self.emitterShader.uColor, emitter.color[0], emitter.color[1], emitter.color[2]);
    glUniform1f(self.emitterShader.uTime, self.timeCurrent / self.timeMax);

    glEnableVertexAttribArray(self.emitterShader.aTheta);
    glVertexAttribPointer(self.emitterShader.aTheta, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, theta)));
    glEnableVertexAttribArray(self.emitterShader.aShade);
    glVertexAttribPointer(self.emitterShader.aShade, 3, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, shade)));

    glDrawArrays(GL_POINTS, 0, NUM_PARTICLES);
    glDisableVertexAttribArray(self.emitterShader.aTheta);
    glDisableVertexAttribArray(self.emitterShader.aShade);
}

- (void)loadParticles {
    for (int i = 0; i < NUM_PARTICLES; i++) {
        emitter.particles[i].theta = GLKMathDegreesToRadians(i);
        emitter.particles[i].shade[0] = [self randomFloatBetween:-0.25f and:0.25f];
        emitter.particles[i].shade[1] = [self randomFloatBetween:-0.25f and:0.25f];
        emitter.particles[i].shade[2] = [self randomFloatBetween:-0.25f and:0.25f];
    }
    
    GLuint particleBuffer = 0;
    glGenBuffers(1, &particleBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, particleBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(emitter.particles), emitter.particles, GL_STATIC_DRAW);
}

- (void)loadEmitter {
    emitter.k = 4.0f;
    emitter.color[0] = 0.76f;   // Color: R
    emitter.color[1] = 0.12f;   // Color: G
    emitter.color[2] = 0.34f;   // Color: B
}

- (void)loadShader {
    self.emitterShader = [EmitterShader new];
    [self.emitterShader loadShader];
    glUseProgram(self.emitterShader.program);
}

- (float)randomFloatBetween:(float)min and:(float)max {
    float range = max - min;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * range) + min;
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
