import Foundation

extension RandomAccessCollection {
    subscript(safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        }

        return .none
    }
}
