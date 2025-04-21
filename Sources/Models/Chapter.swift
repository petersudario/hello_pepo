//
//  Chapter.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import Foundation

struct Chapter: Identifiable {
    let id = UUID()
    let title: String
    let sections: [Section]
}
