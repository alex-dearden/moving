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
    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDataSource()
        setupItems()
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

    class DataSource: UITableViewDiffableDataSource<Section, Item> {
        var parentClass: ItemsListViewController!

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
                    let indexSet = IndexSet(integer: indexPath.row)
                    parentClass.roomStore.deleteItem(at: indexSet, in: parentClass.room)
                }
            }
        }
    }
}

// MARK: Diffable data source

extension ItemsListViewController {
    func setUpDataSource()  {
        dataSource = DataSource(tableView: tableview,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.itemCell, for: indexPath) as! ListCellView
                cell.update(with: item.name)

                return cell
            })
        dataSource.parentClass = self
        tableview.dataSource = dataSource
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

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, completion) in
//            guard let self = self else {
//                return
//            }
//            let indexSet: IndexSet = IndexSet(integer: indexPath.row)
//            self.roomStore.deleteItem(at: indexSet, in: self.room)
//            self.tableview.deleteRows(at: [indexPath], with: .fade)
//            completion(true)
//        }
//
//        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, _, completion) in
//            guard let self = self,
//                let room = self.room else {
//                assertionFailure("No valid room")
//                return
//            }
//
//            let item = self.room.items[indexPath.row]
//            self.coordinator?.editItem(item: item, in: room, for: self.roomStore)
//            completion(true)
//        }
//
//        edit.backgroundColor = .systemBlue
//
//        return UISwipeActionsConfiguration(actions: [delete, edit])
//    }

}

extension ItemsListViewController: Storyboarded { }
