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
        List {
          ForEach(store.items) { item in
            NavigationLink(
              destination: DetailView(store: store, itemId: item.id),
              label: {
                VStack(alignment: .leading) {
                  Text(item.name).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                  Text("\(item.subItems.count) subitems ")
                }
              })
          }
        }
      }
    }
  }
}

struct DetailView: View {
  @ObservedObject var store: AppDataStore
  var itemId: UUID

  var body: some View {
    let item = Binding<MyItem>(
      get: {
        store.getItem(itemId)
      },
      set: {
        store.updateItem(itemId, with: $0)
      }
    )

    return VStack {
      Text("Name: \(item.name.wrappedValue)")
      Divider()
      TextField("New Item Name", text: item.name)
        .padding(.horizontal, 60)
      Divider()
      List(item.subItems.wrappedValue) { sub in
        NavigationLink(
          destination: SubDetailView(store: store, itemId: itemId, subItemId: sub.id),
          label: {
            Text(sub.name)
          })
      }
    }
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
      Text("Name: \(subItem.name.wrappedValue)")
      Divider()
      TextField("New Subitem Name", text: subItem.name)
        .padding(.horizontal, 60)
      Divider()
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



struct Layers_Previews: PreviewProvider {
  static var store = AppDataStore()
  static var previews: some View {
    TopView()
    NavigationView {
      DetailView(store: store, itemId: store.items.first!.id)
    }
    SubDetailView(store: store, itemId: store.items.first!.id, subItemId: store.items.first!.subItems.first!.id)
  }
}
