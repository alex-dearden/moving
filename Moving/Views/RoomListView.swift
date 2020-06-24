//
//  ListView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct RoomListView: View {
    @ObservedObject var roomStore : RoomStore = RoomStore()
    
    @State private var isEditMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List  {
                ForEach(roomStore.rooms) { room in
                    RoomListCell(roomStore: self.roomStore, room: room)
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
            .navigationBarTitle("Rooms")
            .environment(\.editMode, self.$isEditMode)
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                NavigationLink(destination: AddRoomView(roomStore: roomStore)) {
                    Text("Add")
                }
            )
        }
    }
    
    func deleteItems(at offets: IndexSet) {
        roomStore.rooms.remove(atOffsets: offets)
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        roomStore.rooms.move(fromOffsets: source, toOffset: destination)
    }
}
    

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(roomStore: TestRooms())
    }
}


struct RoomListCell: View {
    let roomStore: RoomStore
    var room: Room

    var body: some View {
        // TODO: We only have a singl RoomStore, why pass it? Set it wherever it's needed
        NavigationLink(destination: AddRoomView(room: room, forStore: roomStore)) {
            HStack {
                room.type.icon
                    .aspectRatio(contentMode: .fit)
                Text(room.name)
                Text("(\(room.type.name))")
                    .font(.footnote)
            }
        }
    }
}
