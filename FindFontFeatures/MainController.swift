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

	
	
	var viewMode: ViewMode = .selectionByFont {
		willSet {
			willChangeValue(for: \MainController.fontControllers)
			willChangeValue(for: \MainController.typeControllers)
			
		}
		didSet {
			didChangeValue(for: \MainController.fontControllers)
			didChangeValue(for: \MainController.typeControllers)
	
		}
	}
	
	var _typeControllers: Set<TypeController> = [] {
		willSet { willChangeValue(for: \MainController.typeControllers) }
		didSet { didChangeValue(for: \MainController.typeControllers) }
	}
	
	
	var fontControllersSet: Set<FontController> = [] {
		willSet { willChangeValue(for: \MainController.fontControllers) }
		didSet { didChangeValue(for: \MainController.fontControllers) }
	}
}
	
extension MainController {
	@objc var viewModeStrings: [String] {
		return ViewMode.allCases.map {$0.rawValue}
	}
}

extension MainController {
    @objc var typeControllers: [TypeController] {
        let filtered: Set<TypeController>
        switch viewMode {
        case .selectionByFont:
            filtered = _typeControllers.filter {
                !$0.selectorControllers.filter ({ !Set($0.fonts).intersection(selectedFonts).isEmpty }).isEmpty }
		default:
            filtered = _typeControllers
        }
        return (Array(filtered)).sorted(by: {$0.type.name < $1.type.name})
    }
	
}

extension MainController {
    
    @objc var fontControllers: [FontController] {
		return Array(fontControllersSet)
    }
	
}


extension MainController {
    func clearContent() {
        _typeControllers = []
        fontControllersSet = []
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
        willChangeValue(for: \MainController.fontControllers)
		// for each font find type controllers
		let newFontControllers = fonts.map{FontController($0)}
		self.fontControllersSet.formUnion(newFontControllers)
		
        for fontController in newFontControllers {
            addTypeControllers(of: fontController)
        }
		
        didChangeValue(for: \MainController.fontControllers)
        didChangeValue(for: \MainController.typeControllers)
    }

    func addTypeControllers (of fontController: FontController) {
		let types = fontController.featuresDescriptions
        for type in types {
			//get new or already defined controller
            _ = controllerFor(type: type, from: fontController)
//            for selectorController in typeController.selectorControllers {
//                selectorController.fonts.append(fontController)
//            }
        }
    }
    
    func controllerFor(type: OTFType<OTFSelector>, from font: FontController) -> TypeController {
		//check if type controller already exist
		let typeController:TypeController
		
        if let definedController = _typeControllers.filter ({ $0.type.name == type.name }).first {
			typeController = definedController
			// add font to previuosly defined selectors
			for selector in type.selectors {
				typeController.selectorControllerFor(selector).fonts.append(font)
			}
		// if not — create and add
        } else {
            typeController = TypeController(type: type)
            _typeControllers.insert(typeController)
        }
		return typeController
	}
}

extension MainController {
    @IBAction func setCurrentViewMode (_ sender: NSPopUpButton) {
		if let string = (sender.selectedItem)?.title,
		let mode =  ViewMode.init(rawValue: string) {
       		viewMode = mode
		}
    }
}
