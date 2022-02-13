import XCTest

// MARK: - ElementResolver

protocol ElementResolver: Hashable {}

// MARK: - Private

extension ElementResolver {
    private static func parent(byId identifier: String,
                               elementType: XCUIElement.ElementType) -> XCUIElementQuery {
        app.descendants(matching: elementType)
            .matching(identifier: identifier)
    }
}

// MARK: - Public

extension ElementResolver {
    static func resolveBy(identifier: String,
                          elementType: XCUIElement.ElementType = .any) -> XCUIElement {
        parent(byId: identifier,
               elementType: elementType)
            .element
    }

    static func resolveBy(identifier: String,
                          elementType: XCUIElement.ElementType = .any) -> XCUIElementQuery {
        parent(byId: identifier,
               elementType: elementType)
    }

    static func resolveBy(identifier: String,
                          boundBy index: Int,
                          elementType: XCUIElement.ElementType = .any) -> XCUIElement {
        parent(byId: identifier,
               elementType: elementType)
            .element(boundBy: index)
    }
}
