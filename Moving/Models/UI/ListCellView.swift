//
//  ListCellView.swift
//  Moving
//
//  Created by Alex Dearden on 11/07/2020.
//  Copyright © 2020 Alex Dearden. All rights reserved.
//

import UIKit

enum CellState {
    case checked, unchecked

    init(on: Bool) {
        self = on ? .checked : .unchecked
    }

    var textColor: UIColor? {
        switch self {
        case .checked:
            return UIColor(named: Identifiers.Color.cellCheckedText)
        case .unchecked:
            return UIColor(named: Identifiers.Color.buttonText)
        }
    }

    var backgroundColor: UIColor? {
        switch self {
        case .checked:
            return UIColor(named: Identifiers.Color.cellChecked)
        case .unchecked:
            return UIColor(named: Identifiers.Color.cellBackground)
        }
    }

    var image: UIImage? {
        switch self {
        case .checked:
            return UIImage(named: Identifiers.Image.switchOnNoTick)
        case .unchecked:
            return UIImage(named: Identifiers.Image.switchOff)
        }
    }
}

class ListCellView: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var roundedBackgroundView: UIView!
    @IBOutlet private weak var switchImageView: SwitchImageView!

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

    func update(with title: String, percentage: Double) {
        titleLabel.text = title
        setupPercent(with: percentage)
    }

    func update(with title: String, smallText: String) {
        titleLabel.text = title
        setupSmallLabel(with: smallText)
    }

    func update(with title: String, percentage: Double, and smallText: String) {
        titleLabel.text = title
        setupPercent(with: percentage)
        setupSmallLabel(with: smallText)
    }

    func update(with title: String, checked: Bool) {
        handleState(for: checked)
        titleLabel.text = title
    }

    private func setupPercent(with percent: Double) {
        guard percent > 0 else {
            return
        }

        switchImageView.image = nil
        let graphCircle = GraphCircle()
        graphCircle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(graphCircle)

        NSLayoutConstraint.activate([
            graphCircle.centerXAnchor.constraint(equalTo: switchImageView.centerXAnchor),
            graphCircle.centerYAnchor.constraint(equalTo: switchImageView.centerYAnchor),
        ])

        let circleFrame = CGRect(x: 0, y: 0, width: switchImageView.bounds.width, height: switchImageView.bounds.height)
//        graphCircle.update(for: 0.3, in: circleFrame)
    }

    private func setupSmallLabel(with text: String) {
        let smallLabel = UILabel()
        smallLabel.text = text
        smallLabel.textColor = UIColor(named: Identifiers.Color.buttonText)
        smallLabel.font = UIFont.tiny
        smallLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallLabel)

        NSLayoutConstraint.activate([
            smallLabel.centerXAnchor.constraint(equalTo: switchImageView.centerXAnchor),
            smallLabel.centerYAnchor.constraint(equalTo: switchImageView.centerYAnchor),
        ])
    }

    private func handleState(for on: Bool) {
        let state = CellState.init(on: on)
        switchImageView.setState(state: state)
        titleLabel.textColor = state.textColor
        roundedBackgroundView.backgroundColor = state.backgroundColor
    }

    private func setup() {
        roundedBackgroundView.layer.cornerRadius = Defaults.cornerRadius
        roundedBackgroundView.backgroundColor = CellState.unchecked.backgroundColor
    }

}

private extension ListCellView {
    enum Defaults {
        static let cornerRadius: CGFloat = 12
        static let percentagePadding: CGFloat = 5
    }
}
