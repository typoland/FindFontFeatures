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
    }
    
    init (for name:String, nameID: Int, identifier: Int, exclusive: Int, selectors: [(name: String, nameID: Int, identifier: Int, defaultSelector: Int)] = []) {
        
        self.type = FFFType(name: name,
                            nameID: nameID,
                            identifier: identifier,
                            exclusive: exclusive,
                            selectors: selectors.map {
                                FFFSelector(name: $0.name,
                                            nameID: $0.nameID,
                                            identifier: $0.identifier,
                                            defaultSelector: $0.defaultSelector)
                            }
        )
        super.init()
        self.selectorControllers = type.selectors.map {SelectorController(selector: $0, parent: self)}
    }
}
