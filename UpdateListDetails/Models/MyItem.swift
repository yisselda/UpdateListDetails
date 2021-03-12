//
//  MyItem.swift
//  UpdateListDetails
//
//  Created by Yisselda Rhoc on 3/12/21.
//

import Foundation

class MyItem: ObservableObject, Identifiable {
  var id = UUID()
  var name: String
  @Published var subItems = [MySubItem]()

  init(name: String) {
    self.name = name
    subItems = [
      MySubItem(name: "Sub Name"),
      MySubItem(name: "2nd Sub Name"),
      MySubItem(name: "And another subitem")
    ]
  }
}
