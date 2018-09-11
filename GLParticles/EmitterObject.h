//
//  EmitterObject.h
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface EmitterObject : NSObject

@property (nonatomic, assign) GLKVector2 gravity;
@property (nonatomic, assign) float life;
@property (nonatomic, assign) float time;

- (id)initEmitterObject;
- (void)renderWithProjection:(GLKMatrix4)projectionMatrix;
- (void)updateLifeCycle:(float)timeElapsed;

@end
