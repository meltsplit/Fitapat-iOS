//
//  PetNameButton.swift
//  ZOOC
//
//  Created by 장석우 on 2/12/24.
//

import UIKit


class PetNameButton: UIButton {

    
    private let petRepository = DefaultPetRepository.shared
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        
        guard let title else { return }
        guard title.contains("{pet}") else {
            super.setTitle(title, for: state)
            return
        }
        
        var text = title
        var pet: String = ""
        
        if let petName = petRepository.petResult?.name,
           !petName.isEmpty  {
            pet = petName
            text = text.replacingOccurrences(of: "{pet}", with: petName)
        } else {
            pet = "반려동물"
            text = text.replacingOccurrences(of: "{pet}", with: pet)
        }
        
        
        조사.allCases.forEach {
            if text.contains($0.서식) {
                let 조사 = Syllable.is받침(pet) ? $0.받침있을때 : $0.받침없을때
                text = text.replacingOccurrences(of: $0.서식, with: 조사)
            }
        }
            
        super.setTitle(text, for: state)
    }
}



