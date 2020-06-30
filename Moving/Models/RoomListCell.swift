//
//  RoomListCell.swift
//  Moving
//
//  Created by Alex Dearden on 26/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class RoomListCell: UITableViewCell {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var roomType: UILabel!

    var room: Room!

/*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
*/

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // TODO: Requries implementation
    }

    func configure(for room: Room) {
        name.text = room.name
        roomType.text = room.type.name
    }

}
