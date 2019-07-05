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
			//print ("setting \(fontSearch)")
			
		}
	}
	
	@objc override var selected: Bool {
		willSet {
			//print ("selected \(self) will set to \(newValue)")
			if newValue, parent.type.exclusive == 1  {
				for selectorController in parent.selectorControllers {
					selectorController.selected = false
				}
			}
		}
		didSet {
			//why it stops???
			NotificationCenter.default.post(name: Notification.Name.featureSelectorChanged, object: self)
		}
	}
}

extension SelectorController {
	
    @objc var enabled: Bool {
        if Set(fonts).intersection(selectedFonts).isEmpty {
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
