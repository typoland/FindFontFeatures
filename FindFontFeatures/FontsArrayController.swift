//
//  FontsArrayController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTF

class FontsArrayController: NSArrayController {
    @IBOutlet var familyNamesArrayController:NSArrayController!
    @IBOutlet var familyStylesController:NSArrayController!
}

var familiesSelectionChanged = "familiesSelectionChanged"
var fontSelectionChanged = "fontSelectionChanged"

//var selectedFonts:[NSFont] = []

extension Notification.Name {
    static var fontSelection = Notification.Name.init(fontSelectionChanged)
}

extension FontsArrayController {
    
    override func awakeFromNib() {
        sortDescriptors = [NSSortDescriptor(key: "fontName", ascending: true)]
        familyNamesArrayController.addObserver(self, forKeyPath: "selection", options: [.old, .new], context: &familiesSelectionChanged)
        familyStylesController.addObserver(self, forKeyPath: "selection", options: [.old, .new], context: &fontSelectionChanged)
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
            
        default: break
        }
    }
	
    @IBAction func setFontNameFilter(_ sender:NSTextField) {
        willChangeValue(for: \FontsArrayController.fontFamilyNames)
        willChangeValue(for: \FontsArrayController.filterPredicate)
       
        if sender.stringValue.isEmpty {
            filterPredicate = nil
        } else {
            let predicate = NSPredicate(format: "familyName CONTAINS [c] \"\(sender.stringValue)\"")
            filterPredicate = predicate
        }
        
        didChangeValue(for: \FontsArrayController.filterPredicate)
        didChangeValue(for: \FontsArrayController.fontFamilyNames)
    }
    

    
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
