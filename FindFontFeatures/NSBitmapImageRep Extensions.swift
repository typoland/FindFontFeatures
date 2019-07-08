//
//  NSBitmapImageRep Extensions.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 06/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit

//public extension NSBitmapImageRep {
//	enum ColorMode {
//		case grayscale
//		case rgb, hsv
//		case rgba, hsva, cmyk
//		case custom (bitsPerSample:Int,
//			samples:Int,
//			hasAlpha:Bool,
//			isPlanar:Bool,
//			colorSpaceName: NSColorSpaceName,
//			bitmapFormat: NSBitmapImageRep.Format,
//			bitsPerPixel: Int
//		)
//		
//		var bytes:Int {
//			switch self {
//			case .grayscale: return 1
//			case .rgb, .hsv: return 3
//			case .cmyk, .rgba, .hsva: return 4
//			case .custom (let custom): return custom.samples
//			}
//		}
//		
//		var hasAlpha: Bool {
//			switch self {
//			case .rgba, .hsva:
//				return true
//			case .custom (let custom): return custom.hasAlpha
//			default:
//				return false
//			}
//		}
//		
//		var isPlanar: Bool {
//			switch self {
//			case .custom (let custom): return custom.isPlanar
//			default:
//				return false
//			}
//		}
//		
//		var colorSpaceName: NSColorSpaceName {
//			switch self {
//			case .grayscale: return .deviceWhite
//			case .rgb, .rgba: return .deviceRGB
//			case .cmyk: return .deviceCMYK
//			default: return .custom
//			}
//		}
//		
//		func pixels (width:Int, height:Int) -> UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>? {
//			return UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: width * height * self.bytes)
//		}
//	}
//	
//	convenience init (_ colorMode: ColorMode, width:Int, height:Int ) {
//		print (colorMode.bytes)
//		self.init(
//			bitmapDataPlanes: colorMode.pixels(width: width, height: height)!,
//			pixelsWide: width,
//			pixelsHigh: height,
//			bitsPerSample: 8,
//			samplesPerPixel: colorMode.bytes,
//			hasAlpha: colorMode.hasAlpha,
//			isPlanar: colorMode.isPlanar,
//			colorSpaceName: colorMode.colorSpaceName,
//			bitmapFormat: NSBitmapImageRep.Format.alphaNonpremultiplied,
//			bytesPerRow: width,
//			bitsPerPixel: colorMode.bytes * 8)!
//	}
//	
//	var nsImage: NSImage {
//		if let cgImage = self.cgImage {
//			let image = NSImage(cgImage: cgImage, size: self.size)
//			return image
//		}
//		return NSImage(size: self.size)
//	}
//	
//	func overralGrayness () -> CGFloat {
//		
//		var total: CGFloat = 0
//		
//		//        for y in 0 ..< Int(self.size.height) {
//		//            for x in 0 ..< Int(self.size.width) {
//		//                var value: [Int] = Array(repeating: 0, count: samplesPerPixel )
//		//                //var value: Int = 0
//		//                self.getPixel(&value, atX: x, y: y) // explodes here
//		//                let pixelValue = CGFloat( value.reduce(into: 0, {$0 += $1})) / CGFloat(samplesPerPixel)
//		//                //let pixelValue = CGFloat(value)
//		//                total = total + pixelValue / 256.0
//		//            }
//		//        }
//		
//		let pixelsNumber = size.width * size.height
//		print ("grayness Total: \(total), pixels: \(pixelsNumber), average: \(total / pixelsNumber)")
//		return total / pixelsNumber
//	}
//}
