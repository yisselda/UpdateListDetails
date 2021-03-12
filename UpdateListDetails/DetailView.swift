//
//  DetailView.swift
//  UpdateListDetails
//
//  Created by Yisselda Rhoc on 3/11/21.
//

import SwiftUI

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
      List {
        ForEach(item.subItems.wrappedValue) { sub in
          NavigationLink(
            destination: SubDetailView(store: store, itemId: itemId, subItemId: sub.id),
            label: {
              Text(sub.name)
            })
        }
        .onDelete(perform: { indexSet in
          store.deleteSubItem(itemId: itemId, at: indexSet)
        })
      }
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var store = AppDataStore()
  static var previews: some View {
    NavigationView {
      DetailView(store: store, itemId: store.items.first!.id)
    }
  }
}
