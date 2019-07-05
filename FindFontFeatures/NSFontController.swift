//
//  NSFontController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 05/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit

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
	
	@objc var fontName:String {
		return _font.fontName
	}
	
	@objc var axisControllers: [AxisController] {
		return font.axisControllers
	}
}
