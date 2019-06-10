//
//  FFFFeaturesController + fonts.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTF

extension FFFeaturesController {
    
    public override func willChangeValue(forKey key: String) {
        switch key {
        case "allFonts" :
            print ("will changed allFonts \(allFonts)")
            
        fontsArrayController.willChangeValue(for:
            \FontsArrayController.arrangedObjects)
        
            fontsArrayController.willChangeValue(for:
                \FontsArrayController.selectedFalmiliesFonts)
            
            fontsArrayController.willChangeValue(for:
                \FontsArrayController.fontFamilyNames)

        default: break
        }
        super.willChangeValue(forKey: key)
    }
    
    public override func didChangeValue(forKey key: String) {
        switch key{
        case "allFonts" :
            print ("did changed allFonts \(allFonts)")
            
            fontsArrayController.didChangeValue(for:
                \FontsArrayController.arrangedObjects)
 
            fontsArrayController.didChangeValue(for:
                \FontsArrayController.selectedFalmiliesFonts)
            
            fontsArrayController.didChangeValue(for:
                \FontsArrayController.fontFamilyNames)
            
        default: break
        }
        super.didChangeValue(forKey: key)
    }
    
    @objc var allFonts:[NSFont] {
        return fonts
    }
}
