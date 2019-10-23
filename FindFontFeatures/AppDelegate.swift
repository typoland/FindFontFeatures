//
//  AppDelegate.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Cocoa
import OTFKit

@NSApplicationMain


class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var mainController: MainController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		window.title = ""
        mainController.add(fontNames: ["Lato-Regular", "Lato-Bold", "Lato-Thin","Clan", "Clan-Bold", ".SFNSDisplay", "Decovar Alpha"], size: fontSize)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedFontsControllersChanged(_:)), name: Notification.Name.fontControllersSelectionChanged, object: nil)
		
    }
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
	var fontSize:CGFloat {
		return CGFloat(mainController.fontsArrayController.currentSize)
	}
	
    @objc func selectedFontsControllersChanged(_ notification:Notification) {
        mainController.willChangeValue(for: \MainController.typeControllers)
        SELECTED_FONTS_CONTROLLERS =  notification.object as! [FontController]
        mainController.didChangeValue(for: \MainController.typeControllers)
    }
	
	
	
    @IBAction func getInstalledFonts(_ sender: Any) {
        mainController.clearContent()
        mainController.add(fontNames: NSFontManager.shared.availableFonts, size: fontSize)
    }

    @objc func openDocument(_ sender:Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                var fonts: [NSFont] = []
                if let fontsPaths = try? FilesTree(
                    paths: openPanel.urls.map{$0.path}).allFilePaths {
                    
                    fontsPaths.forEach { path in
                        if let font = try? NSFont.read(from: path, size: self.fontSize) {
                            fonts.append(font)
                        }
                    }
                }
                self.mainController.clearContent()
                self.mainController.add(fonts: fonts)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

