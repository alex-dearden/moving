//
//  EditRoomView.swift
//  Moving
//
//  Created by Alex Dearden on 26/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class EditRoomViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var roomTypePicker: UIPickerView!

    weak var coordinator: MainCoordinator?

    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension EditRoomViewController: Storyboarded { }