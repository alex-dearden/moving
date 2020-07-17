//
//  ListCellView.swift
//  Moving
//
//  Created by Alex Dearden on 11/07/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

class ListCellView: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var background: UIView!
    @IBOutlet private weak var switchImageView: SwitchImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(Identifiers.listCellView, owner: self)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }

    func update(with title: String, icon: UIImage?) {
        titleLabel.text = title
        iconImageView.image = icon
        iconImageView.isHidden = false
        switchImageView.isHidden = true
    }

    func update(with title: String, checked: Bool) {
        switchImageView.setImage(on: checked)
        titleLabel.text = title
    }

    private func setup() {
        background.layer.cornerRadius = Defaults.cornerRadius
    }

}

private extension ListCellView {
    enum Defaults {
        static let cornerRadius: CGFloat = 12
    }
}
