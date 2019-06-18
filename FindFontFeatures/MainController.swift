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
    
    enum ViewMode: String, CaseIterable {
        case allFonts = "All Fonts & Features"
        case selectedFeature = "Fonts with Selected Feature"
        case selectedFont = "Selected Font Features"
    }
    
    @IBOutlet weak var typesOutlineView: NSOutlineView!
    @IBOutlet weak var viewModePopUp: NSPopUpButton!
    @IBOutlet var fontsArrayController: FontsArrayController!
    @IBOutlet var featuresOutlineViewDelegate:FeaturesOutlineViewDelegate!
    
    var _typeControllers: [TypeController] = []
    var viewMode: ViewMode = .allFonts
    
    @objc var typeControllers:[TypeController] {
        let filtered: [TypeController]
        switch viewMode {
        case .selectedFeature:
            filtered = _typeControllers.filter {
                !$0.selectorControllers.filter ({ !Set($0.fonts).intersection(selectedFonts).isEmpty }).isEmpty }
        case .selectedFont:
            filtered = _typeControllers
        case .allFonts:
            filtered = _typeControllers
        }

        return (Array(NSOrderedSet(array: filtered)) as! [TypeController]).sorted(by: {$0.type.name < $1.type.name})
    }
    
    @objc var selectors:[SelectorController] {
        return typeControllers.flatMap {$0.selectorControllers}
    }

    var _fonts: [NSFont] = [] {
        willSet { willChangeValue(for: \MainController.fonts) }
        didSet { didChangeValue(for: \MainController.fonts) }
    }
    
    @objc var fonts:[NSFont] {
        return _fonts
    }
    
    @objc var viewModePopupStrings: [String] {
        var result: [String] = []
        for mode in ViewMode.allCases {
            result.append(mode.rawValue)
        }
        print (result)
        return result
    }
    
    
    

    
    public override func awakeFromNib() {
        featuresOutlineViewDelegate.bind(NSBindingName(rawValue: "typeControllers"), to: self, withKeyPath: "typeControllers", options: nil)
        //selectedFontsFeatures.bind(NSBindingName(rawValue: "state"), to: self, withKeyPath: "buttonState", options: nil)
    }
    
    
    @objc func action(_ sender:Any) {
        print ("there is an action")
    }
    
    @objc var buttonState: NSControl.StateValue = .off {
        didSet {print ("changed")}
    }
    
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
        willChangeValue(for: \MainController.typeControllers)
        willChangeValue(for: \MainController.fonts)
        for font in fonts {
            addTypeControllers(of: font)
        }
        self._fonts = self._fonts + fonts
        didChangeValue(for: \MainController.fonts)
        didChangeValue(for: \MainController.typeControllers)
    }

    func addTypeControllers (of font: NSFont) {
        let types: [FFFType] = font.featuresDescriptions()
        for type in types {
            let typeController = controllerFor(type: type, from: font)
            for selectorController in typeController.selectorControllers {
                selectorController.fonts.append(font)
            }
        }
    }
    
    func controllerFor(type: FFFType, from font: NSFont) -> TypeController {
        if let typeController = typeControllers.filter ({ $0.type.name == type.name }).first {
            for selector in type.selectors {
                typeController.controllerFor(selector: selector).fonts.append(font)
            }
            return typeController
        } else {
            let typeCcontroller = TypeController(type: type)
            _typeControllers.append(typeCcontroller)
            return typeCcontroller
        }
    }
    
    @IBAction func setCurrentViewMode (_ sender: NSPopUpButton) {
        print ("received \(sender.selectedItem)")
       // viewMode = ViewMode.init(rawValue: sender.selectedItem as? String) ?? .allFonts
    }
    
    func changeFeaturesTable () {
        print("changing Feature Table")
        willChangeValue(for: \MainController.typeControllers)
        didChangeValue(for: \MainController.typeControllers)
        
        
    }

}
