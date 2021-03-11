//
//  ContentView.swift
//  UpdateListDetails
//
//  Created by Yisselda Rhoc on 3/10/21.
//
// Load from and save to userdefaults

import SwiftUI

struct TopView: View {
  @StateObject var store = AppDataStore()

  var body: some View {
    NavigationView {
      VStack {
        List(store.items) { item in
          NavigationLink(
            destination: DetailView(store: store, itemId: item.id),
            label: {
              Text(item.name)
            })
        }
      }
    }
  }
}

struct TopView_Previews: PreviewProvider {
  static var previews: some View {
    TopView()
  }
}

struct DetailView: View {
  @ObservedObject var store: AppDataStore
  var itemId: UUID

  var body: some View {
    let item = Binding<MyItem>(
      get: {
        store.items[store.items.firstIndex(where: { $0.id == self.itemId})!]
      },
      set: {
        store.updateItem(itemId: itemId, with: $0)
      }
    )

    return VStack {
      Text(item.name.wrappedValue)
      TextField("New Item Name", text: item.name)
      List(item.subItems.wrappedValue) { sub in
        NavigationLink(
          destination: SubDetailView(store: store, itemId: itemId, subItemId: sub.id),
          label: {
            Text(sub.name)
          })
      }
    }.padding(.horizontal, 60)
  }
}

struct SubDetailView: View {
  @ObservedObject var store: AppDataStore
  var itemId: UUID
  var subItemId: UUID

  var body: some View {
    let subItem = Binding<MySubItem>(
      get: {
        store.getSubItem(itemId: itemId, subItemId: subItemId)!
      },
      set: {
        store.updateSubItem(itemId: itemId, subItemId: subItemId, with: $0)
      }
    )

    return VStack {
      Text(subItem.name.wrappedValue)
      TextField("New Subitem Name", text: subItem.name)
    }.padding(.horizontal, 60)
  }
}


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

  func updateItem(itemId: UUID, with newItem: MyItem) {
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

struct MySubItem: Identifiable {
  var id = UUID()
  var name: String
}
