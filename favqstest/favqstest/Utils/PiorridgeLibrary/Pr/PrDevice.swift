//
//  PrDevice.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 08/02/2021.
//

import Foundation
import UIKit

public extension Pr {
    class device {
        public enum Screen {
            case iPhone
            case iPhonePlus
            case iPhoneNotch
        }
        
        public static func getDeviceScreen() -> Screen {
            let screen = UIScreen.main.nativeBounds

            if screen.height <= 1334 {
                return .iPhone
            } else if screen.height <= 2208 {
                return .iPhonePlus
            } else {
                return .iPhoneNotch
            }
        }
        
        public static func getScreenSize() -> CGSize {
            let screenSize = UIScreen.main.bounds
            return CGSize.init(width: screenSize.width, height: screenSize.height)
        }
    }
}
