//
//  OnboardView.swift
//  FoodAppSwiftUI
//
//  Created by Ahmet Bostancıklıoğlu on 5.02.2025.
//

import SwiftUI

struct OnboardView: View {
    
    let imageName: String
    let title: String
    let description: String
    var showDoneButton = false
    var nextAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
            
            Text(title)
                .font(.title)
                .bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            if showDoneButton {
                Button("Get Started") {
                    nextAction()
                }
                .buttonStyle(OnboardButtonStyle())
            }
        }
        .padding(40)
    }
}


struct OnboardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .frame(maxWidth: .infinity)
            .font(.title3)
            .background(.pink, in:  RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.white)
    }
}




