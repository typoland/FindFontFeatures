//
//  OTFFeaturesController.swift
//  OTFKit
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTF
import OTFKit

public class FFFeaturesController: NSObject {
    
    var _types: OrderedSet<FFFType> = []
    @objc var types:[FFFType] {
        return Array(_types)
    }

    var _selectorInFonts: [FFFSelector : [ NSFont ]] = [:]
    @objc var selectorInFonts:[FFFSelector : [ NSFont ]] {
        return _selectorInFonts
    }

    var _fonts: [NSFont] = [] {
        willSet { willChangeValue(for: \FFFeaturesController.fonts) }
        didSet { didChangeValue(for: \FFFeaturesController.fonts) }
    }
    @objc var fonts:[NSFont] {
        return _fonts
    }

    
    @IBOutlet var fontsArrayController: FontsArrayController!
    @IBOutlet var featuresTreeController:FeaturesTreeController!

    
    func clearContent() {
        _types = []
        _selectorInFonts = [:]
        _fonts = []
    }
    
    func add (fontNames: [String], size:CGFloat) {
        var fonts = [NSFont]()
        for fontName in fontNames {
            if let font = NSFont(name: fontName, size: size) {
                fonts.append(font)
            }
        }
        add(fonts: fonts)
    }
    
    func add (fonts: [NSFont]) {
        for font in fonts {
            addTypeControllers(of: font)
        }

        willChangeValue(for: \FFFeaturesController.fonts)
        self._fonts = self._fonts + fonts
        didChangeValue(for: \FFFeaturesController.fonts)
    }

    func addTypeControllers (of font: NSFont) {
        //willChangeValue(for: \FFFeaturesController.types)
        //willChangeValue(for: \FFFeaturesController.selectorInFonts)
        for featureTypeDescription in font.featuresDescriptions {
            let (name, nameID, identifier, exclusive, selectors) = featureTypeDescription
            let featureType = FFFType(
                name: name,
                nameID: nameID,
                identifier: identifier,
                exclusive: exclusive)
            
            featureType.selectors = OrderedSet(selectors.map {
                FFFSelector (parent: featureType,
                             name: $0.name,
                             nameID: $0.nameID,
                             identifier: $0.identifier,
                             defaultSelector: $0.defaultSelector)
                
            })
            
            _types.append(featureType)
            
            for selector in featureType.selectors {
                if _selectorInFonts[selector] == nil {
                    _selectorInFonts[selector] = [font]
                } else {
                    _selectorInFonts[selector]?.append(font)
                }
            }
        }
        //didChangeValue(for: \FFFeaturesController.types)
        //didChangeValue(for: \FFFeaturesController.selectorInFonts)
    }
}
