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
    private var searchViewController = SearchViewController.instantiate()
    private var searchController: UISearchController!
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLongPress()
        setUpDataSource()
        setupRooms()
        setupSearchResultsController()
    }

    private func setupRooms() {
        title = "Rooms"
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
                let percentage = room.percentage
                cell.update(with: room.name, percentage: percentage)

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

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, completion) in
            guard let self = self else {
                return
            }
            self.roomStore.deleteRoom(at: indexPath.row)
            self.dataSource.tableView(self.tableview, commit: .delete, forRowAt: indexPath)
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

// MARK: Search Controller
extension RoomsListViewController {
    private func setupSearchResultsController() {
        searchViewController.roomStore = roomStore
        searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchResultsUpdater = searchViewController
        searchController.obscuresBackgroundDuringPresentation = true // will obscure this controller's view since we're using a different view for the results
        searchController.searchBar.placeholder = "Search for items"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: Long press recogniser
extension RoomsListViewController {
    private func setupLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1.0
        tableview.addGestureRecognizer(longPress)
    }

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableview)
            if let indexPath = tableview.indexPathForRow(at: touchPoint) {
                guard let room = roomStore.rooms[safe: indexPath.row] else {
                    return
                }

                coordinator?.editRoom(room: room, in: roomStore)
            }
        }
    }
}

extension RoomsListViewController: Storyboarded { }
