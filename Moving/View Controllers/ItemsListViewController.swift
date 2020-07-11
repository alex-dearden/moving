//
//  ListItemsViewController.swift
//  Moving
//
//  Created by Alex Dearden on 27/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit
import Combine

class ItemsListViewController: UIViewController {

    @IBOutlet private weak var tableview: UITableView!

    var roomStore: RoomStore!
    weak var coordinator: MainCoordinator?
    var room: Room!

    private var cancellable: AnyCancellable?
    private lazy var dataSource = setUpDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
        tableview.dataSource = dataSource
    }

    private func setupItems() {
        roomStore.update(for: room)
        cancellable = roomStore.$itemsForRoom.sink { [weak self] items in
            self?.update(with: items)
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.addItem(for: room, in: roomStore)
    }
}

// MARK: Diffable data source

extension ItemsListViewController {
    func setUpDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        return UITableViewDiffableDataSource(
            tableView: tableview,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.itemCell, for: indexPath) as! ItemListCell
                cell.configure(for: item)

                return cell
            })
    }

    func update(with items: [Item], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

extension ItemsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = room.items[indexPath.row]
        debugPrint("Item: ", item, "was selected")
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, completion) in
            guard let self = self else {
                return
            }
            let indexSet: IndexSet = IndexSet(integer: indexPath.row)
            self.roomStore.deleteItem(at: indexSet, in: self.room)
            self.tableview.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }

        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, _, completion) in
            guard let self = self,
                let room = self.room else {
                assertionFailure("No valid room")
                return
            }

            let item = self.room.items[indexPath.row]
            self.coordinator?.editItem(item: item, in: room, for: self.roomStore)
            completion(true)
        }

        edit.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

}

extension ItemsListViewController: Storyboarded { }
