//
//  SubDetailView.swift
//  UpdateListDetails
//
//  Created by Yisselda Rhoc on 3/11/21.
//

import SwiftUI

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

struct SubDetailView_Previews: PreviewProvider {
  static var store = AppDataStore()
  static var previews: some View {
    SubDetailView(store: store, itemId: store.items.first!.id, subItemId: store.items.first!.subItems.first!.id)
  }
}
