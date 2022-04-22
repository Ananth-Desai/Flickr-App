//
//  APICallHandler.swift
//  Flickr
//
//  Created by Ananth Desai on 22/04/22.
//

import Foundation
import RxSwift
import Sedwig

class ApiCallHandler {
    private var apiClient: AsyncAPIClientRx
    static var shared = ApiCallHandler()

    init() {
        let apiClient = APIClientHelper.getFlickrApiClient()
        self.apiClient = apiClient
    }

    func fetchRequest(searchString: String) -> Single<Photos> {
        let queryParameters = QueryParameters([QueryParameter(name: "text", value: searchString)])
        let request = Request(method: .post, path: GlobalConstants.shared.requestPath, headers: Headers(), queryParameters: queryParameters)
        return apiClient.sendRequest(request).map {
            try self.parserResponse(response: $0)
        }
    }

    func parserResponse(response: Response) throws -> Photos {
        let decoder = JSONDecoder()
        guard let data = response.body else {
            return Photos(photos: PhotoArray(photo: []))
        }
        let responseData = try decoder.decode(Photos.self, from: data)
        return responseData
    }
}
