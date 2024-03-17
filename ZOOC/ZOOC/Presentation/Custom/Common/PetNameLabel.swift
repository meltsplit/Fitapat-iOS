//
//  PetNameLabel.swift
//  ZOOC
//
//  Created by 장석우 on 2/12/24.
//

import UIKit

enum 조사: CaseIterable {
    case 은는
    case 이가
    case 을를
    case 과와
    case 아야
    case 이여
    case 이랑랑
    case 으로로
    case 으로서로서
    case 으로써로써
    case 으로부터로부터
    
    var 서식: String {
        switch self {
        case .은는: return "{은/는}"
        case .이가: return "{이/가}"
        case .을를: return "{을/를}"
        case .과와: return "{과/와}"
        case .아야: return "{아/야}"
        case .이여: return "{이/여}"
        case .이랑랑: return "{이랑/랑}"
        case .으로로: return "{으로/로}"
        case .으로서로서: return "{으로서/로서}"
        case .으로써로써: return "{으로써/로써}"
        case .으로부터로부터: return "{으로부터/로부터}"
        }
    }
    
    var 받침있을때: String {
        switch self {
        case .은는: return "은"
        case .이가: return "이"
        case .을를: return "을"
        case .과와: return "과"
        case .아야: return "아"
        case .이여: return "이"
        case .이랑랑: return "이랑"
        case .으로로: return "으로"
        case .으로서로서: return "으로서"
        case .으로써로써: return "으로써"
        case .으로부터로부터: return "으로부터"
        }
    }
    
    var 받침없을때: String {
        switch self {
        case .은는: return "는"
        case .이가: return "가"
        case .을를: return "를"
        case .과와: return "와"
        case .아야: return "야"
        case .이여: return "여"
        case .이랑랑: return "랑"
        case .으로로: return "로"
        case .으로서로서: return "로서"
        case .으로써로써: return "로써"
        case .으로부터로부터: return "로부터"
        }
    }
}


final class PetNameLabel: UILabel {
    
    private let petRepository = DefaultPetRepository.shared
    
    var attributeTuple: ([String], UIColor?, UIFont?, CGFloat, CGFloat, NSTextAlignment)?
    
    override var text: String? {
        didSet {
            Task { @MainActor in
                guard let text = self.text else { return }
                guard text.contains("{pet}") else { return }
                
                var tempText: String = text
                var pet: String = "반려동물"
                
                if let petName = petRepository.petResult?.name,
                   !petName.isEmpty  {
                    pet = petName
                    tempText = tempText.replacingOccurrences(of: "{pet}", with: petName)
                } else {
                    tempText = tempText.replacingOccurrences(of: "{pet}", with: "반려동물")
                }
                
                조사.allCases.forEach {
                    if text.contains($0.서식) {
                        let 조사 = Syllable.is받침(pet) ? $0.받침있을때 : $0.받침없을때
                        tempText = tempText.replacingOccurrences(of: $0.서식, with: 조사)
                    }
                }
                
                self.text = tempText
                if let attributeTuple {
                    setPetNameLabelStyle(targetString: attributeTuple.0,
                                         color: attributeTuple.1,
                                         font: attributeTuple.2,
                                         spacing: attributeTuple.3,
                                         baseLineOffset: attributeTuple.4,
                                         alignment: attributeTuple.5)
                }
            }
        }
    }
    
    func setPetNameLabelStyle(
        targetString: [String],
        color: UIColor?,
        font: UIFont?,
        spacing: CGFloat = 0,
        baseLineOffset: CGFloat = 0,
        alignment: NSTextAlignment = .left)
    {
        self.attributeTuple = (targetString, color, font, spacing, baseLineOffset, alignment)
        let fullText = text ?? ""
        let style = NSMutableParagraphStyle()
        let attributedString = NSMutableAttributedString(string: fullText)
        
        for target in targetString {
            var realTarget = target
            if target == "{pet}" {
                if let petName = petRepository.petResult?.name,
                   !petName.isEmpty  {
                    realTarget = petName
                } else {
                    realTarget = "반려동물"
                }
            }
            let range = (fullText as NSString).range(of: realTarget)
            attributedString.addAttributes(
                [.font: font as Any,
                 .foregroundColor: color as Any,
                 .baselineOffset: baseLineOffset], // Add baseline offset here
                range: range
            )
        }
        
        style.lineSpacing = spacing
        style.alignment = alignment
        attributedString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
        
    }
    
    
    
    
    
}



