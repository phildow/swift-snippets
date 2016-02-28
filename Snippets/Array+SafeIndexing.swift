//
//  Array+SafeIndexing.swift
//  Snippets
//
//  Created by Philip Dow on 2/28/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}