//
//  CalendarCellView.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/22.
//

import UIKit

protocol ScheduleValidatorProtocol {
    func validate(currentCount: Int) -> Bool
}

struct ScheduleValidator: ScheduleValidatorProtocol {
    private let limitCount: Int = 3
    func validate(currentCount: Int) -> Bool {
        if currentCount < limitCount {
            return true
        } else {
            return false
        }
    }
}

class CalendarCellView: UIView {
    
    // MARK: Property
    private var scheduleValidator: ScheduleValidatorProtocol?
    
    // MARK: View Properties
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
            guard let day = self.day else { return }
            numberLabel.text = day.number
            selectionBackgroundView.backgroundColor =  day.isWithinDisplayedMonth ? .clear : UIColor.init(white: 1, alpha: 0.65)
        }
    }
    
    //MARK: - Life Cycle
    init(frame: CGRect,
         schedule: ScheduleValidatorProtocol) {
        self.scheduleValidator = schedule
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [
            numberLabel.topAnchor.constraint(equalTo: topAnchor,
                                             constant: 10),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            selectionBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach{ $0.isActive = true }
        
        selectionBackgroundView.layer.borderWidth = 0.8
        selectionBackgroundView.layer.borderColor = UIColor.gray.cgColor
        bringSubviewToFront(selectionBackgroundView)
    }
}

// MARK: - Privates
private extension CalendarCellView {
    
    func setUpUI() {
        addSubviews(numberLabel, selectionBackgroundView)
        backgroundColor = .clear
    }
    
    func makeScheduleLabel(schedule: String) -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.text = schedule
        label.backgroundColor = getRandomColor()
        return label
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
}

// MARK: - Publics
extension CalendarCellView {
    public func updateSchedule(_ scehdule: String) {
        guard let scheduleValidator = self.scheduleValidator else { return }
        let scheduleLabel = makeScheduleLabel(schedule: scehdule)
    
        if selectionBackgroundView.subviews.contains(scheduleStackView) {
            if scheduleValidator
                .validate(
                    currentCount: scheduleStackView.subviews.count
                ) {
                scheduleStackView.addArrangedSubview(scheduleLabel)
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
            scheduleStackView.addArrangedSubview(scheduleLabel)
        }
    }
    
    public func dayConfigure(day: Day, index: Int) {
        self.day = day
        configureTextColor(index: index)
    }
    
}
