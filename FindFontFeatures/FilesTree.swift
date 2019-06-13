//
//  FilesInFolders.swift
//  LoadFontsFromDisk
//
//  Created by Łukasz Dziedzic on 12/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

class FilesTree: TreeProtocol {
    typealias Branch = FilesTree
    typealias Leaf  = [String]
    var branch: [Branch] = []
    var leaf: Leaf = []
    
    init (paths: [String]) throws {
        
        var isDirectory: ObjCBool = ObjCBool(false)
        let fileManager = FileManager.default
        for path in paths {
            if fileManager.fileExists(atPath: path, isDirectory: &isDirectory),
                let fileNames = try? fileManager.contentsOfDirectory(atPath: path) {
                let paths = fileNames.map {path+"/"+$0}
                if let ff = try? FilesTree(paths: paths) {
                    branch.append(ff)
                }
            } else {
                leaf.append(path)
            }
        }
    }
    
    var allFilePaths: [String] {
        return leafs.flatMap({$0})
    }
}
