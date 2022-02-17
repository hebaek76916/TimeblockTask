//
//  CalendarCollectionViewCell.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/16.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CalendarCollectionViewCell.self)
    
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var scheduleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var day: Day? {
        didSet {
            guard let day = day else { return }
            numberLabel.text = day.number
            selectionBackgroundView.backgroundColor =  day.isWithinDisplayedMonth ? .clear : UIColor.init(white: 1, alpha: 0.65)
        }
    }
    
    func configureTextColor(index: Int) {
        if index % 7 == 0 { // Sunday
            numberLabel.textColor = .red
        } else if index % 7 == 6 { // Saturday
            numberLabel.textColor = .blue
        } else {
            numberLabel.textColor = .black
        }
    }
    
    func updateSchedule(_ scehdule: String) {
        
        let label = UILabel()
        label.textColor = .label
        label.text = scehdule
        label.backgroundColor = getRandomColor()
        
        
        if selectionBackgroundView.subviews.contains(scheduleStackView) {
            if scheduleStackView.subviews.count < 2 {
                scheduleStackView.addArrangedSubview(label)
            }
        } else {
            selectionBackgroundView.addSubview(scheduleStackView)
            [
                scheduleStackView.leadingAnchor.constraint(equalTo: selectionBackgroundView.leadingAnchor),
                scheduleStackView.trailingAnchor.constraint(equalTo: selectionBackgroundView.trailingAnchor),
                scheduleStackView.bottomAnchor.constraint(equalTo: selectionBackgroundView.bottomAnchor),
                scheduleStackView.topAnchor.constraint(equalTo: selectionBackgroundView.topAnchor,
                                                       constant: 30)
            ].forEach{ $0.isActive = true }
            scheduleStackView.addArrangedSubview(label)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemnt")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //scheduleStackView.removeFromSuperview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        [
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                             constant: 10),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].forEach{ $0.isActive = true }
        
        selectionBackgroundView.layer.borderWidth = 0.8
        selectionBackgroundView.layer.borderColor = UIColor.gray.cgColor
        contentView.bringSubviewToFront(selectionBackgroundView)
    }
    
}

private extension CalendarCollectionViewCell {
    
    func updateSelectionStatus() {
        guard let day = day else { return }
        
        if day.isSelected {
            applySelectionStyle()
        } else {
            applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
        }
    }
    var isSmallScreenSize: Bool {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let smallWidth = UIScreen.main.bounds.width <= 350
        let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        
        return isCompact && (smallWidth || widthGreaterThanHeight)
    }
    
    func applySelectionStyle() {
        numberLabel.textColor = isSmallScreenSize ? .systemRed : .white
        selectionBackgroundView.isHidden = isSmallScreenSize
    }
    
    func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
        numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
        selectionBackgroundView.isHidden = true
    }
    
}
