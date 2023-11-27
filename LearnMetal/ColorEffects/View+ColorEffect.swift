//
//  View+ColorEffect.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

import SwiftUI

extension View {
    
    func colorShader() -> some View {
        modifier(ColorShader())
    }
    
    func sizeAwareColorShader() -> some View {
        modifier(SizeAwareColorShader())
    }
    
    func timeVaryingColorShader() -> some View {
        modifier(TimeVaryingColorShader())
    }
}

//to make the colorEffect shader more smooth, and, vitally, to ensure the behaviour of full-screen shaders is similar on all screen sizes, we need to know the geometry of the view which we’re modifying.

struct ColorShader: ViewModifier {
    
    func body(content: Content) -> some View {
        content.colorEffect(ShaderLibrary.color()) // colorEffect modifier takes a Shader as an argument. This is a reference to a function in a shader library, and also accepts any arguments
        
        //ShaderLibrary itself is another struct that uses dynamic member lookup to locate a ShaderFunction that you specify in your .metal files.
    }
}

//shader function has the standard colorEffect args, plus the new size argument to play with
struct SizeAwareColorShader: ViewModifier {
    // The new visualEffect modifier is designed to give access to layout information such as size
    func body(content: Content) -> some View {
        content.visualEffect { content, proxy in
            content
                .colorEffect(ShaderLibrary.sizeAwareColor(
                    .float2(proxy.size)
                    //we're using size as an argument in our shader. Since it’s two-dimensional information, it’s stored as a float2
                ))
        }
    }
}

struct TimeVaryingColorShader: ViewModifier {
    
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content.visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.timeVaryingColor(
                        .float2(proxy.size),
                        .float(startDate.timeIntervalSinceNow)
                    ))
            }
        }
    }
}
