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
        case selectionByFeature = "Fonts with Selected Features"
        case selectionByFont = "Selected Font Features"
    }
    
    @IBOutlet weak var typesOutlineView: NSOutlineView!
    @IBOutlet weak var viewModePopUp: NSPopUpButton!
    @IBOutlet var fontsArrayController: FontsArrayController!
    @IBOutlet var featuresOutlineViewDelegate: FeaturesOutlineViewDelegate!
    
	var _typeControllers: [TypeController] = []
	var viewMode: ViewMode = .allFonts {
		didSet {
			didChangeValue(for: \MainController.fonts)
			didChangeValue(for: \MainController.typeControllers)
			didChangeValue(for: \MainController.showFontEnabled)
		}
	}

	@objc var showFontEnabled: Bool {
		print ("taking showFontEnabled")
		return viewMode == .selectionByFont
	}

    @objc var typeControllers: [TypeController] {
        let filtered: [TypeController]
        switch viewMode {
        case .selectionByFont:
            filtered = _typeControllers.filter {
                !$0.selectorControllers.filter ({ !Set($0.fonts).intersection(selectedFonts).isEmpty }).isEmpty }
		default:
            filtered = _typeControllers
        }
        return (Array(NSOrderedSet(array: filtered)) as! [TypeController]).sorted(by: {$0.type.name < $1.type.name})
    }
    
    @objc var selectors: [SelectorController] {
		let filtered: [SelectorController]
		switch viewMode {
		case .selectionByFont:
			filtered = typeControllers.flatMap { $0.selectorControllers.filter({
				!Set($0.fonts).intersection(fonts).isEmpty
			}) }
		default:
			filtered = typeControllers.flatMap { $0.selectorControllers }
		}
        return filtered
    }

    var _fonts: [NSFont] = [] {
        willSet { willChangeValue(for: \MainController.fonts) }
        didSet { didChangeValue(for: \MainController.fonts) }
    }
    
    @objc var fonts:[NSFont] {
		let filtered:[NSFont]
		switch viewMode {
		case .selectionByFeature:
			filtered = typeControllers.flatMap({
				$0.selectorControllers.reduce(into: [NSFont](), {
					$0+=$1.fonts
				})
			})
		default:
			filtered = _fonts
		}
        return filtered
    }
	
	public override func awakeFromNib() {
		featuresOutlineViewDelegate.bind(NSBindingName(rawValue: "typeControllers"), to: self, withKeyPath: "typeControllers", options: nil)
		//selectedFontsFeatures.bind(NSBindingName(rawValue: "state"), to: self, withKeyPath: "buttonState", options: nil)
	}
	
    @objc var viewModePopupStrings: [String] {
        var result: [String] = []
        for mode in ViewMode.allCases {
            result.append(mode.rawValue)
        }
        print (result)
        return result
    }
	
    @objc func action(_ sender:Any) {
        print ("there is an action")
    }
    
//    @objc var buttonState: NSControl.StateValue = .off {
//        didSet {print ("changed")}
//    }
//
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
            let typeController = TypeController(type: type)
            _typeControllers.append(typeController)
            return typeController
        }
    }
    
    @IBAction func setCurrentViewMode (_ sender: NSPopUpButton) {
		if let string =  (sender.selectedItem)?.title {
			willChangeValue(for: \MainController.showFontEnabled)
       		viewMode = ViewMode.init(rawValue: string) ?? .allFonts
			didChangeValue(for: \MainController.showFontEnabled)
			print (viewMode)
		}
    }
}
