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
    var fonts: [FontController] = []
	
	init (selector:OTFSelector, parent:TypeController) {
		self.selector = selector
		self.parent = parent
		super.init()
		self.selected = selector.defaultSelector == 1
	}
	
	@objc override var fontSearch: NSControl.StateValue {
		willSet {
			willChangeValue(for: \SelectorController.fontSearch)
			parent.willChangeValue(for: \TypeController.fontSearch)
		}
		didSet {
			didChangeValue(for: \SelectorController.fontSearch)
			parent.didChangeValue(for: \TypeController.fontSearch)
		}
	}
	
	@objc override var selected: Bool {
		willSet {
			willChangeValue(for: \SelectorController.selected)
			if newValue {
				parent.switchOffExlusiveSelectors()
			}
		}
		didSet {
			didChangeValue(for: \SelectorController.selected)
		}
	}
	

}

extension SelectorController {
	
    @objc var enabled: Bool {
		if Set(fonts.map{$0}).intersection(selectCoreedFontControllers).isEmpty {
            return false
        }
        return true
    }	
}

extension SelectorController {
    @objc var name: String {
        return selector.name
    }
}

extension SelectorController {
	override var description: String {
		return "Selector Controller \"\(name)\" is \(selected ? "ON":"OFF")"
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
