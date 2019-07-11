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
    
    let selector: OTFS
    var parent: TypeController
    var fonts: [FontController] = []
	
	init (selector:OTFS, parent:TypeController) {
		self.selector = selector
		self.parent = parent
		super.init()
		self.selected = selector.defaultSelector == 1
	}
	
	@objc override var fontSearch: NSControl.StateValue {
		willSet {
			willChangeValue(for: \.fontSearch)
			parent.willChangeValue(for: \.fontSearch)
		}
		didSet {
			didChangeValue(for: \.fontSearch)
			parent.didChangeValue(for: \.fontSearch)
		}
	}
	
	@objc override var selected: Bool {
		willSet {
			willChangeValue(for: \.selected)
			if newValue {
				parent.switchOffExlusiveSelectors()
			}
		}
		didSet {
			didChangeValue(for: \.selected)
		}
	}

}

extension SelectorController {
	@objc var enabled: Bool {
		if Set(fonts.map{$0}).intersection(selectedFontControllers).isEmpty {
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
