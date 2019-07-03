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
	case selectors (typeControllers :[TypeController])
	
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
		case .selectors(let typeControllers):
			return { object, _ in
				var result = false
				guard let font = object as? NSFont else {return false}
				typeControllers.forEach { tc in
					tc.selectorControllers.forEach { sc in
						if font.has(type: tc.type, selector: sc.selector) {
							result = true
							return
						}
					}
					if result { return }
				}
				return result
			}
		}
	}
}
