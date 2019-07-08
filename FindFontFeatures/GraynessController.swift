//
//  Grayness.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 06/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit

class GraynessController: NSObject {
	
	enum PreviewType: String, CaseIterable {
		case glyphRectangles = "Individual glyphs gray"
		case justGrayLine = "Overall line gray"
		case trimmedGlyphs = "Rendered Glyphs"
	}
	
	@IBOutlet var fontsArrayController: FontsArrayController!
	@IBOutlet weak var textField: NSTextField!
	@IBOutlet weak var measurmentPopUpButton: NSPopUpButton!
	
	var foregroundColorGray: NSColor {
		return NSColor(named: NSColor.Name("GraynessForeground"))!.usingColorSpace(.deviceGray)!
	}
	
	var backgroundColorGray: NSColor {
		return NSColor(named: NSColor.Name("GraynessBackground"))!.usingColorSpace(.deviceGray)!
	}
	
	@objc var stringToRender: String = "hhhooonono" {
		willSet {
			willChangeValue(for: \GraynessController.stringToRender)
			willChangeValue(for: \GraynessController.image)
			willChangeValue(for: \GraynessController.grayness)
		}
		didSet {
			didChangeValue(for: \GraynessController.stringToRender)
			didChangeValue(for: \GraynessController.image)
			didChangeValue(for: \GraynessController.grayness)
		}
	}
	
	var measurmentLine: NSFont.VerticalMeasurment = .x_height {
		willSet{
			willChangeValue(for: \GraynessController.image)
			willChangeValue(for: \GraynessController.grayness)
		}
		didSet {
			didChangeValue(for: \GraynessController.image)
			didChangeValue(for: \GraynessController.grayness)
		}
	}
	
	@objc var font: NSFont? {
		willSet {
			willChangeValue(for: \GraynessController.font)
			willChangeValue(for: \GraynessController.image)
			willChangeValue(for: \GraynessController.grayness)
		}
		didSet {
			didChangeValue(for: \GraynessController.image)
			didChangeValue(for: \GraynessController.font)
			didChangeValue(for: \GraynessController.grayness)
		}
		
	}
	
	var currentPreview: PreviewType = .glyphRectangles {
		willSet{willChangeValue(for: \GraynessController.image)}
		didSet{didChangeValue(for: \GraynessController.image)}
	}
	
	
	override func awakeFromNib() {
		fontsArrayController.addObserver(self, forKeyPath: "currentFont", options: [.old, .new], context: nil)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		font = fontsArrayController.currentFontController?.font
	}
	
	
	@objc var image:NSImage? {
		let image:CGImage?
		switch currentPreview {
		case .glyphRectangles:
			image = glyphsRectanglesCGImage
		case .justGrayLine:
			image = justGrayLineCGImage
		case .trimmedGlyphs:
			image = trimmedGlyphsCGImage
		}
		return image == nil ? nil : NSImage(cgImage: image!, size: NSSize.zero)
	}
	
	@objc func controlTextDidChange (_ notification:Notification) {
		guard let text = (notification.object as? NSTextField)?.stringValue else {return}
		stringToRender = text
	}
	
	
	@objc var measurmentItems: [String] {
		return NSFont.VerticalMeasurment.allCases.map({$0.rawValue})
	}

	@IBAction func changeMeasurment(_ sender:NSPopUpButton) {
		guard let name = sender.selectedItem?.representedObject as? String,
			let verticalUp = NSFont.VerticalMeasurment.init(rawValue: name)
			else { return }
		measurmentLine = verticalUp
	}
	
	
	@objc var previewTypeItems: [String] {
		return PreviewType.allCases.map({$0.rawValue})
	}
	
	@IBAction func changePreview(_ sender:NSPopUpButton) {
		guard let name = sender.selectedItem?.representedObject as? String,
			let type = PreviewType.init(rawValue: name)
			else {return}
		currentPreview = type
	}
	
