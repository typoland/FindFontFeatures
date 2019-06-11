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
    
    var types: OrderedSet<FFFType> = []
    var selectorInFonts: [FFFSelector : [ NSFont ]] = [:]
    var fonts: [NSFont] = [] {
        willSet {
            willChangeValue(for: \FFFeaturesController.allFonts)
        }
        didSet {
            didChangeValue(for: \FFFeaturesController.allFonts)
        }
    }
    
    @IBOutlet var fontsArrayController: FontsArrayController!
    @IBOutlet var featuresTreeController:FeaturesTreeController!
    //@IBOutlet var familyNamesArrayController:NSArrayController!
    //@IBOutlet var featuresController:FeaturesTreeController!
    
    func clearContent() {

        types = []
        selectorInFonts = [:]
        fonts = []
  
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
        willChangeValue(for: \FFFeaturesController.allFonts)
        self.fonts.append(contentsOf: fonts)
        didChangeValue(for: \FFFeaturesController.allFonts)
    }

    func addTypeControllers (of font: NSFont) {
        
        

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
            
            types.append(featureType)
            
            for selector in featureType.selectors {
                if selectorInFonts[selector] == nil {
                    selectorInFonts[selector] = [font]
                } else {
                    selectorInFonts[selector]?.append(font)
                }
            }
        }
    }
}
