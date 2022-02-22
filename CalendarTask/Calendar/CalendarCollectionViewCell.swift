//
//  CalendarCollectionViewCell.swift
//  CalendarTask
//
//  Created by 현은백 on 2022/02/16.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CalendarCollectionViewCell.self)
  
    var calendarCollectionView: CalendarCellView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemnt")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach{ $0.removeFromSuperview() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let cellView = calendarCollectionView else { return }
        contentView.addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        [
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].forEach { $0.isActive = true }
        
    }
}

extension CalendarCollectionViewCell {
    public func configuartion(index: Int,
                              day: Day) {
        self.calendarCollectionView = CalendarCellView(frame: .zero,
                                                       schedule: ScheduleValidator())
        self.calendarCollectionView?.dayConfigure(day: day, index: index)
    }
}
