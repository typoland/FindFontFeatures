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

class TypeController: NSObject {
    let type: FFFType
    
    @objc var selectorControllers: [SelectorController] = []
    
    init (type:FFFType) {
        self.type = type
        super.init()
        for selector in type.selectors {
            selectorControllers.append(SelectorController(selector: FFFType.Selector.init(name: selector.name, nameID: selector.nameID, identifier: selector.identifier, defaultSelector: selector.defaultSelector), parent: self))
        }
    }
}
