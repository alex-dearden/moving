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
    
    @IBOutlet private weak var imageView: ImageContainer!
    @IBOutlet private weak var newItemLabel: UILabel!
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

    @objc private func addImage() {
        debugPrint("Get access to camera and take picture")
        let vc = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
            vc.allowsEditing = true
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            vc.sourceType = .savedPhotosAlbum
            vc.allowsEditing = false
        }
        vc.delegate = self
        present(vc, animated: true)
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

        setupTapGesture()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }

    private func setButtonTitle() {
        let title = isEdit ? Defaults.editRoom : Defaults.addRoom
        editRoomButton.setTitle(title, for: .normal)
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
        return RoomType.all.count
    }
}

extension EditRoomViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        RoomType.all[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRoomType = RoomType.allCases[row]
    }
}

extension EditRoomViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        var image: UIImage!

        // NOTE: Necessary to be able to test with simulator
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard let image = info[.editedImage] as? UIImage else {
                assertionFailure("No image found")
                return
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            guard let validImage = info[.originalImage] as? UIImage else {
                assertionFailure("Not a valid image")
                return
            }

            image = validImage
        }

        imageView.loadImage(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// Necessary for accessing photos or camera
extension EditRoomViewController: UINavigationControllerDelegate { }

private extension EditRoomViewController {
    enum Defaults {
        static let editRoom = "Edit room"
        static let addRoom = "Add room"
    }
}

extension EditRoomViewController: Storyboarded { }
