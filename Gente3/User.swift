//
//  User.swift
//  Gente
//
//  Created by IKSong on 7/25/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

struct UserAddress: Codable, Hashable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
}

extension UserAddress {    
    func fullAddress() -> String {
        var fullAdrressString = ""
        if let street = street {
            fullAdrressString = fullAdrressString + street
        }
        
        if let suite = suite {
            fullAdrressString = fullAdrressString + ", " + suite
        }
        
        if let city = city {
            fullAdrressString = fullAdrressString + ", " + city
        }
        
        if let zipcode = zipcode {
            fullAdrressString = fullAdrressString + ", " + zipcode
        }
        
        return fullAdrressString
    }
}

struct User: Codable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: UserAddress?
}

extension User: CellConfigurable {
    var cellID: String {
        return "UserCell"
    }
    
    var cellClass: UITableViewCell.Type {
        return UserTableViewCell.self
    }
    
    func configure(_ cell: UITableViewCell) {
        if let cell = cell as? UserTableViewCell {
            cell.nameLabel.text = name
            cell.emailLabel.text = email
            cell.addressLabel.text = address?.fullAddress()
        }
    }
    
    static func resourceForAllUsers() -> Resource<[User]>? {
        guard let url = URL(string: BackEnd.user.urlString()) else { return nil }
        return Resource<[User]>.init(get: URLRequest(url: url), stubDataAssetName: BackEnd.user.dataAssetName())
    }
}

extension User: CollectionContentConfigurable {
    func configure(content: inout UIListContentConfiguration) {
        content.text = name
        content.secondaryText = email
    }
}

class UserTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.blue 
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 8.0
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
