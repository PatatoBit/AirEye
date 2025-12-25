//
//  ComputerVision.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct ComputerVision: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("Pixels = Numbers")
        .labelStyle()

      VStack(alignment: .leading, spacing: 20) {
        Text("How Computers See Images")
          .headingStyle()

        Text("Unlike humans, all computers see are just pixel values. Hold the image to see.")

        ImagePixelInspector(imageName: "example")
          // .frame(height: 300)
          .clipShape(RoundedRectangle(cornerRadius: 12))

        Text(
          "Your phone camera captures 12+ million pixels in one photo. "
        )
        Text("Each pixel is 3 numbers (Red, Green, Blue).")
        Text("That's 36+ million numbers just to see one image!")
      }
      Spacer()
    }
    .padding()
  }
}

struct ImagePixelInspector: View {
  let imageName: String
  @State private var dragLocation: CGPoint = .zero
  @State private var pixelColor: Color = .clear
  @State private var pixelValues: (r: Int, g: Int, b: Int)?
  @State private var isTouching = false

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .topLeading) {
        if let uiImage = UIImage(named: imageName) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()  // Using Fill to cover the frame
            .frame(width: geometry.size.width, height: geometry.size.height)
            .highPriorityGesture(
              DragGesture(minimumDistance: 5)
                .onChanged { value in
                  isTouching = true
                  dragLocation = value.location
                  readPixel(at: value.location, in: geometry.size, for: uiImage)
                }
                .onEnded { _ in
                  isTouching = false
                }
            )
        } else {
          // Fallback if image name is wrong
          Color.gray
            .overlay(Text("Image not found"))
        }

        // The Hover Popup
        if isTouching, let values = pixelValues {
          HStack(spacing: 8) {
            // Color Preview
            Circle()
              .fill(pixelColor)
              .frame(width: 50, height: 50)
              .overlay(Circle().stroke(.white, lineWidth: 3))
              .shadow(radius: 5)

            // Data readout
            VStack(alignment: .leading, spacing: 4) {
              Label("R: \(values.r)", systemImage: "circle.fill").foregroundStyle(.red)
              Label("G: \(values.g)", systemImage: "circle.fill").foregroundStyle(.green)
              Label("B: \(values.b)", systemImage: "circle.fill").foregroundStyle(.blue)
            }
            .font(.system(.caption, design: .monospaced))
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
          }
          .position(x: dragLocation.x, y: dragLocation.y - 80)  // Floating above finger
          .animation(.spring(duration: 0.1), value: dragLocation)
        }
      }
      .clipped()
    }
  }

  private func readPixel(at location: CGPoint, in viewSize: CGSize, for uiImage: UIImage) {
    // Calculate the scale factor (assuming scaledToFill behavior)
    let imageWidth = CGFloat(uiImage.cgImage?.width ?? 1)
    let imageHeight = CGFloat(uiImage.cgImage?.height ?? 1)

    let widthRatio = imageWidth / viewSize.width
    let heightRatio = imageHeight / viewSize.height
    let scale = max(widthRatio, heightRatio)  // max for .scaledToFill, min for .scaledToFit

    // Calculate offset to center the crop
    let scaledWidth = viewSize.width * scale
    let scaledHeight = viewSize.height * scale
    let offsetX = (scaledWidth - imageWidth) / 2
    let offsetY = (scaledHeight - imageHeight) / 2

    // Map touch location to image pixel
    let pixelX = (location.x * scale) - offsetX
    let pixelY = (location.y * scale) - offsetY

    let point = CGPoint(x: pixelX, y: pixelY)

    // Use the extension methods
    if let color = uiImage.pixelColor(at: point) {
      self.pixelColor = color
      self.pixelValues = uiImage.pixelValues(at: point)
    }
  }
}

#Preview {
  ComputerVision()
}
