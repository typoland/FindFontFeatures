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
var selectedSearchFeaturesChanged = "selectedSearchFeaturesChanged"
var selectedFeatureSelectorChanged = "selectedSearchFeaturesChanged"

extension Notification.Name {
	static var featuresSearchChanged = Notification.Name.init(selectedSearchFeaturesChanged)
	static var featureSelectorChanged = Notification.Name.init(selectedFeatureSelectorChanged)
}

class TypeController: BaseFeatureController {
	
    let type: OTFType<OTFSelector>
	
	var _selectorControllers: OrderedSet<SelectorController> = [] {
		willSet { willChangeValue(for: \TypeController.selectorControllers)  }
		didSet { didChangeValue(for: \TypeController.selectorControllers)  }
	}
	
	@objc var selectorControllers: [SelectorController] {
		get {
			return Array(_selectorControllers)
		}
		set {
			_selectorControllers = OrderedSet(newValue)
		}
	}
    @objc var name: String {
        return type.name
    }
	
	func switchOffExlusiveSelectors() {
		if type.exclusive == 1 {
			_selectorControllers.forEach({$0.selected = false})
		}
	}
	
	@objc override var fontSearch: NSControl.StateValue {

		get {
			let state: NSControl.StateValue
			
			let selectedNr = selectorControllers.filter({$0.fontSearch == .on}).count
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
			willChangeValue(for: \TypeController.fontSearch)
			for selectorController in selectorControllers {
				selectorController.fontSearch = newValue == .on ? .on : .off
			}
			didChangeValue(for: \TypeController.fontSearch)
		}
	}
	
    init (type: OTFType<OTFSelector>) {
        self.type = type
        super.init()
        for selector in type.selectors {
            selectorControllers.append(SelectorController(
				selector: OTFType<OTFSelector>.Selector.init(
					name: selector.name,
					nameID: selector.nameID,
					identifier: selector.identifier,
					defaultSelector: selector.defaultSelector),
				parent: self))
        }
    }
}

extension TypeController {
    @objc var enabled: Bool {
        var result:Bool = false
        for selectorController in selectorControllers {
            result = result || selectorController.enabled
        }
        return result
    }
}

extension TypeController {
    func selectorControllerFor(_ selector: OTFSelector) -> SelectorController {
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
