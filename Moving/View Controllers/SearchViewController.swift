//
// Created by Alex Dearden on 13/08/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    var searchString: String?
    var coordinator: Coordinator?
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

    private func searchItems() {
        guard let searchString = searchString else {
            return
        }

        itemsFound = roomStore.findItems(with: searchString)
    }
}

private extension SearchViewController {
    enum Defaults {
        static let noItemsFoundString = "No items found"
        static let itemsFoundString = "We found these items"
    }
}

extension SearchViewController: Storyboarded { }