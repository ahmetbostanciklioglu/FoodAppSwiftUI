import SwiftUI

@main
struct YummyApp: App {
    
    ///MARK: Onboarding ekranın gösterilme durumu bu bool türündeki showOnboarding değişkeninde tutuluyor.
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    
    
    var body: some Scene {
        WindowGroup {
            //YummyView uygulamanın Core View'ı
            YummyView(showOnboarding: $showOnboarding)
        }
    }
}

