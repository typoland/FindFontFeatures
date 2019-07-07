//
//  NSFont + VericalMeasurment.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 06/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit


extension NSFont {
	enum VerticalMeasurment: String, CaseIterable {
		case x_height = "x-height"
		case capHeight = "CAPS height"
		case ascender = "ÁŚĆËÑĎĒȐ"
	}
	
	func height(of measurment: NSFont.VerticalMeasurment) -> CGFloat {
		switch measurment {
		case .x_height: return self.xHeight
		case .capHeight: return self.capHeight
		case .ascender: return self.ascender
		}
	}
}
