import SwiftUI

/// YummyView adlı bir görünüme (View) sahip olup, kullanıcının onboarding ekranını görüp görmediğine bağlı olarak iki farklı ekran arasında geçiş yapar.
struct YummyView: View {
    
    
    /// @Binding, showOnboarding değişkeninin başka bir görünümden (parent view) kontrol edilmesini ve değiştirilmesine izin verir.
    @Binding var showOnboarding: Bool
    
    
    var body: some View {
        Group {
            if showOnboarding {
                /// Kullanıcı onboarding ekranını gördükten sonra "Devam Et" gibi bir butona bastığında showOnboarding değişkenini false yapar.
                OnboardingScreenView(showOnboarding: $showOnboarding)
            } else {
                /// Eğer showOnboarding false ise -> HomeView gösterilir.
                HomeView()
            }
        }
    }
}
