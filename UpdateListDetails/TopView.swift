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

  var item: MyItem {
    store.items[store.items.firstIndex(where: { $0.id == itemId})!]
  }

  var body: some View {
    VStack {
      Text(item.name)
//      TextField("New Item Name", text: $item.name)
      List(item.subItems) { sub in
//        NavigationLink(
//          destination: SubDetailView(item: $item.subItems[item.subItems.firstIndex(where: { $0.id == sub.id})!] ),
//          label: {
            Text(sub.name)
//          })
      }
    }.padding(.horizontal, 60)
  }
}

struct SubDetailView: View {
  @Binding var item: MySubItem
  var body: some View {
    VStack {
      TextField("New Item Name", text: $item.name)
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

class MySubItem: Identifiable {
  var id = UUID()
  var name: String

  init(name: String) {
    self.name = name
  }
}
