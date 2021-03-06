//
//  AppDataStore.swift
//  UpdateListDetails
//
//  Created by Yisselda Rhoc on 3/11/21.
//

import Foundation

class AppDataStore: ObservableObject {
  @Published var items = [MyItem]()
  private var currentlyPlaying: (UUID, MySubItem)? = nil

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

  func addItem() {
    objectWillChange.send()
    items.append(MyItem(name: "new item \(items.count + 1)"))
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

  func addSubItem(itemId: UUID) {
    objectWillChange.send()
    if let i = items.firstIndex(where: { $0.id == itemId}) {
        items[i].subItems.append(MySubItem(name: "new sub \(items[i].subItems.count + 1)"))
    }
  }

  func updateName(for subItem: MySubItem, itemId: UUID, to name: String) {
    objectWillChange.send()
    if let i = items.firstIndex(where: { $0.id == itemId}) {
      if let s = items[i].subItems.firstIndex(where: { $0.id == subItem.id}) {
        items[i].subItems[s].name = name
      }
    }
  }

  func toggleSubItem(for subItem: MySubItem, itemId: UUID) {
    objectWillChange.send()
    if currentlyPlaying != nil {
      let (currentItemId, currentSubItem) = currentlyPlaying!
      if currentSubItem.id != subItem.id {
        if let i = items.firstIndex(where: { $0.id == currentItemId}) {
          if let s = items[i].subItems.firstIndex(where: { $0.id == currentSubItem.id}) {
            items[i].subItems[s].isPlaying = false
          }
        }
      }
    }

    if let i = items.firstIndex(where: { $0.id == itemId}) {
      if let s = items[i].subItems.firstIndex(where: { $0.id == subItem.id}) {
        items[i].subItems[s].isPlaying.toggle()
        if items[i].subItems[s].isPlaying {
          currentlyPlaying = (itemId, subItem)
        }
      }
    }
  }

  func updateName(for item: MyItem, to name: String) {
    objectWillChange.send()
    if let i = items.firstIndex(where: { $0.id == item.id}) {
      items[i].name = name
    }
  }

  func delete(at indexSet: IndexSet) {
    objectWillChange.send()
    for index in indexSet {
      items.remove(at: index)
    }
  }

  func move(indices: IndexSet, newOffset: Int) {
    objectWillChange.send()
    items.move(fromOffsets: indices, toOffset: newOffset)
  }

  func deleteSubItem(itemId: UUID, at indexSet: IndexSet) {
    objectWillChange.send()
    if let i = items.firstIndex(where: { $0.id == itemId}) {
      for index in indexSet {
        items[i].subItems.remove(at: index)
      }
    }
  }

  func moveSubItem(itemId: UUID, indices: IndexSet, newOffset: Int) {
    objectWillChange.send()
    if let i = items.firstIndex(where: { $0.id == itemId}) {
      items[i].subItems.move(fromOffsets: indices, toOffset: newOffset)
    }
  }
}
