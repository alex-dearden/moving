//
//  EditItemViewController.swift
//  Moving
//
//  Created by Alex Dearden on 27/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {
    
    @IBOutlet private weak var itemTextField: UITextField!
    @IBOutlet private weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var addItemButton: UIButton!

    var roomStore: RoomStore!
    
    weak var coordinator: MainCoordinator?
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addItemTapped(_ sender: UIButton) {
    }
    

}

extension EditItemViewController: Storyboarded { }