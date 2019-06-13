//
//  FeaturesOutlineViewDelegate.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 11/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit


class FeaturesOutlineViewDelegate:NSObject ,  NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    @IBOutlet weak var mainContoller:FFFeaturesController!
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item is FFFType {
            return (item as! FFFType).selectors.count
        } else if item is FFFSelector {
            return 0
        }
        return mainContoller._types.count
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        //print ("is item expandible", item)
        if  item is FFFType {
            return true
        } else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        //print("Teraz odda dupę, tylko po co?", item, tableColumn?.identifier)
        return item
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if item is FFFSelector {
            return 15
        }
        return 18
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        //print("childOfItem", item, index)
        if item == nil {
            return mainContoller._types[index]
        } else {
            //let keys = (item as! LDOpenTypeFeaturesType).featuresString]
            return (item as! FFFType).selectors[index]
        }
    }
}
