//
//  GenAIGuideModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/11/10.
//

import UIKit

struct GenAIGuideModel {
    let image: UIImage
    let text: String
}

extension GenAIGuideModel {
    static let data: [GenAIGuideModel] = [
        GenAIGuideModel(
            image: .zwImage(.mock_deprecated1),
            text: "안 좋은 화질"
        ),
        GenAIGuideModel(
            image: .zwImage(.mock_deprecated2),
            text: "옷을 입은 사진"
        ),
        GenAIGuideModel(
            image: .zwImage(.mock_deprecated3),
            text: "입을 벌린 사진"
        ),
    ]
}
