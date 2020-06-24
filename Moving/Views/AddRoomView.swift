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

    @State private var name: String = ""
    @State private var type: RoomType = .other
    @State private var order: Int = 0

    var body: some View {

        Form {
            Section(header: Text("Room Details")) {
                Image(systemName: "bed.double.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                DataInput(title: "Name", userInput: $name)
                Picker(selection: $type, label: Text("Room type")) {
                    ForEach(RoomType.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
            }

            Button(action: addRoom) {
                Text("Add Room")
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
        roomStore.rooms.append(newRoom)
    }

}

struct AddRoomView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoomView(roomStore: RoomStore())
    }
}

struct DataInput: View {

    var title: String
    @Binding var userInput: String

    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            Text(title)
                .font(.headline)
            TextField("Enter \(title)", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
            .padding()
    }
}
