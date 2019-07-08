//
//  String + render.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 06/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit

extension String {
	
	func storage(attributes:[NSAttributedString.Key:Any]) -> NSTextStorage {
		let attributedString = NSAttributedString(
			//space added to make possible to count a distance after last glyph. In other case is 0, no right sidebearing
			string: self + " ",
			attributes: attributes)
		
		let container = NSTextContainer()
		let storage = NSTextStorage(attributedString: attributedString)
		let manager = NSLayoutManager()
		
		manager.addTextContainer(container)
		storage.addLayoutManager(manager)
		return storage
	}
	
	
	func renderImage(to measurment: NSFont.VerticalMeasurment,
					 attributes:[NSAttributedString.Key:Any],
					 from first:Int = 0,
					 glyps number: Int? = nil) -> CGImage? {
		
		//let scaleFactor = NSScreen.main?.backingScaleFactor ?? 1
		let storage = self.storage(attributes: attributes)
		let manager = storage.layoutManagers[0]
		let last = number == nil ? storage.length - 1 : first + number!
		
		let firstGlyphLocation = manager.location(forGlyphAt: first)
		let layoutLocation = manager.location(forGlyphAt: last)
		let font = attributes[NSAttributedString.Key.font] as! NSFont
		//font = NSFont(descriptor: font.fontDescriptor, size: font.pointSize * scaleFactor)!
		let width = Int(layoutLocation.x - firstGlyphLocation.x)
		let height = Int(font.height(of: measurment))
		
		let colorspace = CGColorSpaceCreateDeviceGray()// CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
		
		if let context = CGContext(data: nil,
								   width: width,
								   height: height,
								   bitsPerComponent: 8,
								   bytesPerRow: 0,
								   space: colorspace,
								   bitmapInfo: bitmapInfo.rawValue) {
			
			// range without last added space
			let length = last - first
			let range = NSRange(location: first, length: length)
			
			let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
			graphicsContext.saveGraphicsState()
			NSGraphicsContext.current = graphicsContext
			manager.drawGlyphs (
				forGlyphRange: range,
				at: NSPoint(x: 0 - firstGlyphLocation.x, y: 0 - font.ascender))
			graphicsContext.restoreGraphicsState()
			
			return context.makeImage()
		}
		return nil
	}
}
