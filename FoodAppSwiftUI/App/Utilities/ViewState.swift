import Foundation

enum ViewState {
    case loading
    case error(message: String)
    case dataLoaded
}
