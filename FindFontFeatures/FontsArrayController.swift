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
	@objc var currentFont: NSFont = NSFont.labelFont(ofSize: 48)
		//didSet { originalFontName = currentFont.fontName}
	
	@objc var currentSize: Double = 48
	//var originalFontName: String = ""
}

var familiesSelectionChanged = "familiesSelectionChanged"
var fontSelectionChanged = "fontSelectionChanged"
var viewModeWasChanged = "viewModeWasChanged"

//var selectedFonts:[NSFont] = []

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
            let selectedFonts = familyStylesController.selectedObjects as! [FontController]
			willChangeValue(for: \FontsArrayController.currentFont)
			if selectedFonts.count > 0 {
				currentFont = NSFont(descriptor: selectedFonts[0].fontDescriptor, size: CGFloat(currentSize)) ?? NSFont.labelFont(ofSize: CGFloat(currentSize))
			} else {
				currentFont = NSFont.labelFont(ofSize: CGFloat(currentSize))
			}
			didChangeValue(for: \FontsArrayController.currentFont)
            NotificationCenter.default.post(name: Notification.Name.fontSelection, object: selectedFonts)
		case &viewModeWasChanged:
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
			availableFontsSet = mainController._typeControllers.reduce(into:Set<FontController>(), {set, tc in
				tc.selectorControllers.forEach { sc in
					if sc.fontSearch == .on {
						set.formUnion(sc.fonts)
					}
				}
			})
			
		default:
			availableFontsSet = Set(mainController._fontControllers)
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
		willChangeValue(for: \FontsArrayController.currentSize)
		willChangeValue(for: \FontsArrayController.currentFont)
		currentSize = sender.doubleValue
		let fontDescriptor = currentFont.fontDescriptor
		print ("Font Descriptor", fontDescriptor)
		currentFont = NSFont(descriptor: fontDescriptor, size: CGFloat(currentSize)) ?? NSFont.labelFont(ofSize: CGFloat(currentSize))
		didChangeValue(for: \FontsArrayController.currentFont)
		didChangeValue(for: \FontsArrayController.currentSize)
	}
	
	@objc func changeOTFeaturesInCurrentFont(_ notification:Notification) {
		setPredicates(self)
		
		if let selectorController = (notification.object as? SelectorController){
			willChangeValue(for: \FontsArrayController.currentFont)
			let type = selectorController.parent.type
			let selector = selectorController.selector
			
			let fontDescriptor = currentFont.fontDescriptor.addingAttributes([
				NSFontDescriptor.AttributeName.featureSettings: [
					[
						NSFontDescriptor.FeatureKey.typeIdentifier:
							type.identifier,
						NSFontDescriptor.FeatureKey.selectorIdentifier:
							selector.identifier
					]
				]
				])
			
			currentFont = NSFont(descriptor: fontDescriptor, size: CGFloat(currentSize)) ?? NSFont.labelFont(ofSize: CGFloat(currentSize))

			didChangeValue(for: \FontsArrayController.currentFont)
		}
	}
	

	@IBAction func changeAxis(_ sender:NSSlider) {
		
		if let axisControllers = axesController.arrangedObjects as? [AxisController] {
			let oldFont = CTFontCopyGraphicsFont(currentFont, nil)
			var variations : [CFString:CFNumber] = [ : ] //Error in documentation
			for axisController in axisControllers {
				variations[axisController.axisName as CFString] = axisController.currentValue as CFNumber
			}
			print ("variations:" , variations)
			
			if let newFont = oldFont.copy(withVariations: variations as CFDictionary) {
				
				willChangeValue(for: \FontsArrayController.currentFont)
				print ("newFont", newFont)
				
				currentFont = CTFontCreateWithGraphicsFont(
					newFont,
					CGFloat(currentSize),
					nil,
					currentFont.fontDescriptor)
				print ("patatj", currentFont.fontDescriptor)
				didChangeValue(for: \FontsArrayController.currentFont)
			}
		}
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
