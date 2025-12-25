//
//  FindingPatterns.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct FindingPatterns: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("The Filter Lens")
        .labelStyle()

      VStack(alignment: .leading, spacing: 20) {
        Text("Finding Patterns Among Images")
          .headingStyle()
          .fixedSize(horizontal: false, vertical: true)

        Text(
          "How does it work? It uses filters—mathematical lenses that scan for features."
        )
        .font(.body)
          .fixedSize(horizontal: false, vertical: true)

        FilterLens(imageName: "example")
          .padding(.vertical)

        Text(
          "Filters remove noise to focus on details like edges or textures."
        )
        .font(.body)

        Text(
          "Slide the lens to see the 'edges' the computer sees."
        )
        .font(.footnote)
        .foregroundColor(.secondary)
      }

      Spacer()
    }
    .padding()
  }
}

#Preview {
  FindingPatterns()
}
