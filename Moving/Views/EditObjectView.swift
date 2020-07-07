//
//  EditObjectView.swift
//  Moving
//
//  Created by Alex Dearden on 30/06/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

protocol EditObjectViewDelegate: class {
    func dismiss()
    func edit(newName: String, newTypeName: String)
    func add(name: String, typeName: String)
    func imageViewTapped()
}

class EditObjectView: UIView, NibLoadableView {

    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var imageView: ImageContainer!
    @IBOutlet private weak var newItemLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var typePicker: UIPickerView!
    @IBOutlet weak var addOrEditButton: UIButton!

    private var pickerArray: [String] = []
    weak var delegate: EditObjectViewDelegate?
    private var selectedRoomType: RoomType?

    private var isEdit = false {
        didSet {
            setButtonTitle()
        }
    }

    // Used to edit existing object
//    init(name: String, currentTypeName: String, typesArray: [String]) {
//        super.init(frame: CGRect.zero)
//
//        isEdit = true
//        nameTextField.text = name
//        let selectedTypeRow = typesArray.firstIndex { $0 == currentTypeName } ?? 0
//        typePicker.selectRow(selectedTypeRow, inComponent: 0, animated: false)
//    }
//
//    // Used to add new object
//    init(typesArray: [String]) {
//        super.init(frame: CGRect.zero)
//        pickerArray = typesArray
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("EditObjectView", owner: self)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        setupUI()
    }

    func updatePicker(_ types: [String]) {
        pickerArray = types
    }
    
    func updateImage(_ image: UIImage) {
        imageView.loadImage(image)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        // TODO: Handle via delegate or Combine
        delegate?.dismiss()
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        // TODO: Error handling to show message saying room name cannot be empty
        guard let name = nameTextField.text,
            nameTextField.text != "",
            let typeName = selectedRoomType?.name else {
            return
        }

        if isEdit {
            // TODO: Handle via delegate or Combine
            delegate?.add(name: name, typeName: typeName)
        } else {
            // TODO: Handle via delegate or Combine
            delegate?.add(name: name, typeName: typeName)
        }

        delegate?.dismiss()
    }
    
}

extension EditObjectView {
    private func setupUI() {
        nameTextField.becomeFirstResponder()
        addOrEditButton.setTitle(Defaults.addRoom, for: .normal)
        typePicker.delegate = self
        typePicker.dataSource = self
        let firstType = pickerArray.first ?? "other"
        selectedRoomType = RoomType.init(rawValue: firstType)

        imageView.tapDelegate = self
    }

    private func setButtonTitle() {
        let title = isEdit ? Defaults.editRoom : Defaults.addRoom
        addOrEditButton.setTitle(title, for: .normal)
    }
}

extension EditObjectView: ImageTappedDelegate {
    func wasTapped() {
        delegate?.imageViewTapped()
    }
}

extension EditObjectView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // TODO: We need this to be agnostic. Either Room or Item can populate it
        return pickerArray.count
    }
}

extension EditObjectView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerArray[row]
    }

    // TODO: How to make this type agnostic?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRoomType = RoomType.allCases[row]
    }
}

private extension EditObjectView {
    enum Defaults {
        static let editRoom = "Edit room"
        static let addRoom = "Add room"
    }
}
