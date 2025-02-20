//
//  OnboardingScreenView.swift
//  FoodAppSwiftUI
//
//  Created by Ahmet Bostancıklıoğlu on 5.02.2025.
//

import SwiftUI

struct OnboardingScreenView: View {
    
    @State private var selection: Int = 0
    @Binding var showOnboarding: Bool
    
    var body: some View {
        TabView(selection: $selection) {
            OnboardView(imageName: "Onboard1",
                        title: "Fresh Food",
                        description: "Order your favourite food from the top restaurants.",
                        nextAction: goNext)
            .tag(0)
            
            OnboardView(imageName: "Onboard2",
                        title: "Our Chef",
                        description: "Our chefs are experienced professionals who take pride in preparing delicious.",
                        nextAction: goNext)
            .tag(1)
            
            OnboardView(imageName: "Onboard3",
                        title: "Delivery",
                        description: "Our delivery team works tirelessly to ensure that your food arrives hot, fresh and on time.",
                        showDoneButton: true,
                        nextAction: {
                showOnboarding = false })
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    func goNext() {
        withAnimation {
            selection += 1
        }
    }
}

