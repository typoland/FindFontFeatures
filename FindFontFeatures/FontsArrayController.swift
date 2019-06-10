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

extension FontsArrayController {
    
    override func awakeFromNib() {
        sortDescriptors = [NSSortDescriptor(key: "familyName", ascending: true)]
        familyNamesArrayController.addObserver(self, forKeyPath: "selection", options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        willChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
        print ("observe")
        didChangeValue(for: \FontsArrayController.selectedFalmiliesFonts)
    }
    
    
    @IBAction func setFontNameFilter(_ sender:NSTextField) {
        willChangeValue(for: \FontsArrayController.filterPredicate)
        willChangeValue(for: \FontsArrayController.fontFamilyNames)
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
        return Array((arrangedObjects as! [NSFont]).reduce(into: OrderedSet<String>(), {set, font in
            set.append(font.familyName ?? "No named family")
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
