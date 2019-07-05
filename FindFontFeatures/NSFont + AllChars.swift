//
//  NSFont + AllChars.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 04/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit

var defaultString: String? = nil
extension NSFont {
	@objc var allChars: String {
		get {return defaultString ?? allCharacters}
		set {
			willChangeValue(for: \NSFont.allChars)
			defaultString = newValue == "" ? nil : newValue
			didChangeValue(for: \NSFont.allChars)
		}
		
	}
}
