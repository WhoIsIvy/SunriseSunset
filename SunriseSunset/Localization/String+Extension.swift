//
//  String+Extension.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import UIKit

extension String {
    init(localizationKey: LocalizableKey) {
        self.init(localized: localizationKey.rawValue)
    }
}
