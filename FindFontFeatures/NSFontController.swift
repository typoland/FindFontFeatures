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
	var _size: CGFloat = 12
	//var featureSettings: [NSFontDescriptor.FeatureKey:Int] = [:]
	
	@objc var axisControllers: [AxisController]
	@objc var selectorControllers: [SelectorController] = []
	//var featuresSettings : [[NSFontDescriptor.FeatureKey:Int]]
	//var typeControllers: [TypeController]
	
	init(_ font:NSFont) {
		self._font = font
		self.axisControllers = font.axes.map { AxisController($0) }
	}
	
}

extension FontController {
	@objc var fontSize: Double {
		set { _size = CGFloat(newValue) }
		get { return Double(_size) }
	}
	
	@objc var font: NSFont {
		if let newFont = CTFontCopyGraphicsFont(_font, nil)
			.copy(withVariations: variations) {
			return CTFontCreateWithGraphicsFont(
				newFont,
				_size,
				nil,
				fontDescriptor)
			
		}
		return NSFont(descriptor: fontDescriptor, size: _size) ?? NSFont.labelFont(ofSize: CGFloat(fontSize))
	}
	
	@objc var fontName: String {
		return _font.fontName
	}
	
	@objc var familyName: String {
		return _font.familyName ?? "No Family Name"
	}
	
	
	@objc var allChars: String {
		get {return _font.allChars}
		set {_font.allChars = newValue}
	}
	
	
	
	@objc var fontDescriptor: NSFontDescriptor {
		return _font.fontDescriptor.addingAttributes([
			NSFontDescriptor.AttributeName.featureSettings:
				featuresSettings,
			NSFontDescriptor.AttributeName.size:
				_size
			])
	}
	
	var featuresSettings:[[NSFontDescriptor.FeatureKey:Int]] {
		var result:[[NSFontDescriptor.FeatureKey:Int]] = [[:]]
		for selectorController in selectorControllers {
			let type = selectorController.parent.type

			if type.exclusive == 1 {
				
				if selectorController.selected {
					let selector = selectorController.selector
					var featureSettings:[NSFontDescriptor.FeatureKey:Int] = [:]
					featureSettings[NSFontDescriptor.FeatureKey.typeIdentifier] = type.identifier
					featureSettings[NSFontDescriptor.FeatureKey.selectorIdentifier] = selector.identifier
					result.append(featureSettings)
				}
			} else {
				for selectorController in selectorController.parent.selectorControllers {
					let selector = selectorController.selector
					var featureSettings:[NSFontDescriptor.FeatureKey:Int] = [:]
					featureSettings[NSFontDescriptor.FeatureKey.typeIdentifier] = type.identifier
					featureSettings[NSFontDescriptor.FeatureKey.selectorIdentifier]
						= selectorController.selected ? selector.identifier : selector.identifier + 1
					result.append(featureSettings)
				}
			}
		}
		return result
	}
	
	var featuresDescriptions: [OTFType<OTFSelector>] {
		let types: [OTFType<OTFSelector>] = _font.featuresDescriptions()
		return types
	}
	
	var variations: CFDictionary {
		var _variations : [CFString:CFNumber] = [:] //CFDictionary //Error in documentation
		
		for axisController in axisControllers {
			_variations[axisController.axisName as CFString] = axisController.currentValue as CFNumber
		}
		return _variations as CFDictionary
	}
}

//extension FontController {
//	func setSelector(_ selectorController: SelectorController) {
//
//		//selectorControllers.forEach({print ("\($0)\n\($0.selector)\n")})
//
//		print ()
//	}
//}

extension FontController {
	override var description: String {
		return "Font Controller \"\(_font.fontName)\" \(selectorControllers.count) selectors"
	}
}
