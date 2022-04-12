//
//  CustomTableViewCell.swift
//  Places
//
//  Created by Алексей Моторин on 04.04.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
     lazy var stackLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        return stack
    }()
    
    lazy var raitingStackView: UIStackView = {
       let stack = UIStackView()
       stack.translatesAutoresizingMaskIntoConstraints = false
       stack.spacing = 10
       stack.axis = .horizontal
       return stack
   }()
    
    lazy var imageRaiting: UIImageView = {
       let image = UIImageView(image: UIImage(named: "filledStar"))
       image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 44).isActive = true
        image.widthAnchor.constraint(equalToConstant: 44).isActive = true
       return image
   }()
    
    lazy var ratingCount: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "Apple Sd Gothic Neo", size: 18)
        lable.text = "5"
        return lable
    }()
    
    
     lazy var imagePlace: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
      lazy var namePlace: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "Apple Sd Gothic Neo", size: 18)
        return lable
    }()
    
     lazy var locationPlace: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "Apple Sd Gothic Neo", size: 15)
        return lable
    }()
    
     lazy var typePlace: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "Apple Sd Gothic Neo", size: 13)
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        contentView.addSubview(stackLabels)
        contentView.addSubview(imagePlace)
        contentView.addSubview(raitingStackView)
        
        raitingStackView.addArrangedSubview(imageRaiting)
        raitingStackView.addArrangedSubview(ratingCount)
        
        stackLabels.addArrangedSubview(namePlace)
        stackLabels.addArrangedSubview(locationPlace)
        stackLabels.addArrangedSubview(typePlace)
                
        NSLayoutConstraint.activate([
            
            imagePlace.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imagePlace.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imagePlace.heightAnchor.constraint(equalToConstant: 60),
            imagePlace.widthAnchor.constraint(equalToConstant: 60),
            
            stackLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackLabels.leadingAnchor.constraint(equalTo: imagePlace.trailingAnchor, constant: 15),
            stackLabels.widthAnchor.constraint(equalToConstant: 150),
            stackLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            raitingStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            raitingStackView.leadingAnchor.constraint(equalTo: stackLabels.trailingAnchor, constant: 10),    
        ])
        
    }
}

