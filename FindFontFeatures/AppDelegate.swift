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
        mainController.willChangeValue(for: \FFFeaturesController.allFonts)
        
        
        
        
        mainController.add(fontNames: ["Lato", "Lato-Bold", "Lato-Thin","Clan", "Clan-Bold", ".SFNSDisplay-Black"], size: 12)
        mainController.didChangeValue(for: \FFFeaturesController.allFonts)
        
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

