//
//  FontsArrayController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

class FontsArrayController: NSArrayController {
	@IBOutlet var mainController: MainController!
    @IBOutlet var familyNamesArrayController: NSArrayController!
    @IBOutlet var familyStylesController: NSArrayController!
	@IBOutlet var axesController: NSArrayController!
	
	@objc var nameFilterString: String? = nil
	@objc var currentFontController: FontController? = nil {
		willSet { willChangeValue(for: \FontsArrayController.currentFont)}
		didSet { didChangeValue(for: \FontsArrayController.currentFont)}
	}
	
	@objc var currentSize: Double = 48 {
		willSet {
			willChangeValue(for: \FontsArrayController.currentFont)
		}
		didSet {
			currentFontController?.fontSize = currentSize
			didChangeValue(for: \FontsArrayController.currentFont)
		}
	}
	
	@objc var currentFont:NSFont {
		return currentFontController?.font ?? NSFont.labelFont(ofSize: CGFloat(currentSize))
	}
}

var familiesSelectionChanged = "familiesSelectionChanged"
var fontSelectionChanged = "fontSelectionChanged"
var viewModeWasChanged = "viewModeWasChanged"
var axisWasChanged = "axisWasChanged"


extension Notification.Name {
    static var fontSelection = Notification.Name.init(fontSelectionChanged)
}


extension FontsArrayController {
    
    override func awakeFromNib() {
        sortDescriptors = [NSSortDescriptor(key: "fontName", ascending: true)]
        familyNamesArrayController.addObserver(self, forKeyPath: "selection", options: [.old, .new], context: &familiesSelectionChanged)
		
        familyStylesController.addObserver(self, forKeyPath: "selection", options: [.old, .new], context: &fontSelectionChanged)
		
		mainController.addObserver(self, forKeyPath: "viewMode", options: [.old, .new], context: &viewModeWasChanged)

		NotificationCenter.default.addObserver(self, selector: #selector(setPredicates(_:)), name: Notification.Name.featuresSearchChanged, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(changeOTFeaturesInCurrentFont(_:)), name: Notification.Name.featureSelectorChanged, object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch context {
			
        case &familiesSelectionChanged:
            willChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
            didChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
			
        case &fontSelectionChanged:
            let selectedFontsControllers = familyStylesController.selectedObjects as! [FontController]
			if selectedFontsControllers.count > 0 {
				currentFontController = selectedFontsControllers[0]
				currentFontController?.fontSize = currentSize
			} else {
				currentFontController = nil
			}
            NotificationCenter.default.post(name: Notification.Name.fontSelection, object: selectedFontsControllers)

		case &viewModeWasChanged:
			print ("viewModeWasChanged")
			setPredicates(self)
            
        default: break
        }
    }
	
	
	@objc func setPredicates(_ sender:Any) {
		willChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
		willChangeValue(for: \FontsArrayController.fontFamilyNames)
		let availableFontsSet: Set<FontController>
		
		switch mainController._viewMode {
			
		case .selectionByFeature:
			availableFontsSet = mainController.typeControllersSet.reduce(into:Set<FontController>(), {set, typeController in
				typeController.selectorControllers.forEach { selectorController in
					if selectorController.fontSearch == .on {
						set.formUnion(selectorController.fonts)
					}
				}
			})
			
		default:
			availableFontsSet = Set(mainController.fontControllersSet)
		}
		
		filterPredicate = NSCompoundPredicate(
			type: .and,
			subpredicates: [
				NSPredicate(block:
					FontsFilters.name(
						string: nameFilterString)
						.predicateBlock),
				NSPredicate(block:
					FontsFilters.inFonts(availableFontsSet)
						.predicateBlock)
			])
		
		didChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
		didChangeValue(for: \FontsArrayController.fontFamilyNames)
	}
	
    @IBAction func setFontNameFilter(_ sender:NSTextField) {
		nameFilterString = sender.stringValue.isEmpty ? nil : sender.stringValue
		setPredicates(self)
    }
	
	@IBAction func setCurrentFontSize(_ sender:NSControl) {
		currentSize = sender.doubleValue
	}
	
	@objc func changeOTFeaturesInCurrentFont(_ notification:Notification) {
		
		setPredicates(self)
		
		//if let selectorController = (notification.object as? SelectorController){
			willChangeValue(for: \FontsArrayController.currentFont)
			didChangeValue(for: \FontsArrayController.currentFont)
		//}
	}
	

	@IBAction func changeAxis(_ sender:NSSlider) {
		willChangeValue(for: \FontsArrayController.currentFont)
		didChangeValue(for: \FontsArrayController.currentFont)
	}
	
	//Takes all families from fonts, after applying filters predicate to fonts
    @objc var fontFamilyNames: [String] {
        return Array((arrangedObjects as! [FontController]).reduce(into: OrderedSet<String>(), { set, fontController in
                set.append(fontController.familyName)

        }))
    }
    
    @objc var selectedFalmiliesFonts: [FontController] {
        var result :[FontController] = []
        for familyName in familyNamesArrayController.selectedObjects as! [String] {
            result += (arrangedObjects as! [FontController]).filter({$0.familyName == familyName})
        }
        return result
    }
}
