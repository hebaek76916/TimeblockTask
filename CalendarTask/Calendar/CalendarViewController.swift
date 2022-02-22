//
//  CalendarViewController.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/16.
//

import UIKit

class CalendarViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    private let calendar = Calendar(identifier: .gregorian)
    private lazy var days = calendar.generateDaysInMonth(for: baseDate)
    
    private var numberOfWeeksInBaseDate: Int {
      calendar.range(
        of: .weekOfMonth,
        in: .month,
        for: baseDate
      )?.count ?? 0
    }
    
    private var baseDate: Date {
        didSet {
            days = calendar.generateDaysInMonth(for: baseDate)
            collectionView.reloadData()
            headerView.baseDate = baseDate
        }
    }
    
    //MARK: - View Properties
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var headerView = CalendarHeaderView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
            
        }
    )
    
    //MARK: - Life Cycle
    init() {
        baseDate = Date()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()
        setUpCollectionView()
        baseDate = Date()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
}


private extension CalendarViewController {
    
    func setUpCollectionView() {
        collectionView.register(CalendarCollectionViewCell.self,
                                forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setUpUI() {
        
        view.addSubview(collectionView)
        view.addSubview(headerView)
        
        [collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 0),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: 0),
         collectionView.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: 80),
         collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                               constant: -20)
        ].forEach{ $0.isActive = true }
        
        [
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80)
        ].forEach{ $0.isActive = true }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.identifier,
            for: indexPath
        ) as! CalendarCollectionViewCell
        cell.configuartion(index: indexPath.item,
                            day: day)
        
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let day = days[indexPath.row]
        let vc = ScheduleViewController(day: day) {
            guard let view = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else { return }
            guard let scheduleView = view.calendarCollectionView else { return }
            scheduleView.updateSchedule($0)
        }
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
      let width = Int(collectionView.frame.width / 7)
      let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
      return CGSize(width: width, height: height)
    }
}
