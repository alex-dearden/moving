//
//  AddItemView.swift
//  Moving
//
//  Created by Alex Dearden on 24/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
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

    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(room: TestRooms().rooms[0])
    }
}
