//
//  FindFontFeaturesTests.swift
//  FindFontFeaturesTests
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import XCTest
@testable import OTFKit
@testable import FindFontFeatures

class FindFontFeaturesTests: XCTestCase {
	
	var fontNames: [String]! = ["Lato-Regular", "Lato-Bold", "Lato-Thin", "ClanSans", ".SFNSDisplay", "Decovar Alpha"]
	var mainController: MainController! = MainController()
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		
    }

    override func tearDown() {
		fontNames = nil
		mainController = nil
    }

    func testMainControllerContent() {
		
		for fontName in fontNames {
			mainController.add(fontNames: [fontName], size: 10)
			XCTAssertTrue( mainController.fontControllers.count == 1)
			let fontController = mainController.fontControllers[0]
			let featuresDescriptions:[OTFType<OTFSelector>] = fontController.featuresDescriptions
			
			let typeControllers = mainController.typeControllersSet
			
			let message = "\(fontController.font.fontName) FT:\(featuresDescriptions.count) != TC:\(typeControllers.count)"
			XCTAssert(typeControllers.count == featuresDescriptions.count, message)
			print ("\nSC:\(fontController.font.fontName),SCs:\(fontController.selectorControllers)")
			for typeController in typeControllers {
				print ("\t",typeController)
				typeController.selectorControllers.forEach({ sc in
					print ("\t\t\(sc)")
					sc.fonts.forEach({fc in
						print ("\t\t\tFC:\(fc.font.fontName)")
					})
				})
			}
			mainController.clearContent()
		}
	}
	


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
