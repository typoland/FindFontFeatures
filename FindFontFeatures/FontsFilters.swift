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
			
		//true if font is in fonts
		case .inFonts(let fonts):
			return { object, _ in
				guard let font = object as? NSFont else {return false}
				return fonts.contains( font )
			}
			
		}
	}
}
