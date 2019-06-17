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
    //@IBOutlet weak var fontsArrayController: FontsArrayController!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        mainController.add(fontNames: ["Lato", "Lato-Bold", "Lato-Thin","Clan", "Clan-Bold", ".SFNSDisplay-Black"], size: 12)
    }
    
    @IBAction func getInstalledFonts(_ sender: Any) {
        mainController.clearContent()
        let fontNames = NSFontManager.shared.availableFonts
        mainController.add(fontNames: fontNames, size: 12)
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
                        if let font = try? NSFont.read(from: path, size: 12) {
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

