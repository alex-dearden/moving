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

    private var currentImage: UIImage?

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
        editObjectContainer.update(objectTitle: "Item", types: ItemType.all)

        // Editing
        if let item = item {
            editObjectContainer.edit(objectName: item.name, type: item.type.name, image: item.image?.getCodableImage())
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

extension EditItemViewController: EditObjectViewDelegate {
    func edit(newName: String, newTypeName: String) {
        guard var item = item,
            let room = room else {
            return
        }

        item.name = newName
        item.type = ItemType.init(rawValue: newTypeName) ?? .other

        if let _ = currentImage {
            item.image = currentImage.codableImage()
        }

        roomStore.editItem(item, in: room)
    }

    func add(name: String, typeName: String) {
        guard let room = room else {
            assertionFailure("Error: There is no room to add an item to")
            return
        }
        let newOrder = roomStore.rooms.count
        let newType = ItemType.init(rawValue: typeName) ?? .other
        let codableImage = currentImage.codableImage()
        let newItem = Item(name: name, order: newOrder, type: newType, image: codableImage, checked: false)
        roomStore.addItem(newItem, in: room)
    }

    func imageViewTapped() {
        addImage()
    }
}


extension EditItemViewController: UIImagePickerControllerDelegate {
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
extension EditItemViewController: UINavigationControllerDelegate { }

extension EditItemViewController: Storyboarded { }