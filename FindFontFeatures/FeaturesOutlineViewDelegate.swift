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


class FeaturesOutlineViewDelegate: NSObject ,  NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    @IBOutlet weak var mainContoller:FFFeaturesController!
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        print ("children of", item)
        if item is FFFType {
            return (item as! FFFType).selectors.count
        } else if item is FFFSelector {
            return 0
        }
        return mainContoller.types.count
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        print ("is item expandible", item)
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
            return mainContoller.types[index]
        } else {
            //let keys = (item as! LDOpenTypeFeaturesType).featuresString]
            return (item as! FFFType).selectors[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let columnIdentifier = tableColumn?.identifier{
            //print(columnIdentifier)
            switch columnIdentifier.rawValue {
            case "Types" :
                
                if item is FFFSelector {
                    
                    let cell: NSTableCellView// LDTableCellButton
                    if (item as! FFFSelector).parent.exclusive != nil {
                        cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FFFSelector"), owner: self) as! NSTableCellView//LDTableCellButton
                        
                    } else {
                        cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FFFSelector"), owner: self) as! NSTableCellView//LDTableCellButton
                    }
                    //cell.checkButton.enabled = checkFeatureInSelectedFonts(item as! OTFeature)
                    
                    //cell.checkButton.integerValue =  0
                    return cell
                    
                } else if item is FFFType {
                    let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FFFType"), owner: self) as! NSTableCellView
                    return cell
                }
            case "Actions" :
                let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Identifier"), owner: self) as! NSTableCellView
                return cell
                
            default:
                let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FFFSearch"), owner: self) as! CellCheckButton//LDTableCellButton
                if item is FFFSelector {
                    //cell.checkButton.integerValue = (item as! FFFSelector).search
                    cell.checkButton.isEnabled = true
                    cell.checkButton.allowsMixedState = false
                    return cell
                } else if item is FFFType {
                    //cell.checkButton.integerValue = (item as! FFFType).search
                    
                }
                return cell
                
            }
            
        }
        return nil
        
    }
}
