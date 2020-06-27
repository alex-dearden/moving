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
        navigationController.pushViewController(vc, animated: false)
    }

    func editRoom(_ room: Room) {
        let vc = EditRoomViewController.instantiate()
        vc.coordinator = self
        vc.room = room
        navigationController.pushViewController(vc, animated: false)
    }

    func listItems(for room: Room) {
        let vc = ItemsListViewController.instantiate()
        vc.coordinator = self
        vc.room = room
        navigationController.pushViewController(vc, animated: false)
    }
}