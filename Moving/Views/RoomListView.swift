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
                    RoomListCell(room: room)
                }
            }
            .navigationBarTitle("Rooms")
            .environment(\.editMode, self.$isEditMode)
            .navigationBarItems(
                trailing:
                NavigationLink(destination: AddRoomView(roomStore: roomStore)) {
                    Image(systemName: "pencil.tip.crop.circle.badge.plus")
                }
            )
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView()
    }
}


struct RoomListCell: View {
    var room: Room
    var body: some View {
        HStack {
            room.type.icon
                .aspectRatio(contentMode: .fit)
            Text(room.name)
            Text("(\(room.type.name))")
                .font(.footnote)
        }
    }
}
