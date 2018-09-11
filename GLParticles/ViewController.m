//
//  ViewController.m
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import "ViewController.h"
#import "EmitterObject.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *emitters;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    
    self.emitters = [NSMutableArray array];
}

- (void)update {
    if ([self.emitters count] != 0) {
        NSMutableArray *deadEmitters = [NSMutableArray array];
        
        for (EmitterObject *emitter in self.emitters) {
            BOOL alive = [emitter updateLifeCycle:self.timeSinceLastUpdate];
            
            if (!alive) {
                [deadEmitters addObject:emitter];
            }
        }
        
        for (EmitterObject *emitter in deadEmitters) {
            [self.emitters removeObject:emitter];
        }
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.30f, 0.74f, 0.20f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    float aspectRatio = view.frame.size.width / view.frame.size.height;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeScale(1.0f, aspectRatio, 1.0f);
    
    if ([self.emitters count] != 0) {
        for (EmitterObject *emitter in self.emitters) {
            [emitter renderWithProjection:projectionMatrix];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touches.anyObject locationInView:self.view];
    CGPoint glPoint = CGPointMake(touchPoint.x / self.view.frame.size.width, touchPoint.y / self.view.frame.size.height);
    
    float aspectRatio = self.view.frame.size.width / self.view.frame.size.height;
    float x = (glPoint.x * 2.0f) - 1.0f;
    float y = ((glPoint.y * 2.0f) - 1.0f) * (-1.0f / aspectRatio);
    
    EmitterObject *emitter = [[EmitterObject alloc] initWithTexture:@"texture_64.png" at:GLKVector2Make(x, y)];
    [self.emitters addObject:emitter];
}

@end
