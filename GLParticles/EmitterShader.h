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

@property (nonatomic, assign) GLint a_pID;
@property (nonatomic, assign) GLint a_pRadiusOffset;
@property (nonatomic, assign) GLint a_pVelocityOffset;
@property (nonatomic, assign) GLint a_pDecayOffset;
@property (nonatomic, assign) GLint a_pSizeOffset;
@property (nonatomic, assign) GLint a_pColorOffset;

@property (nonatomic, assign) GLint u_ProjectionMatrix;
@property (nonatomic, assign) GLint u_Gravity;
@property (nonatomic, assign) GLint u_Time;
@property (nonatomic, assign) GLint u_eRadius;
@property (nonatomic, assign) GLint u_eVelocity;
@property (nonatomic, assign) GLint u_eDecay;
@property (nonatomic, assign) GLint u_eSizeStart;
@property (nonatomic, assign) GLint u_eSizeEnd;
@property (nonatomic, assign) GLint u_eColorStart;
@property (nonatomic, assign) GLint u_eColorEnd;
@property (nonatomic, assign) GLint u_Texture;
@property (nonatomic, assign) GLint u_ePosition;

- (void)loadShader;

@end
