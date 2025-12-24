//
//  FilterLens.swift
//  AirEye
//
//  Created by Patato on 24/12/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterLens: View {
    let imageName: String
    
    // State to track the lens position
    @State private var lensPosition: CGPoint = CGPoint(x: 150, y: 150)
    @State private var isDragging: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Base Layer: Original Image
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 300)
                    .clipped()
                    .grayscale(0.3) // Dim the original slightly to make the filter pop
                
                // 2. Hidden Layer: The "Pattern" (Filtered Image)
                // We reveal this using the mask below
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 300)
                    .clipped()
                    // Apply a high-contrast "Edge" look to simulate AI vision
                    .contrast(2.0)
                    .saturation(0.0)
                    .colorInvert() // Inverted edges often look like "X-Ray" vision
                    .mask(
                        // The Lens Mask
                        Circle()
                            .frame(width: 120, height: 120)
                            .position(lensPosition)
                            .blur(radius: 5) // Soft edges for the lens
                    )
                
                // 3. The Visual Lens Ring (UI Decoration)
                Circle()
                    .strokeBorder(Color.cyan, lineWidth: 3)
                    .background(Circle().fill(Color.cyan.opacity(0.1)))
                    .frame(width: 120, height: 120)
                    .position(lensPosition)
                    .shadow(color: .cyan.opacity(0.5), radius: 10, x: 0, y: 0)
                    .overlay(
                        Image(systemName: "sparkles")
                            .foregroundColor(.white)
                            .offset(x: 40, y: -40)
                            .position(lensPosition)
                    )
            }
            // 4. Interaction: Drag Gesture
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.isDragging = true
                        // Limit dragging within bounds
                        let limitX = min(max(value.location.x, 0), geometry.size.width)
                        let limitY = min(max(value.location.y, 0), 300)
                        
                        withAnimation(.interactiveSpring()) {
                            self.lensPosition = CGPoint(x: limitX, y: limitY)
                        }
                    }
            )
            .frame(height: 300)
            .cornerRadius(16)
            .overlay(
                // Optional: Helper text if not dragging
                Text("Drag the lens to find patterns")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(.black.opacity(0.6))
                    .cornerRadius(8)
                    .opacity(isDragging ? 0 : 1)
                    .padding()
                , alignment: .bottom
            )
        }
        .frame(height: 300) // Fixed height for the component
    }
}
