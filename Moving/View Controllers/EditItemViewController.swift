//
//  EditItemViewController.swift
//  Moving
//
//  Created by Alex Dearden on 27/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {

    @IBOutlet weak var editObjectContainer: EditObjectView!

    var room: Room?
    var roomStore: RoomStore!
    
    weak var coordinator: MainCoordinator?
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEditObjectContainer()
    }

    private func setupEditObjectContainer() {
        editObjectContainer.delegate = self
        editObjectContainer.updatePicker(RoomType.all)
    }

}

extension EditItemViewController: EditObjectViewDelegate {
    func edit(newName: String, newTypeName: String) {
        guard var item = item,
            let room = room else {
            return
        }

        item.name = newName
        item.type = ItemType.init(rawValue: newTypeName) ?? .other
        roomStore.editItem(item, in: room)
    }

    func add(name: String, typeName: String) {
        let newOrder = roomStore.rooms.count
        let newType = RoomType.init(rawValue: typeName)
        let newRoom = Room(name: name, order: newOrder, type: newType)
        roomStore.addRoom(newRoom)
    }

    func imageViewTapped() {
//        addImage()
    }
}


extension EditItemViewController: UIImagePickerControllerDelegate {
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
extension EditItemViewController: UINavigationControllerDelegate { }

extension EditItemViewController: Storyboarded { }