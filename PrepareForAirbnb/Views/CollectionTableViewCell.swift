//
//  TableViewCell.swift
//  PrepareForAirbnb
//
//  Created by Jie Huang on 2023/10/10.
//

import UIKit


class CollectionTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionTableViewCell"
    
    private let customImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let titleLbl = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = UIColor.black
        return lable
    }()
    // Mark: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView()
        self.contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        self.customImageView.image = UIImage(named: "food-placeholder")
        self.customImageView.backgroundColor = .black
        stackView.addArrangedSubview(self.customImageView)
        customImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        customImageView.widthAnchor.constraint(equalToConstant: self.bounds.width-40).isActive = true
        stackView.addArrangedSubview(UIView())
        self.titleLbl.textAlignment = .left
        self.titleLbl.backgroundColor = .darkGray
        stackView.addArrangedSubview(self.titleLbl)
//        let layoutDefaultLowPriority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue-1)
//        let layoutDefaultHighPriority = UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue-1)
//        titleLbl.setContentHuggingPriority(layoutDefaultLowPriority, for: .vertical)
//        titleLbl.setContentHuggingPriority(layoutDefaultLowPriority, for: .horizontal)
//        titleLbl.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .vertical)
//        titleLbl.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .horizontal)
        self.titleLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.titleLbl.widthAnchor.constraint(equalToConstant: self.bounds.width-40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupDetail(appetizer: Appetizer) {
        self.titleLbl.text = appetizer.name
        Task {
            do {
                if let image = try await NetworkManager.shared.downloadImage(urlString: appetizer.imageURL) {
                    self.customImageView.image = image
                }
            } catch {
                
            }
        }
    }
}
