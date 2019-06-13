//
//  Tree Protocol.swift
//  LoadFontsFromDisk
//
//  Created by Łukasz Dziedzic on 12/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

protocol TreeProtocol {
    associatedtype Branch: TreeProtocol
    associatedtype Leaf: Any
    var branch: [Branch] {get set}
    var leaf: Leaf {get set}
}

extension TreeProtocol {
    var leafs: [Leaf] {
        var result = [self.leaf]
        func nextBranch (level:Int, source: Branch) {
            for branch in source.branch {
                nextBranch (level: level+1, source: branch as! Branch)
            }
            result.append(source.leaf as! Leaf)
        }
        self.branch.forEach({nextBranch(level: 0, source: $0)})
        return result
    }
}
