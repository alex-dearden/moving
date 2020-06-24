//
//  ListView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct RoomListView: View {
    // TODO: Make dynamic with Cobine
    @State var rooms: [Room] = TestRooms().rooms
    
    @State private var isEditMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List  {
                ForEach(rooms) { room in
                    HStack {
                        Text(room.name)
                        Text("(\(room.type.name))")
                            .font(.footnote)
                        room.type.icon
                    }
                }
            }
        }
        .navigationBarTitle("Rooms")
        .environment(\.editMode, self.$isEditMode)
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView()
    }
}

struct TestRooms {
    let rooms: [Room] = [
        Room(name: "Bedroom", order: 1, type: .bedroom),
        Room(name: "Bathroom", order: 2, type: .bathroom),
        Room(name: "TV Room", order: 3, type: .livingRoom)
    ]
}

