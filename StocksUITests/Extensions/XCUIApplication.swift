import XCTest

extension XCUIApplication {
    enum AppBundle {
        case mainApp
        case bundle(Identifier)

        var identifier: Identifier {
            switch self {
            case .mainApp:
                return Identifier.main

            case let .bundle(identifier):
                return identifier
            }
        }
    }
}

extension XCUIApplication.AppBundle {
    enum Identifier: String, CaseIterable {
        case main = "ptokarevskiy.Stocks"
        case springboard = "com.apple.springboard"
        case settings = "com.apple.Preferences"
        case safari = "com.apple.mobilesafari"
    }
}

extension XCUIApplication {
    convenience init(with bundle: AppBundle) {
        self.init(bundleIdentifier: bundle.identifier.rawValue)
    }
}