	var attributesForRender:[NSAttributedString.Key:Any] {
		return font == nil ? [:] : [NSAttributedString.Key.foregroundColor: NSColor.white,
									NSAttributedString.Key.font: font!]
	}
	
	override init() {
		super.init()
	}

	@objc var grayness: Double {
		return trimmedGlyphsCGImage?.overralGrayness() ?? 0.0
	}
	
	var trimmedGlyphsCGImage: CGImage? {
		return font == nil
			? nil
			: stringToRender.renderImage(
				to: measurmentLine,
				attributes: attributesForRender)
	}
	
	static func graynessContext(width:Int, height: Int) -> CGContext? {
		let colorspace = CGColorSpaceCreateDeviceGray()// CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
		return CGContext(data: nil,
						 width: Int(width),
						 height: Int(height),
						 bitsPerComponent: 8,
						 bytesPerRow: 0,
						 space: colorspace,
						 bitmapInfo: bitmapInfo.rawValue)
	}
	
	var justGrayLineCGImage: CGImage? {
		if let image = trimmedGlyphsCGImage, let font = font {
			let width = CGFloat(image.width)
			let height = font.height(of: measurmentLine)

			if let context = GraynessController.graynessContext(width: Int(width), height: Int(height)) {
				let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
				graphicsContext.saveGraphicsState()
				NSGraphicsContext.current = graphicsContext
				//let color =  uiGray(CGFloat(grayness))
				context.setFillColor(gray: backgroundColorGray.whiteComponent, alpha: 1.0)
				context.fill(NSMakeRect(0, 0, width, height))
				context.setFillColor(gray: foregroundColorGray.whiteComponent, alpha: CGFloat(grayness))
				
				context.fill(NSMakeRect(0, 0, width, height))
				
				graphicsContext.restoreGraphicsState()
				
				return context.makeImage()
			}
		}
		return nil
	}
	
	var glyphsRectanglesCGImage: CGImage? {
		if let font = font {
			var images = [(width:Int, gray:CGFloat)]()
			for i in 0..<stringToRender.count {
				if let pic = stringToRender.renderImage(to: measurmentLine, attributes: attributesForRender, from: i, glyps: 1) {
					
					images.append((width: pic.width, gray:CGFloat(pic.overralGrayness())))
					
				}
			}
			
			let width = CGFloat(images.reduce(into:0, {$0+=$1.width}))
			let height = font.height(of: measurmentLine)
	
			if let context = GraynessController.graynessContext(width: Int(width
			), height: Int(height)) {
				let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
				graphicsContext.saveGraphicsState()
				NSGraphicsContext.current = graphicsContext
				
				let minGray: CGFloat = images.min(by: {$0.gray < $1.gray && $0.gray != 0 })?.gray ?? 0.0
				let maxGray: CGFloat = images.max(by: {$0.gray < $1.gray})?.gray ?? 1.0
				let averageGray: CGFloat = images.reduce(into: 0, {$0 = $0+$1.gray}) / CGFloat(images.count)
				
				var x:CGFloat = 0.0
				context.setFillColor(gray:backgroundColorGray.whiteComponent, alpha: 1)
				context.fill(NSMakeRect(0, 0, width, height))
				for image in images {
					
					context.setFillColor(gray: foregroundColorGray.whiteComponent, alpha: CGFloat(image.gray))
					context.fill(NSMakeRect(x, 0, CGFloat(image.width), font.height(of: measurmentLine)))
					let amplified: CGFloat = minGray == maxGray ? 0 : (CGFloat(image.gray) - minGray) / (maxGray-minGray)
					context.setFillColor(gray:foregroundColorGray.whiteComponent, alpha: amplified)
					context.fill(NSMakeRect(x, 0, CGFloat(image.width), 1))
					
					x += CGFloat(image.width)
				}
				
				
				graphicsContext.restoreGraphicsState()
				
				return context.makeImage()
			}
		}
		return nil
	}
	
}
