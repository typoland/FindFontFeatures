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
    @IBOutlet weak var fontsArrayController: FontsArrayController!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainController.willChangeValue(for: \FFFeaturesController.allFonts)
        fontsArrayController.willChangeValue(for: \FontsArrayController.arrangedObjects)
        fontsArrayController.familyNamesArrayController.willChangeValue(for: \FontsArrayController.arrangedObjects)
        mainController.add(fontNames: ["Lato", "Lato-Bold","Clan", "Clan-Bold", ".SFNSDisplay-Black"], size: 12)
        fontsArrayController.didChangeValue(for: \FontsArrayController.arrangedObjects)
        mainController.didChangeValue(for: \FFFeaturesController.allFonts)
        fontsArrayController.familyNamesArrayController.didChangeValue(for: \FontsArrayController.arrangedObjects)

        print (mainController)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

