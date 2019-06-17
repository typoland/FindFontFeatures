//
//  SelectorController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 17/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

class SelectorController: NSObject {
    
    let selector: FFFSelector
    var parent: TypeController
    var fonts: [NSFont] = []
    var selected: Bool = false
    
    init (selector:FFFSelector, parent:TypeController) {
        self.selector = selector
        self.parent = parent
    }
}
