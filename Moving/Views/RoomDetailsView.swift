//
//  RoomDetailsView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct RoomDetailsView: View {
    let selectedRoom: Room
    
    var body: some View {
        VStack {
            Text(selectedRoom.name)
                .font(.title)
            Text("[\(selectedRoom.type.name)]")
                .font(.footnote)
            selectedRoom.type.icon
        }
    }
}

struct RoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailsView(selectedRoom: TestRooms().rooms[0])
    }
}
