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

    private var selectedRoomType: RoomType!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func update(from room: Room) {
        editRoomButton.setTitle(Defaults.editRoom, for: .normal)
        nameTextField.text = room.name
        let roomTypeIndex = RoomType.allCases.firstIndex { $0.name == room.type.name } ?? 0
        roomTypePicker.selectedRow(inComponent: roomTypeIndex)
    }

    private func setupUI() {
        nameTextField.becomeFirstResponder()
        editRoomButton.setTitle(Defaults.addRoom, for: .normal)
        roomTypePicker.delegate = self
        roomTypePicker.dataSource = self
        selectedRoomType = RoomType.allCases.first
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // TODO: Error handling to show message saying room name cannot be empty
        guard let newName =  nameTextField.text else {
            return
        }

        let newOrder = roomStore.rooms.count
        // TODO: Set selected picker value
        let newRoom = Room(name: newName, order: newOrder, type: selectedRoomType)
        roomStore.addRoom(newRoom)
        dismiss()
    }
}

extension EditRoomViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RoomType.allCases.count
    }
}

extension EditRoomViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        RoomType.allCases[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRoomType = RoomType.allCases[row]
    }
}

private extension EditRoomViewController {
    enum Defaults {
        static let editRoom = "Edit room"
        static let addRoom = "Add room"
    }
}

extension EditRoomViewController: Storyboarded { }
