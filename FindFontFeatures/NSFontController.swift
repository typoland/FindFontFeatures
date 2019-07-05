//
//  NSFontController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 05/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

class FontController: NSObject {
	var _font: NSFont
	
	
	init(_ font:NSFont) {
		self._font = font
	}
}

extension FontController {
	func size(_ size: Double) -> NSFont {
		return NSFont(descriptor: _font.fontDescriptor, size: CGFloat(size)) ?? NSFont.labelFont(ofSize: CGFloat(size))
	}
	
	@objc var font: NSFont {
		return _font
	}
	
	@objc var fontName: String {
		return _font.fontName
	}
	@objc var familyName: String {
		return _font.familyName ?? "No Family Name"
	}
	@objc var axisControllers: [AxisController] {
		return font.axisControllers
	}
	
	@objc var allChars: String {
		get {return _font.allChars}
		set {_font.allChars = newValue}
	}
	
	@objc var fontDescriptor: NSFontDescriptor {
		return _font.fontDescriptor
	}
	
	var featuresDescriptions: [OTFType<OTFSelector>] {
		let types: [OTFType<OTFSelector>] = _font.featuresDescriptions()
		return types
	}
}
