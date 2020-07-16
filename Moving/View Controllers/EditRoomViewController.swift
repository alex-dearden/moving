//
//  EditRoomView.swift
//  Moving
//
//  Created by Alex Dearden on 26/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class EditRoomViewController: UIViewController {

    @IBOutlet private weak var editObjectContainer: EditObjectView!

    private var currentImage: UIImage?

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

       // Editing the room
       if let room = room {
           editObjectContainer.edit(objectName: room.name, type: room.type.name, image: room.image?.getCodableImage())
       }
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

        if let _ = currentImage {
            room.image = currentImage.codableImage()
        }

        roomStore.editRoom(room)
    }

    func add(name: String, typeName: String) {
        let newOrder = roomStore.rooms.count
        let newType = RoomType.init(rawValue: typeName)

        let codableImage = currentImage.codableImage()

        let newRoom = Room(name: name, order: newOrder, type: newType, image: codableImage)
        roomStore.addRoom(newRoom)
    }

    func imageViewTapped() {
        addImage()
    }
}

extension EditRoomViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        // NOTE: Necessary to be able to test with simulator
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard let validImage = info[.editedImage] as? UIImage else {
                assertionFailure("No image found")
                return
            }

            currentImage = validImage
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            guard let validImage = info[.originalImage] as? UIImage else {
                assertionFailure("Not a valid image")
                return
            }

            currentImage = validImage
        }

        editObjectContainer.updateImage(currentImage)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// Necessary for accessing photos or camera
extension EditRoomViewController: UINavigationControllerDelegate { }

extension EditRoomViewController: Storyboarded { }
