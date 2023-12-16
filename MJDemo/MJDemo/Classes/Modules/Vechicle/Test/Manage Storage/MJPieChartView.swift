//
//  MJPieChartView.swift
//  Anyfleet2310
//
//  Created by 郭明健 on 2023/12/14.
//

import UIKit

class MJPieChartView: UIView {
    struct MJPieChartData {
        var value: Double = 0
        var color: UIColor = .orange
    }
    
    struct Configuration {
        var dataList: [MJPieChartData] = []
        var subTitle: String = ""
        var title: String = ""
        //
        var smallRadius: CGFloat = 64
        var textOffset: CGFloat = 6
    }
    
    // MARK: -
    private lazy var centerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.PFMedium(fontSize: 14)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.hexColor(color: "ABABAB")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.PFRegular(fontSize: 13)
        return label
    }()
    
    // MARK: -
    private var configuration: Configuration!
    
    public func setupViews(configuration: Configuration) {
        self.configuration = configuration
        //
        layoutConstraints()
        centerTitleLabel.text = configuration.title
        subTitleLabel.text = configuration.subTitle
        //
        self.setNeedsDisplay()
    }
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func setupViews() {
        addSubview(centerTitleLabel)
        addSubview(subTitleLabel)
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            centerTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 3),
            centerTitleLabel.widthAnchor.constraint(equalToConstant: configuration.smallRadius * 2),
            
            subTitleLabel.bottomAnchor.constraint(equalTo: centerTitleLabel.topAnchor, constant: -configuration.textOffset),
            subTitleLabel.leadingAnchor.constraint(equalTo: centerTitleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: centerTitleLabel.trailingAnchor),
        ])
    }
    
    // MARK: -
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if configuration == nil {
            return
        }
        //
        var sum: Double = 0
        
        for (_, item) in configuration.dataList.enumerated() {
            sum += item.value
        }
        
        var percentList: [Double] = []
        for (_, item) in configuration.dataList.enumerated() {
            let percent: Double = item.value / sum
            percentList.append(percent)
        }
        
        let radius: CGFloat = self.height / 2.0 //configuration.radius
        let smallRadius: CGFloat = configuration.smallRadius
        var startAngle: CGFloat = 0
        let center = CGPoint(x: self.width / 2.0, y: self.height / 2.0)
        let context = UIGraphicsGetCurrentContext()!
        
        for (index, percent) in percentList.enumerated() {
            let angle = CGFloat.pi * 2.0 * CGFloat(percent)
            let color = configuration.dataList[index].color
            //
            context.move(to: center)
            context.setFillColor(color.cgColor)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: startAngle + angle, clockwise: false)
            context.fillPath()
            //
            startAngle += angle
        }
        
        context.move(to: center)
        context.setFillColor(UIColor.white.cgColor)
        context.addArc(center: center, radius: smallRadius, startAngle: 0, endAngle: CGFloat.pi * 2.0, clockwise: false)
        context.fillPath()
    }

}
