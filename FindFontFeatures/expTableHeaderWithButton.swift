//
//  expTableHeaderWithButton.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 18/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
class expTableHeaderWithButton: NSTableHeaderView {
    @IBOutlet weak var mainController: MainController!
    @objc  var button: NSButton!
    
    override func awakeFromNib() {
        button = NSButton(checkboxWithTitle: "Fonts with feature", target: mainController, action: #selector(mainController.action(_:)))
        button.alignment = .right
        button.imagePosition = .imageRight
        button.controlSize = .small
        subviews.append(button)
    }

}
