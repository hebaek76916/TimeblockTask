//
//  CalendarHeaderView.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/15.
//

import UIKit

class CalendarHeaderView: UIView {
    
    //MARK: - Properties
    let didTapLastMonthCompletionHandler: (() -> Void)
    let didTapNextMonthCompletionHandler: (() -> Void)
    
    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
        }
    }
    
    enum DayOfTheWeek: CaseIterable {
        case Sun
        case Mon
        case Tue
        case Wed
        case Thu
        case Fri
        case Sat
        
        var rawvalue: (title: String, color: UIColor) {
            switch self {
            case .Sun: return (title: "Sun", color: .red)
            case .Tue: return (title: "Mon", color: .black)
            case .Mon: return (title: "Tue", color: .black)
            case .Wed: return (title: "Wed", color: .black)
            case .Thu: return (title: "Thu", color: .black)
            case .Fri: return (title: "Fri", color: .black)
            case .Sat: return (title: "Sat", color: .blue)
            }
        }
    }

    //MARK: - View Properties
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
    
    
    
    init(
        didTapLastMonthCompletionHandler: @escaping (() -> Void),
        didTapNextMonthCompletionHandler: @escaping (() -> Void)
    ) {
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
        super.init(frame: .zero)
        setupUI()
        configureButtonsSelectors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dayOfWeekLetter(for dayNumber: DayOfTheWeek) -> (title: String, color: UIColor) {
        return dayNumber.rawvalue
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

// MARK: - Setup UI
private extension CalendarHeaderView {
    func setupUI() {
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
        
        
        for dayOfWeek in DayOfTheWeek.allCases {
            let dayLabel = UILabel()
            dayLabel.textAlignment = .center
            dayLabel.font = .systemFont(ofSize: 16, weight: .bold)
            let labelAsset = dayOfWeekLetter(for: dayOfWeek)
            dayLabel.text = labelAsset.title
            dayLabel.textColor = labelAsset.color
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
    }
}

// MARK: - Selectors
private extension CalendarHeaderView {
    func configureButtonsSelectors() {
        
        nextMonthButton.addTarget(self,
                                  action: #selector(didTapNextMonthButton),
                                  for: .touchUpInside)
        
        previousMonthButton.addTarget(self,
                                  action: #selector(didTapPreviousMonthButton),
                                  for: .touchUpInside)
        
    }
    
    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }
    
    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }
}
