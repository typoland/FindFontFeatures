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
	
	@IBOutlet var mainController:MainController!
	
	func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
		if (item as? NSTreeNode)?.representedObject is SelectorController {
			return 15
		}
		return 18
	}
	enum Columns: String {
		case types = "Types"
		case filters = "Filters"
	}
	
	func outlineView(_ outlineView: NSOutlineView,
					 viewFor tableColumn: NSTableColumn?,
					 item: Any) -> NSView? {
		
		let item = (item as? NSTreeNode)?.representedObject
		
		if let columnIdentifier = tableColumn?.identifier.rawValue {
			
			switch columnIdentifier {
				
			case Columns.types.rawValue :
				switch item {
				case is SelectorController:
					
					let selectorController = item as! SelectorController
					let identifier = selectorController.parent.type.exclusive != 0 ?
						NSUserInterfaceItemIdentifier(rawValue: "NonExclusive") :
						NSUserInterfaceItemIdentifier(rawValue: "Exclusive")
					
					return  outlineView.makeView(
						withIdentifier: identifier,
						owner: self) as? NSTableCellView//LDTableCellButton
					
				case is TypeController:
					return outlineView.makeView(withIdentifier:
						NSUserInterfaceItemIdentifier(rawValue: "Type"), owner: self) as? NSTableCellView
					
				default:
					return nil
				}
				
			case Columns.filters.rawValue :
				let cell = outlineView.makeView(
					withIdentifier:
					NSUserInterfaceItemIdentifier(rawValue: "Search"), owner: self) as! CellCheckButton//LDTableCellButton
				
				switch item {
					
				case is SelectorController:
					cell.checkButton.allowsMixedState = false
					cell.checkButton.isEnabled = mainController.viewMode == .selectionByFeature
					return cell
					
				case is TypeController:
					cell.checkButton.allowsMixedState = true
					cell.checkButton.isEnabled = mainController.viewMode == .selectionByFeature
					return cell
					
				default:
					return nil
				}
			default:
				return nil
			}
		}
		return nil
		
	}
}
