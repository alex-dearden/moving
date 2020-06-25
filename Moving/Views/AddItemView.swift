//
//  AddItemView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    let roomStore: Storable
    let room: Room
    @State var name: String = ""

    var body: some View {
        Form {
            DataInput(title: "Name", userInput: $name)

            Button(action: addItem) {
                Text("Add item")
            }
        }
    }

    private func addItem() {
        let foundRoom = roomStore.rooms.first { $0.id == room.id }
        let newOrder = foundRoom?.items.count ?? 0
        let newItem = Item(name: name, order: newOrder)
        roomStore.addItem(newItem, in: room)
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(roomStore: TestRooms(), room: TestRooms().rooms[0])
    }
}
