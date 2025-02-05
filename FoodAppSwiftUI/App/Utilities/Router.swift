import UIKit
import SwiftUI


/// final sınıf → Bu sınıftan türetme (inheritance) engellenmiştir.
/// Amacı: Uygulamanın farklı ekranlara yönlendirilmesini yönetmek.
final class Router {

    /// showMain(window:), uygulamanın ana ekranı (HomeView()) açmasını sağlar.
    public static func showMain(window: UIWindow? = nil) {
        Router.setRootView(view: HomeView(), window: window)
    }

    //MARK: private
    private static func setRootView<T: View>(view: T, window: UIWindow? = nil) {
        
        /// Eğer bir UIWindow nesnesi sağlanırsa, onun root view controller'ı olarak atanır.
        if window != nil {
            window?.rootViewController = UIHostingController(rootView: view) /// SwiftUI görünümünü (View) UIKit'in UIWindow'una yerleştirir.
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            return
        }else { /// Eğer nil olarak verilirse, uygulamanın ana penceresi (keyWindow) kullanılır.
            
            ///  Mevcut aktif pencereyi (keyWindow) bulmak için UIApplication üzerine bir extension ekler.
            UIApplication.shared.keyWindow?.rootViewController = UIHostingController(rootView: view)
            UIView.transition(with: UIApplication.shared.keyWindow!,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }

}

extension UIApplication {

    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }

}
