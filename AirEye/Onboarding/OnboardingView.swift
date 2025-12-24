//
//  OnboardingView.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var currentPage = 0
    
    private let slides = [
        AnyView(Welcome()),
        AnyView(Introduction()),
        AnyView(ComputerVision()),
        AnyView(FindingPatterns()),
        AnyView(MachineLearning()),
        AnyView(Recap())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            TabView(selection: $currentPage) {
                ForEach(0..<slides.count, id: \.self) { index in
                    slides[index]
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .fullFrameStyle()
            
            Spacer()
            
            VStack {
                PrimaryButton(title: currentPage < slides.count - 1 ? "Next" : "Start Demo") {
                    if currentPage < slides.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                }
                
                if currentPage == 0  {
                    PrimaryButton(title: "go straight into the demo") {
                        hasCompletedOnboarding = true
                    }
                }
            }.padding()
            
        }
        .fullFrameStyle()
        
    }
}

#Preview {
    OnboardingView()
}
