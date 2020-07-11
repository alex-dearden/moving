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
    private var dataSource: DataSource!

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDataSource()
        setupRooms()
    }

    private func setupRooms() {
        cancellable = roomStore.$rooms.sink { [weak self] rooms in
            self?.update(with: rooms)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.addRoom(roomStore)
    }

    class DataSource: UITableViewDiffableDataSource<Section, Room> {
        var parentClass: RoomsListViewController!

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    var snapshot = self.snapshot()
                    snapshot.deleteItems([identifierToDelete])
                    apply(snapshot)
                    parentClass.roomStore.deleteRoom(at: indexPath.row)
                }
            }
        }
    }

}


// MARK: Diffable Data Source

enum Section: CaseIterable {
    case main
}

extension RoomsListViewController {
    func setUpDataSource() {
        dataSource = DataSource(tableView: tableview,
            cellProvider: { tableView, indexPath, room in
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.roomCell, for: indexPath) as! ListCellView
                cell.update(with: room.name, icon: room.type.icon)

                return cell
            })
        dataSource.parentClass = self
        tableview.dataSource = dataSource
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

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, completion) in
//            self?.roomStore.deleteRoom(at: indexPath.row)
//            self?.tableview.deleteRows(at: [indexPath], with: .fade)
//            completion(true)
//        }
//
//        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, _, completion) in
//            guard let self = self else {
//                assertionFailure("No valid room")
//                return
//            }
//            let room = self.roomStore.rooms[indexPath.row]
//            self.coordinator?.editRoom(room: room, in: self.roomStore)
//            completion(true)
//        }
//
//        edit.backgroundColor = .systemBlue
//
//        return UISwipeActionsConfiguration(actions: [delete, edit])
//    }
}

extension RoomsListViewController: Storyboarded { }
