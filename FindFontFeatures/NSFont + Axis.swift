//
//  NSFont + Axis.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 04/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

extension NSFont {
	
	
	var axesDict:[[OTFAxisProtocolKeys:Any]] {
		return axes.map{$0.axis.dict}
	}
	
	
	@objc var axes: [AxisController] {
		
		var result:[AxisController] = []
		
		let variation = CTFontCopyVariation(self as CTFont) as? [Int:Double] ?? [:]
		//print ("VARIATION", variation)
		if let descriptor = CTFontCopyVariationAxes(self as CTFont) as? [[String:Any]] { //CTLine
			for axisDescription in descriptor {
				let identifier = axisDescription[OTFAxisProtocolKeys.id.rawValue] as? Int ?? 0
				let axis = OTFAxis(identifier: identifier,
								   name: axisDescription[OTFAxisProtocolKeys.name.rawValue] as? String ?? "no name",
								   min: axisDescription[OTFAxisProtocolKeys.minValue.rawValue] as? Double ?? 0,
								   default: variation[identifier] ?? axisDescription[OTFAxisProtocolKeys.defaultValue.rawValue] as? Double ?? 0,
								   max: axisDescription[OTFAxisProtocolKeys.maxValue.rawValue] as? Double ?? 0)
				//print(axis)
				result.append(AxisController(axis))
			}
		}
		return result
	}
	
}
