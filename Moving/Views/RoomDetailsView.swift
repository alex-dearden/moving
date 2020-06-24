//
//  RoomDetailsView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct RoomDetailsView: View {
    let roomStore: RoomStore
    let selectedRoom: Room
    @State var items: [Item] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    ItemView(item: item)
                }
                .navigationBarTitle(selectedRoom.name)
                .navigationBarItems(
//                    leading: EditButton(),
                    trailing:
                    NavigationLink(destination: AddRoomView(roomStore: roomStore)) {
                        Text("Add")
                    }
                )
            }
        }

/*        VStack {
            Text(selectedRoom.name)
                .font(.title)
            Text("[\(selectedRoom.type.name)]")
                .font(.footnote)
            selectedRoom.type.icon
        }*/
    }
}

struct RoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailsView(roomStore: TestRooms(), selectedRoom: TestRooms().rooms[0])
    }
}

struct ItemView: View {
    let item: Item

    var body: some View {
        Text(item.name)
    }
}
