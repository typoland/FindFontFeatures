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

extension FFFeaturesController {
    
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
            featuresTreeController.willChangeValue(for:
                \FeaturesTreeController.arrangedObjects)
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
            featuresTreeController.didChangeValue(for:
                \FeaturesTreeController.arrangedObjects)
            print ("did changed types \(String(describing: featuresTreeController.content)) ")
        default: break
        }
        super.didChangeValue(forKey: key)
    }
    
    
}
