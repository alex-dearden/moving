//
// Created by Alex Dearden on 26/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = RoomsListViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func addRoom(_ roomStore: RoomStore) {
        let vc = EditRoomViewController.instantiate()
        vc.coordinator = self
        vc.roomStore = roomStore
        navigationController.pushViewController(vc, animated: true)
    }

    func editRoom(room: Room, in roomStore: RoomStore) {
        let vc = EditRoomViewController.instantiate()
        vc.coordinator = self
        vc.roomStore = roomStore
        vc.room = room
        navigationController.pushViewController(vc, animated: true)
    }

    func listItems(for room: Room, in roomStore: RoomStore) {
        let vc = ItemsListViewController.instantiate()
        vc.coordinator = self
        vc.room = room
        vc.roomStore = roomStore
        navigationController.pushViewController(vc, animated: true)
    }

    func editItem(item: Item, in roomStore: RoomStore) {
        let vc = EditItemViewController.instantiate()
        vc.coordinator = self
        vc.roomStore = roomStore
        vc.item = item
        navigationController.pushViewController(vc, animated: true)
    }
}