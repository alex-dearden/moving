//
//  EditRoomView.swift
//  Moving
//
//  Created by Alex Dearden on 26/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class EditRoomViewController: UIViewController {

    @IBOutlet weak var editObjectContainer: EditObjectView!

    weak var coordinator: MainCoordinator?
    var roomStore: RoomStore!
    var room: Room?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEditObjectContainer()
    }

   private func setupEditObjectContainer() {
       editObjectContainer.delegate = self
       editObjectContainer.update(objectTitle: "Room", types: RoomType.all)
   }

    private func addImage() {
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
}

extension EditRoomViewController: EditObjectViewDelegate {
    func edit(newName: String, newTypeName: String) {
        guard var room = room else {
            return
        }

        room.name = newName
        room.type = RoomType.init(rawValue: newTypeName)
        roomStore.editRoom(room)
    }

    func add(name: String, typeName: String) {
        let newOrder = roomStore.rooms.count
        let newType = RoomType.init(rawValue: typeName)
        let newRoom = Room(name: name, order: newOrder, type: newType)
        roomStore.addRoom(newRoom)
    }

    func imageViewTapped() {
        addImage()
    }
}

extension EditRoomViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        var image: UIImage!

        // NOTE: Necessary to be able to test with simulator
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard let validImage = info[.editedImage] as? UIImage else {
                assertionFailure("No image found")
                return
            }

            image = validImage
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            guard let validImage = info[.originalImage] as? UIImage else {
                assertionFailure("Not a valid image")
                return
            }

            image = validImage
        }

        editObjectContainer.updateImage(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// Necessary for accessing photos or camera
extension EditRoomViewController: UINavigationControllerDelegate { }

extension EditRoomViewController: Storyboarded { }
