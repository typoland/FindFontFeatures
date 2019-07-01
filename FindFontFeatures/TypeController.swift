//
//  TypeController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 17/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

class TypeController: BaseFeatureController {
	
    let type: FFFType
	

    @objc var selectorControllers: [SelectorController] = []
    @objc var name: String {
        return type.name
    }

	@objc override var search: NSControl.StateValue {

		get {
			let state: NSControl.StateValue
			
			let selectedNr = selectorControllers.filter({$0.search == .on}).count
			let count = selectorControllers.count
			
			if selectedNr == 0 {
				state = .off
			} else if selectedNr == count {
				state = .on
			} else {
				state = .mixed
			}
			return state
		}
		set {
			willChangeValue(for: \TypeController.search)
			for selectorController in selectorControllers {
				selectorController.search = newValue == .on ? .on : .off
			}
			didChangeValue(for: \TypeController.search)
		}
	}
	
    init (type:FFFType) {
        self.type = type
        super.init()
        for selector in type.selectors {
            selectorControllers.append(SelectorController(selector: FFFType.Selector.init(name: selector.name, nameID: selector.nameID, identifier: selector.identifier, defaultSelector: selector.defaultSelector), parent: self))
        }
    }

    @objc var enabled: Bool {
        var result:Bool = false
        for selectorController in selectorControllers {
            result = result || selectorController.enabled
        }
        return result
    }
}

extension TypeController {
    func controllerFor(selector: FFFSelector) -> SelectorController {
        if let controller = selectorControllers.filter({$0.selector.name == selector.name}).first {
            return controller
        } else {
            let controller = SelectorController(selector: selector, parent: self)
            selectorControllers.append(controller)
            return controller
        }
    }
}

extension TypeController {
	override var description: String {
		return "Type Controller \"\(name)\""
	}
}

extension TypeController {
	@objc var isLeaf: Bool {
		return false
	}
	
	@objc var count: Int {
		return selectorControllers.count
	}
}

extension TypeController {
	func selectExclusive (selector: SelectorController) {
		for selectorController in selectorControllers {
			selectorController.willChangeValue(for: \SelectorController.selected)
			selectorController.selected = selector == selectorController
			selectorController.didChangeValue(for: \SelectorController.selected)
		}
	}
}
