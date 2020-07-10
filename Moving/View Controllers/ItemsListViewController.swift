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
        cancellable = roomStore.$itemsForRoom.sink { [weak self] items in
            self?.update(with: items)
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.addItem(for: room, in: roomStore)
    }
}

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
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = room.items[indexPath.row]
        debugPrint("Item: ", item, "was selected")
    }
}

extension ItemsListViewController: Storyboarded { }
