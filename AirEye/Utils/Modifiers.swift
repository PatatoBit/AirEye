//
//  Modifiers.swift
//  AirEye
//
//  Created by Patato on 23/12/25.
//

import SwiftUI

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.gray)
    }
}

struct HeadingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontDesign(.rounded)
            .font(.largeTitle)
            .bold()
            .padding(.bottom, 8)
    }
}

struct FullFrame: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DebugBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .border(Color.red, width: 1)
    }
}

extension View {
    func labelStyle() -> some View { modifier(LabelStyle()) }
    func headingStyle() -> some View { modifier(HeadingStyle()) }
    func fullFrameStyle() -> some View { modifier(FullFrame())}
    func debugBorderStyle() -> some View  {modifier(DebugBorder())}
}
