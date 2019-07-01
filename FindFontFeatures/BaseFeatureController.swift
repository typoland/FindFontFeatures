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
			self.willChangeValue(for: \BaseFeatureController.selected)
		}
		didSet {
			self.didChangeValue(for: \BaseFeatureController.selected)
		}
	}
	
	@objc var search: NSControl.StateValue = .off {
		willSet {
			self.willChangeValue(for: \BaseFeatureController.search)
		}
		didSet {
			self.didChangeValue(for: \BaseFeatureController.search)
		}
	}    
}
