//
//  RaitingControl.swift
//  Places
//
//  Created by Алексей Моторин on 12.04.2022.
//

import UIKit

class RaitingControl: UIStackView {
    
    var raiting = 0 {
        didSet {
            for (indexButton, button) in raitingButtons.enumerated() {
                button.isSelected = indexButton < raiting
            }
        }
    }
    
    private var raitingButtons = [UIButton]()
    
    private var starsCount = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRaitingView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupRaitingView() {
        
        let fillStar = #imageLiteral(resourceName: "filledStar")
        let emptyStar = #imageLiteral(resourceName: "emptyStar")
        let highlighStar = #imageLiteral(resourceName: "highlightedStar")
        
        for _ in 1...starsCount {
            
            let raitingButton: UIButton = {
                let button = UIButton()
                button.setImage(emptyStar, for: .normal)
                button.setImage(fillStar, for: .selected)
                button.setImage(highlighStar, for: .highlighted)
                button.setImage(highlighStar, for: [.highlighted, .selected])
                button.addTarget(self, action: #selector(raitingButtonPressed(_:)), for: .touchUpInside)
                
                button.heightAnchor.constraint(equalToConstant: 44).isActive = true
                button.widthAnchor.constraint(equalToConstant: 44).isActive = true
                
                return button
            }()
            
            addArrangedSubview(raitingButton)
            
            raitingButtons.append(raitingButton)
        }
    }
    
    @objc private func raitingButtonPressed(_ button: UIButton) {
        
        guard let index = raitingButtons.firstIndex(of: button) else { return }
        
        let selectedRaiting = index + 1
        
        if selectedRaiting == raiting {
            raiting = 0
        } else {
            raiting = selectedRaiting
        }
    }
}
