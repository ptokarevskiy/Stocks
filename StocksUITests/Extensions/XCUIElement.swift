import XCTest

extension XCUIElement {
    var isVisible: Bool {
        exists && isHittable
    }

    var text: String {
        guard let text = value as? String else {
            preconditionFailure("Value: \(String(describing: value)) is not a String")
        }
        return text
    }

    func clearTextField() {
        var charactersCount: Int { (value.flatMap(String.init(describing:)) ?? "").count }
        var placeholderCharactersCount: Int { (placeholderValue?.count) ?? 0 }

        guard let initialValue = value as? String,
              !initialValue.isEmpty,
              initialValue != placeholderValue else {
            return
        }

        typeText(.init(repeating: XCUIKeyboardKey.delete.rawValue,
                       count: charactersCount))
    }

    func clear(andType text: String) {
        tap()
        clearTextField()
        typeText(text)
    }
}
