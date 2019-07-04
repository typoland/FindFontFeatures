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

var selectedFonts :[NSFont] = []

public class MainController: NSObject {
    
    enum ViewMode: String, CaseIterable {
		case selectionByFont = "Selected Font Features"
        case allFonts = "All Fonts & Features"
        case selectionByFeature = "Fonts with Selected Features"
    }
    
    @IBOutlet weak var viewModePopUp: NSPopUpButton!
    @IBOutlet var fontsArrayController: FontsArrayController!
	@IBOutlet var featuresTreeController: FeaturesTreeController!

	var _typeControllers: Set<TypeController> = []
	
	var _viewMode: ViewMode = .selectionByFont {
		willSet {
			willChangeValue(for: \MainController.fonts)
			willChangeValue(for: \MainController.typeControllers)
			willChangeValue(for: \MainController.viewMode)
		}
		didSet {
			didChangeValue(for: \MainController.fonts)
			didChangeValue(for: \MainController.typeControllers)
			didChangeValue(for: \MainController.viewMode)
	
			print ("view Mode Changed, fonts and typeControllers")
		}
	}
	@objc var viewMode:String{
		get {
			return _viewMode.rawValue
		}
		set {
			_viewMode = ViewMode.init(rawValue: newValue) ?? .allFonts
		}
	}
    @objc var typeControllers: [TypeController] {
        let filtered: Set<TypeController>
        switch _viewMode {
        case .selectionByFont:
            filtered = _typeControllers.filter {
                !$0.selectorControllers.filter ({ !Set($0.fonts).intersection(selectedFonts).isEmpty }).isEmpty }
		default:
            filtered = _typeControllers
        }
        return (Array(filtered)).sorted(by: {$0.type.name < $1.type.name})
    }
	
	/*
    @objc var selectors: [SelectorController] {
		let filtered: [SelectorController]
		switch _viewMode {
		case .selectionByFont:
			filtered = typeControllers.flatMap { $0.selectorControllers.filter({
				!Set($0.fonts).intersection(fonts).isEmpty
			}) }
		default:
			filtered = typeControllers.flatMap { $0.selectorControllers }
		}
        return filtered
    }
*/
    var _fonts: Set<NSFont> = [] {
        willSet { willChangeValue(for: \MainController.fonts) }
        didSet { didChangeValue(for: \MainController.fonts) }
    }
    
    @objc var fonts: [NSFont] {
		return Array(_fonts)
    }
	
	
    @objc var viewModePopupStrings: [String] {
        var result: [String] = []
        for mode in ViewMode.allCases {
            result.append(mode.rawValue)
        }
        print (result)
        return result
    }
	

    func clearContent() {
        _typeControllers = []
        _fonts = []
    }
    //convert font names to fonts
    func add (fontNames: [String], size:CGFloat) {
        var fonts = [NSFont]()
        for fontName in fontNames {
            if let font = NSFont(name: fontName, size: size) {
                fonts.append(font)
            }
        }
        add (fonts: fonts)
    }
	
    //add fonts add their type controllers
    func add (fonts: [NSFont]) {
        willChangeValue(for: \MainController.typeControllers)
        willChangeValue(for: \MainController.fonts)
		// for each font find type controllers
        for font in fonts {
            addTypeControllers(of: font)
        }
        self._fonts.formUnion(fonts)
        didChangeValue(for: \MainController.fonts)
        didChangeValue(for: \MainController.typeControllers)
		//IT IS OK print ("added \(_fonts.count) fonts and \(_typeControllers.count) typeControllers")
    }

    func addTypeControllers (of font: NSFont) {
		let types:[OTFType<OTFSelector>] = font.featuresDescriptions()
        for type in types {
			//get new or already defined controller
            let typeController = controllerFor(type: type, from: font)
			
			// looks as an error
            for selectorController in typeController.selectorControllers {
                selectorController.fonts.append(font)
            }
        }
    }
    
    func controllerFor(type: OTFType<OTFSelector>, from font: NSFont) -> TypeController {
		//check if type controller already exist
		let typeController:TypeController
		
        if let definedController = _typeControllers.filter ({ $0.type.name == type.name }).first {
			typeController = definedController
			// add font to previuosly defined selectors
			for selector in type.selectors {
				typeController.controllerFor(selector: selector).fonts.append(font)
			}
		// if not — create and add
        } else {
            typeController = TypeController(type: type)
            _typeControllers.insert(typeController)
        }
		
		return typeController
    }
    
    @IBAction func setCurrentViewMode (_ sender: NSPopUpButton) {
		if let modeString =  (sender.selectedItem)?.title {
       		viewMode = modeString
			print (viewMode)
		}
    }
}
