import Foundation

class AppUtils {
    static var version: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
}
