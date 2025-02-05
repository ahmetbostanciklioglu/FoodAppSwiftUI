import SwiftUI

//MARK: - SwiftUI'nin uygulamanın ana giriş noktasını belirlediği işaretleyicidir.
@main
struct YummyApp: App {
    
    /// Uygulama içi ayarları kaydetmek için (@AppStorage).
    /// SwiftUI'nin UserDefaults ile veri saklamasını sağlıyor.
    /// "showOnboarding" adlı bir anahtar (key) ile bir Bool değeri saklanır.
    // MARK: Kullanıcı uygulamayı ilk kez açtığında onboarding ekranını göstermeye karar vermek için kullanılır.
    /// Eğer kullanıcı onboarding ekranını kapatırsa, "showOnboarding" değeri false olur ve tekrar gösterilmez.
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
     
    
    /// 'body: some Scene'  --> SwiftUI'nin uygulama yaşam döngüsünü tanımlar.
    var body: some Scene {
        
        /// 'WindowGroup'  Çoklu pencere desteği sağlar (iPhone, iPad, macOS uygulamalarında kullanılır).
        WindowGroup {
            // Uygulama açıldığında 'YummyView' ana ekran olarak başlatılıyor.
            YummyView(showOnboarding: $showOnboarding)
        }
    }
}

