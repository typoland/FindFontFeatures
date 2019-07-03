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
    
    let selector: OTFSelector
    var parent: TypeController
    var fonts: [NSFont] = []
    
    @objc var enabled: Bool {
        if Set(fonts).intersection(selectedFonts).isEmpty {
            return false
        }
        return true
    }
	
	@objc override var search: NSControl.StateValue {
		willSet {
			willChangeValue(for: \SelectorController.search)
			parent.willChangeValue(for: \TypeController.search)
		}
		didSet {
			didChangeValue(for: \SelectorController.search)
			parent.didChangeValue(for: \TypeController.search)
			NotificationCenter.default.post(name: NSNotification.Name.featuresSearchChanged, object: self)
		}
	}
	
    @objc var name: String {
        return selector.name
    }
	
	@objc override var selected: Bool {
		willSet {
			if newValue, parent.type.exclusive == 1  {
				for selectorController in parent.selectorControllers {
					selectorController.selected = false
				}
			}
		}
	}
	

    init (selector:OTFSelector, parent:TypeController) {
        self.selector = selector
        self.parent = parent
		super.init()
		self.selected = selector.defaultSelector == 1
    }
}

extension SelectorController {
	override var description: String {
		return "Selector Controller \"\(name)\""
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
