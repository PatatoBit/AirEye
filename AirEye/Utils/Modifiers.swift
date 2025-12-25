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
      .font(.caption)
      .fontWeight(.bold)
      .foregroundColor(.secondary)
      .textCase(.uppercase)
  }
}

struct HeadingStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.largeTitle)  // Replaced .headingStyle()
      .bold()
      .fontDesign(.rounded)
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
  func fullFrameStyle() -> some View { modifier(FullFrame()) }
  func debugBorderStyle() -> some View { modifier(DebugBorder()) }
}
