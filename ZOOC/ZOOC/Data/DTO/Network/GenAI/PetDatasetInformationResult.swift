//
//  GenAIPetDatasetsResult.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

struct PetDatasetInformationResult: Decodable {
    let datasetID: String
    let datasetName: String
    let createdAt: String
    let description: String?
    let updatedAt: String
    let datasetImages: [DatasetImage]

    enum CodingKeys: String, CodingKey {
        case datasetID = "datasetId"
        case datasetName, createdAt, description, updatedAt
        case datasetImages = "dataset_images"
    }
}

// MARK: - DatasetImage

struct DatasetImage: Decodable {
    let url: String
    let id: String
    let createdAt: String
}
