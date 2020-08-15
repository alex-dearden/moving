//
// Created by Alex Dearden on 13/08/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var roomStore: RoomStore!

    private var itemsFound: [Item] = [] {
        didSet {
            debugPrint("Found:", itemsFound.count, "items")
            title = itemsFound.count == 0 ? Defaults.noItemsFoundString : Defaults.itemsFoundString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func searchItems(for searchString: String?) {
        guard let searchString = searchString,
            searchString != "" else {
            return
        }

        itemsFound = roomStore.findItems(with: searchString)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.roomCell, for: indexPath) as! ListCellView
        let item = itemsFound[indexPath.row]
        cell.update(with: item.name, checked: item.checked)
        return cell
    }
}

private extension SearchViewController {
    enum Defaults {
        static let noItemsFoundString = "No items found"
        static let itemsFoundString = "We found these items"
    }
}

extension SearchViewController: Storyboarded { }