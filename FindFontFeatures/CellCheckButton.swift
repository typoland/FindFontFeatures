//
//  CellCheckButton.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 13/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

class CellCheckButton: NSTableCellView {
    
    @IBOutlet weak var checkButton:NSButton!
	
//	override func didChangeValue(forKey key: String) {
//		if key == "objectValue" {
//			if let typeController = objectValue as? TypeController {
//				typeController.addObserver(self, forKeyPath: "fontSearch", options: [.old, .new], context: nil)
//			}
//		}
//	}
//	
//	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//		print ("obseving")
//		//super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//	}
	
//	@IBAction func click(_ sender: NSButton) {
//		print ("click")
//		 sender.state = sender.state != .off ? .on : .off
//	}
}
