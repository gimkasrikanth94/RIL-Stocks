//
//  APIService.swift
//  RIL Stocks
//
//  Created by Srikanth Gimka on 19/08/22.
//

import Foundation


class APIService{
    static let shared = APIService()
    
    private let apiKey = "EAYX08HJBJ3FO1ZL"
    private let stockSymbol = "RELIANCE.BSE"


    func loadStockData(stock: String, timeInterval: TimeFrame, outPutSize: OutputSize, completion:@escaping ([String: Any]?) -> ()) {
        
        var timeSeries = ""
        switch timeInterval {
        case .daily:
            timeSeries = "TIME_SERIES_DAILY"
        case .weekly:
            timeSeries = "TIME_SERIES_WEEKLY"
        case .monthly:
            timeSeries = "TIME_SERIES_MONTHLY"
        }
        
        var output = ""
        switch outPutSize {
        case .full:
            output = "&outputsize=full"
        case .compact:
            output = ""
        }

        guard let url = URL(string: "https://www.alphavantage.co/query?function=\(timeSeries)&symbol=\(stockSymbol)\(output)&apikey=\(apiKey)") else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                
                completion(nil)
                return
            }
            
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    completion(json)
                    return
                } catch {
                    print("Something went wrong")
                    completion(nil)
                    return
                }
        }.resume()

    }
}
