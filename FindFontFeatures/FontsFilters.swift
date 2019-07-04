//
//  FontsFilters.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 03/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

enum FontsFilters {
	case name (string: String?)
	case inFonts(_ fonts: Set<NSFont>)
	
	var predicateBlock: (Any?, [String : Any]?) -> Bool {
		switch self {
		//true if name contains string
		case .name (let string?):
			return { object, _ in
				return (object as? NSFont)?.familyName?.contains(string) ?? false
			}
		//if name is nil, all font are returned
		case .name(.none):
			return { _, _ in
				return true
			}
		//true if font contains selector, not just type with selector
		
		case .inFonts(let fonts):
			return { object, _ in
				guard let font = object as? NSFont else {return false}
				return fonts.contains( font )
			}
			/*
			switch previewType {
			case .allFonts, .selectionByFont:
				return { _, _ in
					return true
				}
			case .selectionByFeature:
				
				return { object, _ in
					
					var result = false
					guard let font = object as? NSFont else {return false}
					typeControllers.forEach { tc in
						tc.selectorControllers.forEach { sc in
							if font.has(type: tc.type, selector: sc.selector) && sc.search == .on {
							//if sc.fonts.contains(font) && sc.search == .on {
								result = true
								return
							}
						}
						if result { return }
					}
					return result
				}
			}
		*/
		}
	}
}
