//
//  AddRoomView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI
import Combine

struct AddRoomView: View {
    @ObservedObject var roomStore: RoomStore

    @State var room: Room?

    @State var icon: Image = Image(systemName: "bed.double.fill")
    @State var name: String = ""
    @State var type: RoomType = .other
    @State var order: Int = 0

    private let persistenceManager: Persistenceable = PersistenceManager()

    init?(room: Room, forStore store: RoomStore) {
        self.roomStore = store
//        self.icon = room.type.icon
        self.name = room.name
        self.type = room.type
        self.order = room.order
    }

    init(roomStore: RoomStore) {
        self.roomStore = roomStore
    }

    private func setButtonText() -> String {
        return self.room != nil ? "Edit room" : "Add room"
    }

    var body: some View {

        Form {
            Section(header: Text("Room Details")) {
                self.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                DataInputView(title: "Name", userInput: $name)
                Picker(selection: $type, label: Text("Room type")) {
                    ForEach(RoomType.allCases, id: \.self) { room in
                        Text(room.name)
                    }
                }
            }

            Button(action: addRoom) {
                Text(self.setButtonText())
            }
        }
    }

    private func addRoom() {
        // TODO: Error handling to show message saying room name cannot be empty
        guard name != "" else {
            return
        }

        let newOrder = roomStore.rooms.count + 1
        let newRoom = Room(name: name, order: newOrder, type: type)
        roomStore.save(room: newRoom)
    }

}

struct AddRoomView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoomView(roomStore: RoomStore())
    }
}

