//
//  ShaderProcessor.h
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface ShaderProcessor : NSObject

- (GLuint)buildProgram:(const char*)vertexShaderSource with:(const char*)fragmentShaderSource;

@end
