//
//  RaitingControl.swift
//  Places
//
//  Created by Алексей Моторин on 12.04.2022.
//

import UIKit

class RaitingControl: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    
}
