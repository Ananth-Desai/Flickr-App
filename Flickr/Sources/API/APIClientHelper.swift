//
//  APIClientHelper.swift
//  Flickr
//
//  Created by Ananth Desai on 22/04/22.
//

import Foundation
import Sedwig

struct APIClientHelper {
    static func getFlickrApiClient() -> AsyncAPIClientRx {
        let baseUrl = GlobalConstants.shared.baseSearchUrl
        let timeoutInterval = TimeInterval(1000)
        let clientConfiguration: APIClientConfiguration
        let queryParameters = getQueryParameters()
        clientConfiguration = APIClientConfiguration(baseURL: baseUrl,
                                                     timeoutIntervalForRequest: timeoutInterval,
                                                     timeoutIntervalForResource: timeoutInterval,
                                                     defaultQueryParameters: queryParameters,
                                                     logConfiguration: LogConfiguration())
        return URLSessionAPIClient(withConfiguration: clientConfiguration)
    }

    static func getQueryParameters() -> QueryParameters {
        QueryParameters([
            QueryParameter(name: "method", value: GlobalConstants.shared.apiMethod),
            QueryParameter(name: "format", value: GlobalConstants.shared.format),
            QueryParameter(name: "nojsoncallback", value: GlobalConstants.shared.noJsonCallback),
            QueryParameter(name: "api_key", value: GlobalConstants.shared.apiKey)
        ])
    }
}
