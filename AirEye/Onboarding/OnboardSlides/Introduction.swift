//
//  Introduction.swift
//  AirEye
//
//  Created by Patato on 24/12/25.
//

import SwiftUI

struct Introduction: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Introduction")
                .labelStyle()
            
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to the walkthrough!")
                    .headingStyle()
                
                Text("In this short walkthrough, you’ll learn how machine learning works. And how it can be applied to create a model that estimates air quality just from images.")
                
                Text("At the end of the app, you can get to try the working demo of the air quality estimation model.")
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    Introduction()
}
