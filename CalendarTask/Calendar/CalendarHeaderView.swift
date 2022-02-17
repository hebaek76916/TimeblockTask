//
//  CalendarHeaderView.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/15.
//

import UIKit

class CalendarHeaderView: UIView {
    
    let didTapLastMonthCompletionHandler: (() -> Void)
    let didTapNextMonthCompletionHandler: (() -> Void)
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "MONTH"
        label.textAlignment = .center
        return label
    }()
    
    lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return formatter
    }()
    
    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.gray), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.gray), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }
    
    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }
    
    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
        }
    }
    
    init(
        didTapLastMonthCompletionHandler: @escaping (() -> Void),
        didTapNextMonthCompletionHandler: @escaping (() -> Void)
    ) {
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
        super.init(frame: .zero)
        
        nextMonthButton.addTarget(self,
                                  action: #selector(didTapNextMonthButton),
                                  for: .touchUpInside)
        
        previousMonthButton.addTarget(self,
                                  action: #selector(didTapPreviousMonthButton),
                                  for: .touchUpInside)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemGroupedBackground
        
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        
        addSubviews(monthLabel,
                    dayOfWeekStackView,
                    separatorView,
                    nextMonthButton,
                    previousMonthButton)
        
        
        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.textAlignment = .center
            dayLabel.font = .systemFont(ofSize: 16, weight: .bold)
            let labelAsset = dayOfWeekLetter(for: dayNumber)
            dayLabel.text = labelAsset.title
            dayLabel.textColor = labelAsset.color
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dayOfWeekLetter(for dayNumber: Int) -> (title: String, color: UIColor) {
        var letter = ""
        var color = UIColor.black
        switch dayNumber {
        case 1:
            letter = "Sun"
            color = .red
        case 2:
            letter = "Mon"
        case 3:
            letter = "Tue"
        case 4:
            letter = "Wed"
        case 5:
            letter = "Thu"
        case 6:
            letter = "Fri"
        case 7:
            letter = "Sat"
            color = .blue
        default:
            letter = ""
        }
        return (letter, color)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [
            monthLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 16),
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor,
                                                       constant: -5),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            nextMonthButton.widthAnchor.constraint(equalToConstant: 40),
            nextMonthButton.heightAnchor.constraint(equalTo: widthAnchor),
            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -16),
            nextMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            
            previousMonthButton.widthAnchor.constraint(equalToConstant: 40),
            previousMonthButton.heightAnchor.constraint(equalTo: widthAnchor),
            previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: 16),
            previousMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor)
        ].forEach{ $0.isActive = true }
    }
}
