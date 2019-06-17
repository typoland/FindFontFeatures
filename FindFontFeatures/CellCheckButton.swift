//
//  CellCheckButton.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 13/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import AppKit
import OTFKit

class CellCheckButton: NSTableCellView {
    
    @IBOutlet weak var checkButton:NSButton!
    
    override func viewWillDraw() {
        if objectValue is FFFType{
            checkButton.allowsMixedState = true
        }
    }
    
}
