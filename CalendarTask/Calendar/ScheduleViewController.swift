//
//  ScheduleViewController.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/17.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    let didTapConfirmButtonCompletionHandler: ((String) -> Void)
    
    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return view
    }()
    
    private lazy var boxView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.insetsLayoutMarginsFromSafeArea = false
        textField.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: -12)
        textField.placeholder = "Schedule"
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .full
        //dateFormatter.dateFormat = "EEEE, dd, MM, YYYY"
        return dateFormatter
    }()
    
    init(day: Day,
         didTapConfirmButtonCompletionHandler: @escaping ((String) -> Void)) {
        self.didTapConfirmButtonCompletionHandler = didTapConfirmButtonCompletionHandler
        super.init(nibName: nil, bundle: nil)
        dateLabel.text = dateFormatter.string(from: day.date)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        definesPresentationContext = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setUpUI()
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissView))
        dimmedBackgroundView.addGestureRecognizer(tap)
        confirmButton.addTarget(self,
                                action: #selector(confirmSchedule),
                                for: .touchUpInside)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmSchedule() {
        guard textField.text != "" else {
            dismiss(animated: true, completion: nil)
            return
        }
        didTapConfirmButtonCompletionHandler(textField.text ?? "")
        dismiss(animated: true, completion: nil)
        
    }
    
    private func setUpUI() {
        view.addSubview(dimmedBackgroundView)
        view.addSubview(boxView)
        boxView.addSubviews(dateLabel, textField, confirmButton)
        [
            dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach { $0.isActive = true }
        
        [
            boxView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            boxView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            boxView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ].forEach { $0.isActive = true }
        
        [
            dateLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: boxView.topAnchor,
                                           constant: 16),
            textField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,
                                           constant: 16),
            textField.leadingAnchor.constraint(equalTo: boxView.leadingAnchor,
                                               constant: 16),
            textField.trailingAnchor.constraint(equalTo: boxView.trailingAnchor,
                                                constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 66),
            confirmButton.leadingAnchor.constraint(equalTo: boxView.leadingAnchor,
                                                   constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: boxView.trailingAnchor,
                                                    constant: -16),
            confirmButton.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                               constant: 10),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.bottomAnchor.constraint(equalTo: boxView.bottomAnchor,
                                                  constant: -10)
        ].forEach{ $0.isActive = true }
    }
    
}
