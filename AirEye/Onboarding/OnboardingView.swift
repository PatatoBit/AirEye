//
//  OnboardingView.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome to AirEye")
                .font(.largeTitle)
                .bold()
                .fontDesign(.rounded)
            
            Spacer()
            
            Button("Complete onboarding") {
                    hasCompletedOnboarding = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
               
    }
}

#Preview {
    OnboardingView()
}
