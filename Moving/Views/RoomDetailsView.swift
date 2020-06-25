//
//  RoomDetailsView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct RoomDetailsView: View {
    @ObservedObject var roomStore: RoomStore
    let selectedRoom: Room
    
    var body: some View {
        NavigationView {
            List {
                ForEach(selectedRoom.items) { item in
                    ItemCell(roomStore: self.roomStore, room: self.selectedRoom, item: item)
                }
                .navigationBarTitle(selectedRoom.name)
                .navigationBarItems(
//                    leading: EditButton(),
                    trailing:
                    NavigationLink(destination: AddItemView(roomStore: roomStore , room: selectedRoom)) {
                        Text("Add")
                    }
                )
            }
        }
    }
}

struct RoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailsView(roomStore: TestRooms(), selectedRoom: TestRooms().rooms[0])
    }
}

struct ItemCell: View {
    let roomStore: Storable
    let room: Room
    let item: Item

    var body: some View {
        NavigationLink(destination: AddItemView(roomStore: roomStore, room: room)) {
            HStack {
                Text(item.name)
            }
        }

    }
}
