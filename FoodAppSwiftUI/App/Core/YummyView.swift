import SwiftUI

struct YummyView: View {
    
    @Binding var showOnboarding: Bool
    
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingScreenView(showOnboarding: $showOnboarding)
            } else {
                HomeView()
            }
        }
    }
}
