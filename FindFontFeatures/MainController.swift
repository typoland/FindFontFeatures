//
//  OTFFeaturesController.swift
//  OTFKit
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

public class MainController: NSObject {
    
    @IBOutlet weak var typesOutlineView: NSOutlineView!
    var _typeControllers: [TypeController] = []
    @objc var types:[TypeController] {
        return Array(_typeControllers)
    }
    
    @objc var selectors:[SelectorController] {
        return types.flatMap {$0.selectorControllers}
    }

    var _fonts: [NSFont] = [] {
        willSet { willChangeValue(for: \MainController.fonts) }
        didSet { didChangeValue(for: \MainController.fonts) }
    }
    
    @objc var fonts:[NSFont] {
        return _fonts
    }

    
    @IBOutlet var fontsArrayController: FontsArrayController!
    @IBOutlet var featuresOutlineViewDelegate:FeaturesOutlineViewDelegate!

    
    func clearContent() {
        _typeControllers = []
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
        willChangeValue(for: \MainController.types)
        willChangeValue(for: \MainController.fonts)
        for font in fonts {
            addTypeControllers(of: font)
        }
        self._fonts = self._fonts + fonts
        didChangeValue(for: \MainController.fonts)
        didChangeValue(for: \MainController.types)
    }

    func addTypeControllers (of font: NSFont) {
        let types: [FFFType] = font.featuresDescriptions()
        for type in types {
            let typeController = TypeController(type: type)
            _typeControllers.append(typeController)
            for selectorController in typeController.selectorControllers {
                selectorController.fonts.append(font)
            }
        }
    }
}
