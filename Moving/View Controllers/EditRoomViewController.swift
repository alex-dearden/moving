//
//  EditRoomView.swift
//  Moving
//
//  Created by Alex Dearden on 26/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class EditRoomViewController: UIViewController {

    // TODO: Create a single view for item and room and add them to their respective controllers
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var roomTypePicker: UIPickerView!
    @IBOutlet weak var editRoomButton: UIButton!
    
    weak var coordinator: MainCoordinator?
    var roomStore: RoomStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func update(from room: Room) {
        editRoomButton.setTitle(Defaults.editRoom, for: .normal)
        nameTextField.text = room.name
        // TODO: Implement this picker selection
        roomTypePicker.selectedRow(inComponent: 3)
    }

    private func setupUI() {
        editRoomButton.setTitle(Defaults.addRoom, for: .normal)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // TODO: Error handling to show message saying room name cannot be empty
        guard let newName =  nameTextField.text else {
            return
        }

        let newOrder = roomStore.rooms.count
        // TODO: Set selected picker value
        let newRoom = Room(name: newName, order: newOrder, type: .other)
        roomStore.addRoom(newRoom)
        dismiss()
    }
}

private extension EditRoomViewController {
    enum Defaults {
        static let editRoom = "Edit room"
        static let addRoom = "Add room"
    }
}

extension EditRoomViewController: Storyboarded { }
