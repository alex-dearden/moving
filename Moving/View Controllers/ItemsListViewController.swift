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
    @IBOutlet private weak var slider: Slider!
    
    var roomStore: RoomStore!
    weak var coordinator: MainCoordinator?
    var room: Room!

    private var cancellable: AnyCancellable?
    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLongPress()
        setUpDataSource()
        setupItems()
    }

    private func setupItems() {
        title = "Items in " + room.name
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

private extension ItemsListViewController {
    func setUpDataSource()  {
        dataSource = DataSource(tableView: tableview,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.itemCell, for: indexPath) as! ListCellView
                cell.update(with: item.name, checked: item.checked)

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
        setSliderValueFromPercentage()

        // TODO: This shouldn't be necessary. Docs say not to call the old UITableView APIs but I can't get the cell to update with the toggle without it
        tableview.reloadData()
    }

    private func setSliderValueFromPercentage() {
        let sliderValue = Float(room.percentage)
        debugPrint("Set slider value to", sliderValue, "percent")
        slider.setValue(sliderValue, animated: true)
    }
}

extension ItemsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = room.items[safe: indexPath.row] else {
            return
        }
        roomStore.toggleItem(item, in: room)
        room.updatePercentage()
        setSliderValueFromPercentage()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, completion) in
            guard let self = self else {
                return
            }
            let indexSet: IndexSet = IndexSet(integer: indexPath.row)
            self.roomStore.deleteItem(at: indexSet, in: self.room)
            self.dataSource.tableView(self.tableview, commit: .delete, forRowAt: indexPath)
            completion(true)
        }

        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, _, completion) in
            guard let self = self,
              let room = self.room,
              let item = self.room.items[safe: indexPath.row] else {
                assertionFailure("No valid room or item")
                return
            }

            self.coordinator?.editItem(item: item, in: room, for: self.roomStore)
            completion(true)
        }

        edit.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}

// MARK: Long press

extension ItemsListViewController {
    private func setupLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1.0
        tableview.addGestureRecognizer(longPress)
    }

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableview)
            if let indexPath = tableview.indexPathForRow(at: touchPoint) {
                guard let item = room.items[safe: indexPath.row] else {
                    return
                }

                coordinator?.editItem(item: item, in: room, for: roomStore)
            }
        }
    }
}

extension ItemsListViewController: Storyboarded { }
