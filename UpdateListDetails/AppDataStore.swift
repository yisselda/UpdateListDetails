//
//  AppDataStore.swift
//  UpdateListDetails
//
//  Created by Yisselda Rhoc on 3/11/21.
//

import Foundation

class AppDataStore: ObservableObject {
  @Published var items = [MyItem]()

  init() {
    items = [
      MyItem(name: "First"),
      MyItem(name: "2nd"),
      MyItem(name: "And another item")
    ]
  }

  func updateName(of item: MyItem, newName: String) {
    objectWillChange.send()
    item.name = newName
  }

  func getItem(_ itemId: UUID) -> MyItem {
    return items[items.firstIndex(where: { $0.id == itemId})!]
  }

  func updateItem(_ itemId: UUID, with newItem: MyItem) {
    objectWillChange.send()
    if let i = items.firstIndex(where: { $0.id == itemId}) {
      items[i] = newItem
    }
  }

  func getSubItem(itemId: UUID, subItemId: UUID) -> MySubItem? {
    if let i = items.firstIndex(where: { $0.id == itemId}) {
      if let s = items[i].subItems.firstIndex(where: { $0.id == subItemId}) {
        return items[i].subItems[s]
      }
    }

    return nil
  }

  func updateSubItem(itemId: UUID, subItemId: UUID, with newItem: MySubItem) {
    objectWillChange.send()
    if let i = items.firstIndex(where: { $0.id == itemId}) {
      if let s = items[i].subItems.firstIndex(where: { $0.id == subItemId}) {
        items[i].subItems[s] = newItem
      }
    }
  }
}
