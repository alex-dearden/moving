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

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.roomStore.deleteRoom(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .fade)
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.coordinator?.editRoom(room: self.roomStore.rooms[indexPath.row], in: self.roomStore)
        }

        edit.backgroundColor = .systemBlue

        return [delete, edit]
    }
}

extension RoomsListViewController: Storyboarded { }
