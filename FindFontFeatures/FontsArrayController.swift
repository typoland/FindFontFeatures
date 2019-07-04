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
	@IBOutlet var mainController:MainController!
    @IBOutlet var familyNamesArrayController:NSArrayController!
    @IBOutlet var familyStylesController:NSArrayController!
	@objc var nameFilterString: String? = nil
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
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch context {
        case &familiesSelectionChanged:
            willChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
            print ("observe families")
            didChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
        case &fontSelectionChanged:
            print ("observe fonts")
            let selectedFonts = familyStylesController.selectedObjects as! [NSFont]
            NotificationCenter.default.post(name: Notification.Name.fontSelection, object: selectedFonts)
		case &viewModeWasChanged:
			print ("observe viewMode")
			setPredicates(self)
            
        default: break
        }
    }
	
	
	@objc func setPredicates(_ sender:Any) {
		willChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
		willChangeValue(for: \FontsArrayController.fontFamilyNames)
		print ("setting predicate")
		let availableFontsSet: Set<NSFont>
		switch mainController._viewMode {
		case .selectionByFeature:
			availableFontsSet = mainController._typeControllers.reduce(into:Set<NSFont>(), {set, tc in
				tc.selectorControllers.forEach { sc in
					if sc.fontSearch == .on {
						set.formUnion(sc.fonts)
					}
				}
			})
			
		default:
			availableFontsSet = Set(mainController._fonts)
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
        //willChangeValue(for: \FontsArrayController.fontFamilyNames)
        //willChangeValue(for: \FontsArrayController.filterPredicate)
		nameFilterString = sender.stringValue.isEmpty ? nil : sender.stringValue
		setPredicates(self)
        //didChangeValue(for: \FontsArrayController.filterPredicate)
        //didChangeValue(for: \FontsArrayController.fontFamilyNames)
    }
	
	
	//Takes all families from fonts, after applying filters predicate to fonts
    @objc var fontFamilyNames: [String] {
        return Array((arrangedObjects as! [NSFont]).reduce(into: OrderedSet<String>(), { set, font in
            if let fontFamily = font.familyName {
                set.append(fontFamily)
            } else {
                print ("Unknown family name of \(font)")
            }
        }))
    }
    
    @objc var selectedFalmiliesFonts: [NSFont] {
        var result :[NSFont] = []
        for familyName in familyNamesArrayController.selectedObjects as! [String] {
            result += (arrangedObjects as! [NSFont]).filter({$0.familyName == familyName})
        }
        return result
    }
}
