//
//  FFFFeaturesController + fonts.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTF

extension FFFeaturesController {
    
    @objc var allFonts:[NSFont] {
        return fonts
    }
}
