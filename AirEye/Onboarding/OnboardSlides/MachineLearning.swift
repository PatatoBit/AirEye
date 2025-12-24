//
//  MachineLearning.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct MachineLearning: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("From Examples to Expertise")
                .labelStyle()
            
            
            Text("How Do Models Learn")
                .headingStyle()
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text("Before your AI could predict air quality, it studied thousands of images")
            
            Text("12,902 images from India, Nepal, and beyond")
            
            Text("Each image came with a label: the actual AQI number.")
            
            Spacer()
        }
        .fullFrameStyle()
        .padding()
    }
}

#Preview {
    MachineLearning()
}
