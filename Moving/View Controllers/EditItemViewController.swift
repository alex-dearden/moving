//
//  EditItemViewController.swift
//  Moving
//
//  Created by Alex Dearden on 27/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {
    
    @IBOutlet private weak var itemTextField: UITextField!
    @IBOutlet private weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var addItemButton: UIButton!

    var room: Room?
    var roomStore: RoomStore!
    
    weak var coordinator: MainCoordinator?
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension EditItemViewController: Storyboarded { }