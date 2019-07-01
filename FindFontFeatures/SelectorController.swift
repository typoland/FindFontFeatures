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

class SelectorController: BaseFeatureController {
    
    let selector: FFFSelector
    var parent: TypeController
    var fonts: [NSFont] = []
    
    @objc var enabled: Bool {
        if Set(fonts).intersection(selectedFonts).isEmpty {
            return false
        }
        return true
    }
    
    @objc var name: String {
        return selector.name
    }
    
    init (selector:FFFSelector, parent:TypeController) {
        self.selector = selector
        self.parent = parent
    }
}

extension SelectorController {
    @objc var toolTip : String {
        var text = fonts.reduce(into: "Found in Fonts:\n", {$0+="\t\($1.fontName)\n"})
        _ = text.removeLast()
        return text
    }
}

extension SelectorController {
	@objc var isLeaf: Bool {
		return true
	}
}
