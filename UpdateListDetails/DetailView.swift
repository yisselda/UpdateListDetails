//
//  DetailView.swift
//  UpdateListDetails
//
//  Created by Yisselda Rhoc on 3/11/21.
//

import SwiftUI

struct DetailView: View {
  @ObservedObject var store: AppDataStore
  var item: MyItem
  @State private var textFieldContents = ""

  var body: some View {
    return VStack {
      Form {
        TextField("Name", text: $textFieldContents, onEditingChanged: { _ in
          self.store.updateName(for: item, to: self.textFieldContents)
        })
      }
      .onAppear(perform: loadItemText)
      Divider()
      List {
        ForEach(item.subItems) { sub in
          NavigationLink(
            destination: SubDetailView(store: store, itemId: item.id, subItem: sub),
            label: {
              Text(sub.name).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
              ZStack {
                Circle().fill(sub.isPlaying ? Color.orange : Color.red)
                Image(systemName: sub.isPlaying ? "pause.fill" : "play.fill")
                  .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  .frame(width: 44, height: 44, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                  .onTapGesture {
                    store.toggleSubItem(for: sub, itemId: item.id)
                  }
              }
            })
          }
        .onDelete(perform: { indexSet in
          store.deleteSubItem(itemId: item.id, at: indexSet)
        })
        .onMove(perform: { indices, newOffset in
          store.moveSubItem(itemId: item.id, indices: indices, newOffset: newOffset)
        })
      }.toolbar {
        EditButton()
      }

      Button("Add Sub Item", action: { store.addSubItem(itemId: item.id) })
    }
  }

  func loadItemText() {
    textFieldContents = item.name
  }
}

struct DetailView_Previews: PreviewProvider {
  static var store = AppDataStore()
  static var previews: some View {
    NavigationView {
      DetailView(store: store, item: store.items.first!)
    }
  }
}
