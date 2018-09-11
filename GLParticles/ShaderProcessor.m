//
//  ShaderProcessor.m
//  GLParticles
//
//  Created by Dan Jiang on 2018/9/10.
//  Copyright © 2018年 Dan Jiang. All rights reserved.
//

#import "ShaderProcessor.h"

@implementation ShaderProcessor

- (GLuint)buildProgram:(const char*)vertexShaderSource with:(const char*)fragmentShaderSource {
    GLuint vertexShader = [self buildShader:vertexShaderSource with:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self buildShader:fragmentShaderSource with:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        NSLog(@"GLSL Program Error");
        GLchar messages[1024];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return programHandle;
}

- (GLuint)buildShader:(const char*)source with:(GLenum)shaderType {
    GLuint shaderHandle = glCreateShader(shaderType);
    
    glShaderSource(shaderHandle, 1, &source, 0);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        NSLog(@"GLSL Shader Error");
        GLchar messages[1024];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

@end
