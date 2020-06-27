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
    var room: Room?

    private var selectedRoomType: RoomType!
    private var isEdit = false {
        didSet {
            setButtonTitle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        update()
    }

    private func update() {
        guard let room = room else {
            return
        }

        isEdit = true

        nameTextField.text = room.name
        let roomTypeIndex = RoomType.allCases.firstIndex { $0.name == room.type.name } ?? 0
        roomTypePicker.selectRow(roomTypeIndex, inComponent: 0, animated: false)
    }

    private func setupUI() {
        nameTextField.becomeFirstResponder()
        editRoomButton.setTitle(Defaults.addRoom, for: .normal)
        roomTypePicker.delegate = self
        roomTypePicker.dataSource = self
        selectedRoomType = RoomType.allCases.first
    }

    private func setButtonTitle() {
        let title = isEdit ? Defaults.editRoom : Defaults.addRoom
        editRoomButton.setTitle(title, for: .normal)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // TODO: Error handling to show message saying room name cannot be empty
        guard let newName =  nameTextField.text else {
            return
        }

        if isEdit {
            editRoom()
        } else {
            addRoom(name: newName)
        }

        dismiss()
    }

    private func editRoom() {
        // TODO: Error handling to show message saying room name cannot be empty
        guard let validName = nameTextField.text,
            var room = room else {
            return
        }
        room.name = validName
        room.type = selectedRoomType
        roomStore.editRoom(room)
    }

    private func addRoom(name: String) {
        let newOrder = roomStore.rooms.count
        let newRoom = Room(name: name, order: newOrder, type: selectedRoomType)
        roomStore.addRoom(newRoom)
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
