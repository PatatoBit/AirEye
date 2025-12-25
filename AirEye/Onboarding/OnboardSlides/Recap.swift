//
//  Recap.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct Recap: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("Summary")
        .labelStyle()

      VStack(alignment: .leading, spacing: 20) {
        Text("Putting It All Together")
          .headingStyle()
          .frame(maxWidth: .infinity, alignment: .topLeading)

        Text("We've seen how AirEye works under the hood:")
          .font(.body)
          .padding(.bottom, 10)

        VStack(alignment: .leading, spacing: 24) {
          RecapItem(
            icon: "camera.viewfinder", color: .blue, title: "Vision",
            description: "The camera converts the world into millions of pixel numbers.")

          RecapItem(
            icon: "slider.horizontal.3", color: .purple, title: "Features",
            description:
              "Mathematical filters scan those numbers to find edges, textures, and haze."
          )

          RecapItem(
            icon: "brain.head.profile", color: .orange, title: "Intelligence",
            description: "The ML model uses those patterns to predict the Air Quality Index.")
        }

        Spacer()

        Text("Now, let's see it in action.")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.top)
      }
      Spacer()
    }
    .fullFrameStyle()
    .padding()
  }
}

struct RecapItem: View {
  let icon: String
  let color: Color
  let title: String
  let description: String

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(.white)
        .frame(width: 44, height: 44)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.headline)
        Text(description)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}

#Preview {
  Recap()
}
