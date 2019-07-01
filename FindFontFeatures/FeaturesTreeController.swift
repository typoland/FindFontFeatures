//
//  FeaturesArrayController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit

class FeaturesTreeController:NSTreeController, NSOutlineViewDataSource, NSOutlineViewDelegate {
	//NSOutlineViewDataSource//,
	
	
	//@IBOutlet weak var outlineView:NSOutlineView!
	
	//	@objc var typeControllers: [TypeController] = [] {
	//		didSet {
	//			outlineView.reloadData()
	//		}
	//	}
	override func awakeFromNib() {
		print ("AWAKE THIUS")
	}
	
	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		print ("children of", item)
		switch item {
		case is TypeController:
			return(item as! TypeController).selectorControllers.count
		case is SelectorController:
			return 0
		default:
			return 0//typeControllers.count
		}
	}
	
	func outlineViewSelectionIsChanging(_ notification: Notification) {
		print (notification)
		//let column = outlineView.column(withIdentifier: NSUserInterfaceItemIdentifier.init("Types")) {
		
		//print (typeControllers[outlineView.selectedRow])
	}
	
	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		print ("is item expandible", item)
		if  item is TypeController {
			return true
		} else {
			return false
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
		return (item as? NSTreeNode)?.representedObject
	}
	
	func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
		if (item as? NSTreeNode)?.representedObject is SelectorController {
			return 15
		}
		return 18
	}
	
	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		print("childOfItem", item, index)
		if item == nil {
			return 5//typeControllers[index]
		} else {
			//let keys = (item as! LDOpenTypeFeaturesType).featuresString]
			return (item as! TypeController).selectorControllers[index]
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
		if item is TypeController {
			return (item as! TypeController).enabled
		}
		return true
	}
	
	
	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		if let columnIdentifier = tableColumn?.identifier{
			//print("Column", columnIdentifier, item)
			switch columnIdentifier.rawValue {
			case "Types" :
				
				if (item as? NSTreeNode)?.representedObject is SelectorController {
					
					let cell: NSTableCellView// LDTableCellButton
					if ((item as! NSTreeNode).representedObject as! SelectorController ).parent.type.exclusive != 0 {
						cell = outlineView.makeView(withIdentifier:
							NSUserInterfaceItemIdentifier(rawValue: "NonExclusive"), owner: self) as! NSTableCellView//LDTableCellButton
						
					} else {
						cell = outlineView.makeView(withIdentifier:
							NSUserInterfaceItemIdentifier(rawValue: "Exclusive"), owner: self) as! NSTableCellView//LDTableCellButton
					}
					//cell.checkButton.enabled = checkFeatureInSelectedFonts(item as! OTFeature)
					
					//cell.checkButton.integerValue =  0
					return cell
					
				} else if (item as? NSTreeNode)?.representedObject is TypeController {
					let cell = outlineView.makeView(withIdentifier:
						NSUserInterfaceItemIdentifier(rawValue: "Type"), owner: self) as! NSTableCellView
					return cell
				}
			case "Actions" :
				print ("inActions")
				let cell = outlineView.makeView(withIdentifier:
					NSUserInterfaceItemIdentifier(rawValue: "Identifier"), owner: self) as! NSTableCellView
				return cell
				
			default:
				let cell = outlineView.makeView(withIdentifier:
					NSUserInterfaceItemIdentifier(rawValue: "Search"), owner: self) as! CellCheckButton//LDTableCellButton
				if (item as? NSTreeNode)?.representedObject is SelectorController {
					//cell.checkButton.isEnabled = true
					cell.checkButton.allowsMixedState = false
					return cell
					
				} else if (item as? NSTreeNode)?.representedObject is TypeController {
					//cell.checkButton.isEnabled = true
					print ("doś bierze")
					cell.checkButton.allowsMixedState = true
					if let typeController = (item as? NSTreeNode)?.representedObject as? TypeController {
						print ("STATE", typeController,  typeController.search)
						typeController.selectorControllers.forEach {
							print ($0, $0.search)
						}
						cell.checkButton.state = typeController.search
					}
					
					
					//cell.checkButton.integerValue = (item as! FFFType).search
					
				}
				return cell
			}
		}
		return nil
	}
	
	@IBAction func toogleNonExclusiveSelector(_ sender:AnyObject) {
		print("set toogleNonExclusiveSelector", sender)
		if let selector = (sender.superview as? NSTableCellView)?.objectValue as? SelectorController {
			print (selector.selected)
		}
	}
	@IBAction func toogleExclusiveSelector(_ sender:NSButton) {
		if let selector = (sender.superview as? NSTableCellView)?.objectValue as? SelectorController {
			print ("OK", selector.parent, selector)
			selector.parent.selectExclusive(selector: selector)
		}
	}
	
	@IBAction func toogleSearch(_ sender:NSButton) {
		if let selectorController = (sender.superview as? NSTableCellView)?.objectValue as? SelectorController {
			print ("OK", selectorController)
			//selector.parent.willChangeValue(for: \TypeController.search)
			//selector.willChangeValue(for: \SelectorController.search)
			selectorController.search = sender.state
		}
		
		if let typeController = (sender.superview as? NSTableCellView)?.objectValue as? TypeController {
			print ("OK", typeController)
			for selectorController in typeController.selectorControllers {
				selectorController.search = sender.state
			}
		}
		//didChangeValue(for: \FeaturesTreeController.arrangedObjects)
	}
}
