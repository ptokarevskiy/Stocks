import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()

    private init() {}

    // MARK: - Public

    /// Slightly vibrate for section
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()

        generator.prepare()
        generator.selectionChanged()
    }

    /// Play haptic feedback for given type interaction
    /// - Parameter type: Type of feedback
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()

        generator.prepare()
        generator.notificationOccurred(type)
    }
}
