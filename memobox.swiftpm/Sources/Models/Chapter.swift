//
//  Chapter.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

struct Chapter {
  let title: String
  let reference: String
  let modelName: String
  let soundFileName: String
  var contents: [ChapterContent]
}

enum ChapterContent {
  case text(text: String, audioFileName: String)
  case modelPreview
}
