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
  @State private var isPlaying = false

  var body: some View {
    VStack {
      Form {
        TextField("Name", text: $textFieldContents, onEditingChanged: { _ in
          store.updateName(for: subItem, itemId: itemId, to: textFieldContents)
        })
      }
      .onAppear(perform: loadItemText)

      ZStack {
        Circle().fill(Color.orange)
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
          .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
          .padding(.all, 8)
      }
      .frame(width: 44, height: 44, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .onAppear(perform: loadPlayState)
      .onTapGesture {
        store.toggleSubItem(for: subItem, itemId: itemId)
        isPlaying.toggle()
      }
    }
  }

  func loadItemText() {
    textFieldContents = subItem.name
  }

  func loadPlayState() {
    isPlaying = subItem.isPlaying
  }
}

struct SubDetailView_Previews: PreviewProvider {
  static var store = AppDataStore()
  static var previews: some View {
    SubDetailView(store: store, itemId: store.items.first!.id, subItem: store.items.first!.subItems.first!)
  }
}
