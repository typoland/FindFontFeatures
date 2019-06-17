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
            print ("->", selectorController.enabled)
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
