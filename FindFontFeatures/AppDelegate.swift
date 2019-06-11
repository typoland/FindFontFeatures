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
    @IBOutlet weak var mainController: FFFeaturesController!
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
        var fonts = [NSFont]()
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { (result) -> Void in
            
            if result == NSApplication.ModalResponse.OK {
                for url in openPanel.urls {
                    var isDirectory: ObjCBool = ObjCBool(false)
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
                        do {
                            if let files = try? fileManager.contentsOfDirectory(atPath: url.path) {
                                for file in files {
                                    let filePath = url.path + "/" + file
                                    if let font = try? NSFont.read(from: filePath, size: 12) {
                                        fonts.append(font)
                                    }
                                }
                            }
                        }
                    } else {
                        if let font = try? NSFont.read(from: url.path, size: 12) {
                            fonts.append(font)
                        }
                    }
                    if !fonts.isEmpty {
                        self.mainController.clearContent()
                        self.mainController.add(fonts: fonts)
                    }
                }
            }
        }
        
                
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

