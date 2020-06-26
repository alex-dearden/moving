//
//  DataInputView.swift
//  Moving
//
//  Created by Alex Dearden on 26/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import SwiftUI

struct DataInputView: View {
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

struct DataInputView_Previews: PreviewProvider {
    static var previews: some View {
        DataInputView(title: "Name", userInput: .constant("Mofo"))
    }
}
