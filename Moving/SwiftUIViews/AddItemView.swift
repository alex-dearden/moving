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

    @State private var name: String = ""

    let existingItem: Item?

    init(roomStore: Storable, room: Room) {
        self.roomStore = roomStore
        self.room = room
        existingItem = nil
    }

    init(roomStore: Storable, room: Room, for item: Item) {
        self.roomStore = roomStore
        self.room = room
        existingItem = item
        self.name = item.name
    }

    var body: some View {
        Form {
            DataInputView(title: "Name", userInput: $name)

            Button(action: addOrEditItem) {
                Text(buttonTitle())
            }
        }
    }

    private func addOrEditItem() {
        let foundRoom = roomStore.rooms.first { $0.id == room.id }
        let newOrder = foundRoom?.items.count ?? 0
        let newItem = Item(name: name, order: newOrder)
        roomStore.addItem(newItem, in: room)
    }

    private func buttonTitle() -> String {
        return existingItem != nil ? "Save item" : "Add item"
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(roomStore: TestRooms(), room: TestRooms().rooms[0])
    }
}
