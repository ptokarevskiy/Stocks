#if canImport(SwiftUI)
    import SwiftUI

    extension View {
        func previewDevice(_ device: PreviewDevice.AvailableDevices) -> some View {
            previewDevice(PreviewDevice(stringLiteral: device.rawValue))
        }

        func previewDisplayName(_ device: PreviewDevice.AvailableDevices) -> some View {
            previewDisplayName(device.rawValue)
        }

        func previewDeviceWithName(_ device: PreviewDevice.AvailableDevices) -> some View {
            previewDevice(device)
                .previewDisplayName(device)
        }
    }

    extension PreviewDevice {
        /// An enum of all implemented device types.
        ///
        /// * The raw string value must exactly match the input expected by SwiftUI's `.previewDevice()` modifier.
        /// * Show list of available simulators:
        /// `xcrun simctl list devicetypes` /  `xcrun simctl list devicetypes -j`
        enum AvailableDevices: String, CaseIterable {
            // MARK: - Mac

            case mac = "Mac"
            case macCatalyst = "Mac Catalyst"

            // MARK: - iPhone

            /// iPhone SE (1st generation)
            case iPhoneSE1 = "iPhone SE (1st generation)"
            /// iPhone 7
            case iPhone7 = "iPhone 7"
            /// iPhone 7 Plus
            case iPhone7Plus = "iPhone 7 Plus"
            /// iPhone 8
            case iPhone8 = "iPhone 8"
            /// iPhone 8 Plus
            case iPhone8Plus = "iPhone 8 Plus"
            /// iPhone X
            case iPhoneX = "iPhone X"
            /// iPhone XS
            case iPhoneXS = "iPhone Xs"
            /// iPhone XS Max
            case iPhoneXSMax = "iPhone Xs Max"
            /// iPhone XR
            case iPhoneXR = "iPhone Xʀ"
            /// iPhone 11
            case iPhone11 = "iPhone 11"
            /// iPhone 11 Pro
            case iPhone11Pro = "iPhone 11 Pro"
            /// iPhone 11 Pro Max
            case iPhone11ProMax = "iPhone 11 Pro Max"
            /// iPhone SE (2nd generation)
            case iPhoneSE2 = "iPhone SE (2nd generation)"
            /// iPhone 12 mini
            case iPhone12Mini = "iPhone 12 mini"
            /// iPhone 12
            case iPhone12 = "iPhone 12"
            /// iPhone 12 Pro
            case iPhone12Pro = "iPhone 12 Pro"
            /// iPhone 12 Pro Max
            case iPhone12ProMax = "iPhone 12 Pro Max"
            /// iPhone 13 Pro
            case iPhone13Pro = "iPhone 13 Pro"
            /// iPhone 13 Pro Max
            case iPhone13ProMax = "iPhone 13 Pro Max"
            /// iPhone 13 mini
            case iPhone13Mini = "iPhone 13 mini"
            /// iPhone 13
            case iPhone13 = "iPhone 13"
        }
    }
#endif
