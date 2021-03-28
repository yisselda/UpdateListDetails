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
  var subItem: MySubItem
  @State private var textFieldContents = ""

  var body: some View {
    Form {
      TextField("Name", text: $textFieldContents, onEditingChanged: { _ in
        self.store.updateName(for: self.subItem, itemId: itemId, to: self.textFieldContents)
      })
    }
    .onAppear(perform: loadItemText)
  }

  func loadItemText() {
    textFieldContents = subItem.name
  }
}

struct SubDetailView_Previews: PreviewProvider {
  static var store = AppDataStore()
  static var previews: some View {
    SubDetailView(store: store, itemId: store.items.first!.id, subItem: store.items.first!.subItems.first!)
  }
}
