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
    private var selectedObjectType: String!

    private var isEdit = false {
        didSet {
            setButtonTitle()
        }
    }

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

    func update(objectTitle: String, types: [String], hideImage: Bool = false) {
        imageView.isHidden = hideImage
        newItemLabel.text = objectTitle
        pickerArray = types
    }
    
    func updateImage(_ image: UIImage) {
        imageView.loadImage(image)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        // TODO: Handle via Combine?
        delegate?.dismiss()
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        // TODO: Error handling to show message saying room name cannot be empty
        guard let name = nameTextField.text,
            nameTextField.text != "",
            let typeName = selectedObjectType else {
            return
        }

        if isEdit {
            // TODO: Handle via Combine?
            delegate?.add(name: name, typeName: typeName)
        } else {
            // TODO: Handle via Combine?
            delegate?.add(name: name, typeName: typeName)
        }

        delegate?.dismiss()
    }
    
}

extension EditObjectView {
    private func setupUI() {
        nameTextField.becomeFirstResponder()
        addOrEditButton.setTitle(Defaults.add, for: .normal)
        typePicker.delegate = self
        typePicker.dataSource = self
        let firstType = pickerArray.first ?? Defaults.otherType

        imageView.tapDelegate = self
    }

    private func setButtonTitle() {
        let title = isEdit ? Defaults.edit : Defaults.add
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
        return pickerArray.count
    }
}

extension EditObjectView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedObjectType = pickerArray[row]
    }
}

private extension EditObjectView {
    enum Defaults {
        static let edit = "Edit"
        static let add = "Add"
        static let otherType = "other"
    }
}
