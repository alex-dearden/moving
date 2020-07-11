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
    private lazy var dataSource = setUpDataSource()

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRooms()
        tableview.dataSource = dataSource
    }

    private func setupRooms() {
        cancellable = roomStore.$rooms.sink { [weak self] rooms in
            self?.update(with: rooms)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.addRoom(roomStore)
    }
    
}


// MARK: Diffable Data Source

enum Section: CaseIterable {
    case main
}

extension RoomsListViewController {
    func setUpDataSource() -> UITableViewDiffableDataSource<Section, Room> {
        return UITableViewDiffableDataSource(
            tableView: tableview,
            cellProvider: { tableView, indexPath, room in
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.roomCell, for: indexPath) as! ListCellView
                cell.update(with: room.name, icon: room.type.icon)

                return cell
            })
    }

    func update(with rooms: [Room], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems(rooms, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: animate)
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
