//
// Created by Alex Dearden on 27/06/2020.
// Copyright (c) 2020 Alex Dearden. All rights reserved.
//

import Foundation
import UIKit

class ItemListCell: UITableViewCell {

    @IBOutlet private weak var toggleSwitch: UISwitch!
    @IBOutlet private weak var name: UILabel!

    func configure(for item: Item) {
        name.text = item.name
    }

    func toggleSwitch(for item: Item) {
        toggleSwitch.isOn = toggleSwitch.isOn ? false : true
    }
}
