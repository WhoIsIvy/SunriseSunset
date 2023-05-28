//
//  UIFont+Extension.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import UIKit

extension UIFont {
    static func copperPlateBold(size: CGFloat) -> UIFont {
        UIFont(name: Constants.copperPlateBold, size: size) ??
            .systemFont(ofSize: size, weight: .bold)
    }
}
