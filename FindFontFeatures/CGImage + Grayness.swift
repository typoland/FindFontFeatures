//
//  CGImage + Grayness.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 06/07/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

public extension CGImage {
	
	func overralGrayness () -> Double {
		
		let totalBytes = self.height * self.bytesPerRow
		let colorSpace = CGColorSpaceCreateDeviceGray()
		var intensities = [UInt8](repeating: 0, count: totalBytes)
		let contextRef = CGContext(data: &intensities,
								   width: self.width,
								   height: self.height,
								   bitsPerComponent: self.bitsPerComponent,
								   bytesPerRow: self.bytesPerRow,
								   space: colorSpace,
								   bitmapInfo: 0)
		contextRef?.draw(self, in: CGRect(x: 0.0, y: 0.0,
										  width: CGFloat(width),
										  height: CGFloat(height)))
		
		// Add up all the pixel intensities
		var total = 0.0
		for byte in intensities {
			total += Double(byte) / 255.0
		}
		
		let pixelsNumber = self.width * self.height
		let grayness = total / Double(pixelsNumber)
		return grayness
	}
}
