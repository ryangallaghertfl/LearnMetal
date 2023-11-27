//
//  Color.metal
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//
// import the Metal Standard Library, which contains many commonly used mathematical operations for shaders.
#include <metal_stdlib>
//we can write float2 instead of metal::float2 for position and half4 instead of metal::half4 for color.
using namespace metal;

//float2 is a vector of 2 floating-point numbers — that is, it stores two separate numbers together in the one type. Here, it’s used to represent the x and y coordinates of on-screen pixels (accessible through dot-syntax)

//half4 is a vector of 4 half-width floating-point numbers. Half-width means their bits are stored in half as much memory as a float (this is the opposite of a double). This more lightweight type is used used to store the r, g, b, and a values for a color, which can also be accessed via dot-syntax.


[[ stitchable ]]                            // 1
half4 colorOne(                          // 2
    float2 position,                        // 3
    half4 color                             // 4
) {
    return color;                           // 5
}

/*
 1. The [[ stitchable ]] declaration does two things. Firstly, it tells the compiler to make the function visible to the Metal Framework API, allowing us to use it in SwiftUI. Secondly, it allows Metal to stitch shaders together at runtime. This means the shader code, and SwiftUI view modifiers themselves, can be used to compose multiple shader effects together in a performant manner on the same views.
 2. half4 color is the return type and our function name. This is the standard function syntax for C-family languages.
 3. float2 position inputs the coordinates of the pixel this shader function is operating on.
 4. The half4 color argument is the starting color of the pixel on which this shader is operating.
 5. return color; is the return statement — it is the resulting color of the pixel at position. Here, we are just returning the original color without changing anything.

 */

//For a shader function to act as a color filter it must have a function signature matching: [[ stitchable ]] half4 name(float2 position, half4 color, args...). The function should return the modified color value.

[[ stitchable ]]
half4 colorTwo(
    float2 position,
    half4 color
) {
    return half4(0.0, 128.0, 255.0, 1.0);
}

[[ stitchable ]]
half4 colorRedGradient(
    float2 position,
    half4 color
) {
    return half4(position.x/255.0, 0.0, 0.0, 1.0);
}

//We get red gradient effect because position.x/255.0 begins at zero, then happily increases by the x position of each pixel. Once the shader gets 255 pixels along, position.x/255.0 resolves to 1.0, which is plain red. The max value of the red component is 1.0, so everything past 255 pixels stays red

[[ stitchable ]]
half4 colorRedGreenXYGradient(
    float2 position,
    half4 color
) {
    return half4(position.x/255.0, position.y/255.0, 0.0, 1.0);
}

//This gradient modulates red and green components of colour by horizontal X and vertical Y positions. However it will look very different on different screen sizes due to the shader working with discrete numbers of pixels.

[[ stitchable ]]
half4 color(
    float2 position,
    half4 color
) {
    return half4(position.x/255.0, position.y/255.0, 0.0, 1.0);
}

[[ stitchable ]]
half4 sizeAwareColorRedBlack(float2 position, half4 color, float2 size) {
    return half4(position.x/size.x, 0.0, 0.0, 1.0);
}    //each pixel’s red colour component is calculated by its relative horizontal position on-screen. For positions where x=0, the red component is 0, giving us a black colour along the leading edge. For positions where x=500, if the full horizontal size of the view is 1000 pixels, then position.x/size.x gives us 500/1000 which equals 0.5. This is the dark red in the middle of the screen. For positions where x is equal to the full horizontal size — that is, the trailing edge, then position.x/size.x is just 1, giving the full red colour.

[[ stitchable ]]
half4 sizeAwareColorRedGreen(float2 position, half4 color, float2 size) {
    return half4(position.x/size.x, position.y/size.y, 0.0, 1.0);
} //Now the red colour component varies horizontally, and the green colour component varies vertically. As you can see, the key to learning shaders is taking a simple mathematical effect and layering on more complexity, bit by bit.

[[ stitchable ]]
half4 sizeAwareColor(
    float2 position,
    half4 color,
    float2 size
) {
    return half4(position.x/size.x, position.y/size.y, position.x/size.y, 1.0);
} //Red, green, and blue gradient created by modulating RGB color values with position and size, giving a pastel effect

float oscillate(float f) {
    return 0.5 * (sin(f) + 1);
}

[[ stitchable ]]
half4 timeVaryingColor(
    float2 position,
    half4 color,
    float2 size,
    float time
) {
    return half4(oscillate(2 * time + position.x/size.x),
                 oscillate(4 * time + position.y/size.y),
                 oscillate(-2 * time + position.x/size.y),
                 1.0);
}
