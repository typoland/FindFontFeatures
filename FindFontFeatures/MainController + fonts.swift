//
//  FFFFeaturesController + fonts.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

extension MainController {
    
    public override func willChangeValue(forKey key: String) {
        switch key {
        case "fonts" :
            print ("will changed allFonts \(fonts)")
            
            fontsArrayController.willChangeValue(for:
                \FontsArrayController.arrangedObjects)
            
            fontsArrayController.willChangeValue(for:
                \FontsArrayController.selectedFalmiliesFonts)
            
            fontsArrayController.willChangeValue(for:
                \FontsArrayController.fontFamilyNames)
        case "types" :
            print ("will changed types \(types)")
            featuresOutlineViewDelegate.willChangeValue(for:
                \FeaturesOutlineViewDelegate.typeControllers)
        default: break
        }
        super.willChangeValue(forKey: key)
    }
    
    public override func didChangeValue(forKey key: String) {
        switch key{
        case "fonts" :
            print ("did changed allFonts \(fonts)")
            
            fontsArrayController.didChangeValue(for:
                \FontsArrayController.arrangedObjects)
            
            fontsArrayController.didChangeValue(for:
                \FontsArrayController.selectedFalmiliesFonts)
            
            fontsArrayController.didChangeValue(for:
                \FontsArrayController.fontFamilyNames)
        case "types" :
            featuresOutlineViewDelegate.didChangeValue(for:
                \FeaturesOutlineViewDelegate.typeControllers)
            print ("did changed types \(String(describing: featuresOutlineViewDelegate.typeControllers)) ")
        default: break
        }
        super.didChangeValue(forKey: key)
    }
    
    
}
