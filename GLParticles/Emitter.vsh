static const char* EmitterVS = STRINGIFY
(

 attribute float aTheta;
 attribute vec3 aShade;

 uniform mat4 uProjectionMatrix;
 uniform float uK;
 uniform float uTime;
 
 varying vec3 vShade;
 
 void main(void)
 {
     float x = uTime * cos(uK*aTheta)*sin(aTheta);
     float y = uTime * cos(uK*aTheta)*cos(aTheta);
     
     gl_Position = uProjectionMatrix * vec4(x, y, 0.0, 1.0);
     gl_PointSize = 16.0;
     
     vShade = aShade;
 }

 );
