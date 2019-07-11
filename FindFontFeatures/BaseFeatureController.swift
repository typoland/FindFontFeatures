//
//  BaseFeatureController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 17/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
class BaseFeatureController: NSObject {
    
	@objc var selected: Bool = false {
		willSet {
			self.willChangeValue(for: \.selected)
		}
		didSet {
			self.didChangeValue(for: \.selected)
		}
	}
	
	@objc var fontSearch: NSControl.StateValue = .off {
		willSet {
			self.willChangeValue(for: \.fontSearch)
		}
		didSet {
			self.didChangeValue(for: \.fontSearch)
		}
	}    
}
