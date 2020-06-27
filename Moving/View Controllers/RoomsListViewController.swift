//
//  RoomsListViewController.swift
//  Moving
//
//  Created by Alex Dearden on 26/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit
import Combine

class RoomsListViewController: UIViewController {
    
    @IBOutlet private weak var tableview: UITableView!

    private var roomStore = RoomStore()

    private var cancellable: AnyCancellable?

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        cancellable = roomStore.$rooms.sink { [weak self] rooms in
            self?.tableview.reloadData()
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.addRoom(roomStore)
    }
    
}

extension RoomsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        roomStore.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomListCell

        let room = roomStore.rooms[indexPath.row]

        cell.configure(for: room)

        return cell
    }
}

extension RoomsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = roomStore.rooms[indexPath.row]

        coordinator?.listItems(for: room, in: roomStore)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, completion) in
            self?.roomStore.deleteRoom(at: indexPath.row)
            self?.tableview.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }

        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, _, completion) in
            guard let self = self else {
                assertionFailure("No valid room")
                return
            }
            let room = self.roomStore.rooms[indexPath.row]
            self.coordinator?.editRoom(room: room, in: self.roomStore)
            completion(true)
        }

        edit.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

}

extension RoomsListViewController: Storyboarded { }
