//
// Created by Alex Dearden on 13/08/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var roomStore: RoomStore!

    @IBOutlet private var tableview: UITableView!

    private var itemsFound: [Item] = [] {
        didSet {
            debugPrint("Found:", itemsFound.count, "items")
            title = itemsFound.count == 0 ? Defaults.noItemsFoundString : Defaults.itemsFoundString
        }
    }

    private func searchItems(for searchString: String?) {
        guard let searchString = searchString,
            searchString != "" else {
            return
        }

        itemsFound = roomStore.findItems(with: searchString)
        tableview.reloadData()
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        debugPrint("updateSearchResults called for term:", searchString)
        searchItems(for: searchString)
    }
}

extension SearchViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsFound.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.searchResultsCell, for: indexPath) as! ListCellView
        let item = itemsFound[indexPath.row]
        cell.update(with: item.name, checked: item.checked)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsFound[indexPath.row]
        guard let roomForItem = (roomStore.rooms.first { $0.items.contains(item) }) else {
            return
        }

        debugPrint("roomForItem", item.name, "is", roomForItem.name)

        coordinator?.listItems(for: roomForItem, in: roomStore)
    }
}

private extension SearchViewController {
    enum Defaults {
        static let noItemsFoundString = "No items found"
        static let itemsFoundString = "We found these items"
    }
}

extension SearchViewController: Storyboarded { }