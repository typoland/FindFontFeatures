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
	
	enum PreviewType {
		case grays
		case gray
		case glyphs
		
		func toogle() -> PreviewType {
			switch self {
			case .glyphs: return .grays
			case .grays: return .gray
			case .gray: return .glyphs
			}
		}
		
	}
	
	@IBOutlet var fontsArrayController: FontsArrayController!
	@IBOutlet weak var preview: NSImageView!
	@IBOutlet weak var textField: NSTextField!
	@IBOutlet weak var measurmentPopUpButton: NSPopUpButton!
	
	var lineCgImage: CGImage?
	var glyphsCGImages: CGImage?
	var grayCGImage: CGImage?
	
	@objc var string: String = "hhhooonono" {
		didSet { setupGrayness() }
	}
	
	var measurmentLine: NSFont.VerticalMeasurment = .x_height {
		didSet { setupGrayness() }
	}
	
	@objc dynamic var font: NSFont {
		return fontController?.font ?? NSFont.labelFont(ofSize: 12)
	}
	
	var currentPreview: PreviewType = .grays
	@objc var fontController: FontController? = nil {
		didSet {setupGrayness()}
	}
	
	@objc var foregroundColor: NSColor = NSColor.controlTextColor
	@objc var backgroundColor: NSColor = NSColor.textBackgroundColor
	
	override func awakeFromNib() {
		fontsArrayController.addObserver(self, forKeyPath: "currentFont", options: [.old, .new], context: nil)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		fontController = fontsArrayController.currentFontController
	}
	
	@IBAction func tooglePreview(_ sender:Any) {
		currentPreview = currentPreview.toogle()
		changePreviewImage()
	}

	@objc func controlTextDidChange (_ notification:Notification) {
		guard let textField = notification.object as? NSTextField  else {return}
		changeString(textField)
	}
	
	@IBAction func changeString(_ sender:NSTextField) {
		string = sender.stringValue// stringValue
		
	}
	
	
	@IBAction func changeMeasurment(_ sender:NSPopUpButton) {
		guard let name = sender.selectedItem?.representedObject as? String,
			let mes = NSFont.VerticalMeasurment.init(rawValue: name)
			else {return}
		measurmentLine = mes
		changePreviewImage()
	}
	
	func changePreviewImage() {
		switch currentPreview {
		case .grays: preview.image = graysImage
		case .glyphs: preview.image = image
		case .gray: preview.image = grayImage
		}
		preview.needsDisplay = true
	}

	
	
	var attributes:[NSAttributedString.Key:Any] {
		return [NSAttributedString.Key.foregroundColor: fontColor,
				NSAttributedString.Key.font: font]
	}
	
	@objc var fontColor: NSColor {
		return NSColor.white
	}
	
	@objc var measurmentItems: [String] {
		return NSFont.VerticalMeasurment.allCases.map({$0.rawValue})
	}
	

	
	override init() {
		//self.font = NSFont.boldSystemFont(ofSize: 50)
		super.init()
		resetCGImage()
		resetGlyphsCGImage()
		resetGrayCGImage()
	}
	
	func setupGrayness() {
		resetCGImage()
		resetGlyphsCGImage()
		resetGrayCGImage()
		changePreviewImage()
		
		textField.cell?.font = fontController?.font ?? NSFont.labelFont(ofSize: 12)
		
	}
	
	@objc var grayness: Double {
		return lineCgImage?.overralGrayness() ?? 0.0
	}
	
	func uiGray(_ gray:CGFloat) -> CGFloat {
		let bval = (
			NSColor(named: NSColor.Name("GraynessBackground"))
				?? NSColor.textBackgroundColor)
			.usingColorSpace(.deviceGray)!.whiteComponent
		let fval = (NSColor(named: NSColor.Name("GraynessForeground"))
			?? NSColor.textColor)
			.usingColorSpace(.deviceGray)!.whiteComponent
		
		
		print (bval, fval)
		return (((1-gray) - bval) / (fval - bval))
		//return gray
	}
	
	
	func resetGrayCGImage() {
		let width = image.size.width
		let height = font.height(of: measurmentLine)
		let colorspace = CGColorSpaceCreateDeviceGray()// CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
		if let context = CGContext(data: nil,
								   width: Int(width),
								   height: Int(height),
								   bitsPerComponent: 8,
								   bytesPerRow: 0,
								   space: colorspace,
								   bitmapInfo: bitmapInfo.rawValue) {
			let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
			graphicsContext.saveGraphicsState()
			NSGraphicsContext.current = graphicsContext
			context.setFillColor(gray: uiGray(CGFloat(grayness)), alpha: 1)
			
			context.fill(NSMakeRect(0, 0, width, height))
			
			
			
			graphicsContext.restoreGraphicsState()
			
			grayCGImage = context.makeImage()
		} else {
			grayCGImage = nil
		}
	}
	
	func resetGlyphsCGImage() {
		var images = [(width:Int, gray:CGFloat)]()
		for i in 0..<string.count {
			if let pic = string.renderImage(to: measurmentLine, attributes: attributes, from: i, glyps: 1) {
				
				images.append((width: pic.width, gray:CGFloat(pic.overralGrayness())))
				
			}
		}
		
		let width = images.reduce(into:0, {$0+=$1.width})
		let height = Int(font.height(of: measurmentLine))
		let colorspace = CGColorSpaceCreateDeviceGray()// CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
		
		if let context = CGContext(data: nil,
								   width: width,
								   height: height,
								   bitsPerComponent: 8,
								   bytesPerRow: 0,
								   space: colorspace,
								   bitmapInfo: bitmapInfo.rawValue) {
			let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
			graphicsContext.saveGraphicsState()
			NSGraphicsContext.current = graphicsContext
			
			let minGray: CGFloat = images.min(by: {$0.gray < $1.gray && $0.gray != 0 })?.gray ?? 0.0
			let maxGray: CGFloat = images.max(by: {$0.gray < $1.gray})?.gray ?? 1.0
			let averageGray: CGFloat = images.reduce(into: 0, {$0 = $0+$1.gray}) / CGFloat(images.count)
			
			var x:CGFloat = 0.0
			for image in images {
				context.setFillColor(gray: uiGray(CGFloat(image.gray == 0 ? averageGray : image.gray)), alpha: 1)
				context.fill(NSMakeRect(x, 0, CGFloat(image.width), font.height(of: measurmentLine)))
				let amplified: CGFloat = minGray == maxGray ? 0 : (CGFloat(image.gray) - minGray) / (maxGray-minGray)
				context.setFillColor(gray: uiGray(amplified), alpha: 1)
				context.fill(NSMakeRect(x, 0, CGFloat(image.width), 1))
				
				x += CGFloat(image.width)
			}
			
			
			graphicsContext.restoreGraphicsState()
			
			glyphsCGImages = context.makeImage()
			
		} else {
			glyphsCGImages = nil
		}
	}
	
	
	
	func resetCGImage() {
		willChangeValue(for: \GraynessController.grayness)
		lineCgImage = string.renderImage(to: measurmentLine,
										 attributes:attributes)
		didChangeValue(for: \GraynessController.grayness)
	}
	
	
	@objc var graysImage: NSImage {
		if let cgImage = glyphsCGImages {
			return NSImage(cgImage: cgImage, size: CGSize.zero)
		} else {
			return NSImage(size: CGSize.zero)
		}
	}
	
	@objc var image: NSImage {
		if let cgImage = lineCgImage {
			return NSImage(cgImage: cgImage, size: CGSize.zero)
		} else {
			return NSImage(size: CGSize.zero)
		}
	}
	
	@objc var grayImage: NSImage {
		if let cgImage = grayCGImage {
			return NSImage(cgImage: cgImage, size: CGSize.zero)
		} else {
			return NSImage(size: CGSize.zero)
		}
	}
}
