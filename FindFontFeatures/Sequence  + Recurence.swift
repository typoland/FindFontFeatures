//
//  Sequence  + Recurence.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 11/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
//* Returns array from trees

public extension Sequence {
    func recurence <T> (
        into: T,
        process: @escaping (_ e: [Element]) -> T,
        convert: @escaping (_ index: Int, _ e:Element) -> Element = {_, e in return e} )
        -> Array<T> {
            
            var result = Array<T>()
            
            func deep (i: Int = 0, source :[Element] = []) {
                if i < self.underestimatedCount {
                    for element in self {
                        deep(
                            i: i + 1,
                            source: source + [convert(i, element)]
                        )
                    }
                } else {
                    result.append( process ( source ))
                }
            }
            deep ()
            return result
    }
}
