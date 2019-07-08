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
	
	enum PreviewType: String {
		case grays = "Individual glyphs gray"
		case gray = "Overall line gray"
		case glyphs = "Rendered Glyphs"
		
		func toogle() -> PreviewType {
			switch self {
			case .glyphs: return .grays
			case .grays: return .gray
			case .gray: return .glyphs
			}
		}
		
	}
	
	@IBOutlet var fontsArrayController: FontsArrayController!
	//@IBOutlet weak var preview: NSImageView!
	@IBOutlet weak var textField: NSTextField!
	@IBOutlet weak var measurmentPopUpButton: NSPopUpButton!
	
	//var lineCgImage: CGImage?
	//var glyphsCGImages: CGImage?
	//var grayCGImage: CGImage?
	
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
		}
		didSet {
			didChangeValue(for: \GraynessController.image)
			didChangeValue(for: \GraynessController.font)
		}
		
	}
	
	var currentPreview: PreviewType = .grays {
		willSet{willChangeValue(for: \GraynessController.image)}
		didSet{didChangeValue(for: \GraynessController.image)}
	}
	
	
	override func awakeFromNib() {
		fontsArrayController.addObserver(self, forKeyPath: "currentFont", options: [.old, .new], context: nil)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		
		font = fontsArrayController.currentFontController?.font
		
		
	}
	
	@IBAction func tooglePreview(_ sender:Any) {
		currentPreview = currentPreview.toogle()
		print (currentPreview)
		
		
	}
	
	@objc var image:NSImage? {
		let image:CGImage?
		switch currentPreview {
		case .glyphs:
			image = glyphsCGImage
		case .gray:
			image = grayImage
		case .grays:
			image = lineImage
		}
		return image == nil ? nil : NSImage(cgImage: image!, size: NSSize.zero)
	}
	
	@objc func controlTextDidChange (_ notification:Notification) {
		guard let textField = notification.object as? NSTextField  else {return}
		changeString(textField)
	}
	
	@IBAction func changeString(_ sender:NSTextField) {
		stringToRender = sender.stringValue// stringValue
	}
	
	
	@IBAction func changeMeasurment(_ sender:NSPopUpButton) {
		guard let name = sender.selectedItem?.representedObject as? String,
			let mes = NSFont.VerticalMeasurment.init(rawValue: name)
			else {return}
		measurmentLine = mes
	}
	
	
	
	
	var attributes:[NSAttributedString.Key:Any] {
		return font == nil ? [:] : [NSAttributedString.Key.foregroundColor: fontColor,
									NSAttributedString.Key.font: font!]
	}
	
	@objc var fontColor: NSColor {
		return NSColor.white
	}
	
	@objc var measurmentItems: [String] {
		return NSFont.VerticalMeasurment.allCases.map({$0.rawValue})
	}
	
	
	
	override init() {
		super.init()
	}
	
	//	func setupGrayness() {
	//		textField.cell?.font = fontController?.font ?? NSFont.labelFont(ofSize: 12)
	//	}
	
	@objc var grayness: Double {
		return lineImage?.overralGrayness() ?? 0.0
	}
	
	func uiGray(_ gray:CGFloat) -> NSColor {
		//let bval = backgroundColorGray.whiteComponent
		//let fval = foregroundColorGray.whiteComponent
		return foregroundColorGray.withAlphaComponent(gray)
		//return (((1-gray) - bval) / (fval - bval))
		//return gray
	}
	
	var lineImage: CGImage? {
		
		return font == nil
			? nil
			: stringToRender.renderImage(
				to: measurmentLine,
				attributes:attributes)
	}
	
	
	var grayImage: CGImage? {
		if let image = lineImage, let font = font {
			let width = CGFloat(image.width)
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
				let color =  uiGray(CGFloat(grayness))
				context.setFillColor(gray: color.whiteComponent, alpha: color.alphaComponent)
				
				context.fill(NSMakeRect(0, 0, width, height))
				
				graphicsContext.restoreGraphicsState()
				
				return context.makeImage()
			}
		}
		return nil
	}
	
	var glyphsCGImage: CGImage? {
		if let font = font {
			var images = [(width:Int, gray:CGFloat)]()
			for i in 0..<stringToRender.count {
				if let pic = stringToRender.renderImage(to: measurmentLine, attributes: attributes, from: i, glyps: 1) {
					
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
					let foreground = uiGray(CGFloat(image.gray == 0 ? averageGray : image.gray))
					context.setFillColor(gray: foreground.whiteComponent, alpha: foreground.alphaComponent)
					context.fill(NSMakeRect(x, 0, CGFloat(image.width), font.height(of: measurmentLine)))
					let amplified: CGFloat = minGray == maxGray ? 0 : (CGFloat(image.gray) - minGray) / (maxGray-minGray)
					context.setFillColor(gray: uiGray(amplified).whiteComponent, alpha: uiGray(amplified).alphaComponent)
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
