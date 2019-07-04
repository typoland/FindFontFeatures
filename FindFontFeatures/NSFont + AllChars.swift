//
//  NSFont + AllChars.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 04/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
extension NSFont {
	@objc var allChars: String {
		get {return allCharacters}
		set {}
	}
}
