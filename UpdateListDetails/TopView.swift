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
          .onDelete(perform: { indexSet in
            store.delete(at: indexSet)
          })
          .onMove(perform: { indices, newOffset in
            store.move(indices: indices, newOffset: newOffset)
          })
        }.toolbar {
          EditButton()
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
