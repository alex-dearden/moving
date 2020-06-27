//
//  ListItemsViewController.swift
//  Moving
//
//  Created by Alex Dearden on 27/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class ItemsListViewController: UIViewController {

    @IBOutlet private weak var tableview: UITableView!

    var roomStore: RoomStore!
    weak var coordinator: MainCoordinator?
    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {

    }
    
}

extension ItemsListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        room.items.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemListCell

        let item = room.items[indexPath.row]
        cell.configure(for: item)

        return cell

    }
}

extension ItemsListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = room.items[indexPath.row]
        debugPrint("Item: ", item, "was selected")
    }
}

extension ItemsListViewController: Storyboarded { }
