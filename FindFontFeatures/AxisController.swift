//
//  AxisController.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 04/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

class AxisController:NSObject {
	
	var axis:OTFAxis
	
	@objc var currentValue: Double {
		willSet { willChangeValue(for: \AxisController.currentValue)}
		didSet { didChangeValue(for: \AxisController.currentValue)}
	}
	
	init (_ axis:OTFAxis) {
		self.axis = axis
		self.currentValue = axis.defaultValue
		super.init()
	}
}

extension AxisController {
	@objc var axisName: String {
		return axis.name
	}
	
	@objc var maxValue: Double {
		return axis.maxValue
	}
	
	@objc var minValue: Double {
		return axis.minValue
	}
	
	@objc var defaultValue: Double {
		return axis.defaultValue
	}
}

extension AxisController {
	override var description: String {
		return "\(axisName): \(currentValue)"
	}
}
