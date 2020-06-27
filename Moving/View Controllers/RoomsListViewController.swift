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
    private var rooms: [Room] = []
    
    private var cancellable: AnyCancellable?

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        cancellable = roomStore.$rooms.sink { [weak self] rooms in
            self?.rooms = rooms
            self?.tableview.reloadData()
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }
    
}

extension RoomsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomListCell

        let room = rooms[indexPath.row]

        cell.configure(for: room)

        return cell
    }
}

extension RoomsListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]

        coordinator?.listItems(for: room)
    }
}

extension RoomsListViewController: Storyboarded { }
