//
//  SockSearchViewModel.swift
//  Fintegration
//
//  Created by Hrach on 10/28/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Gloss
import Result

typealias StockInfoSearchResult = Result<[StockInfo], NGNetworkError>

class StockInfoSearchViewModel{

    let searching: Driver<Bool>
    let stockInfos: Driver<StockInfoSearchResult>
    let cleanStocks: Driver<[StockInfo]>
    let errors: Driver<NGNetworkError>
    
    init(query: Driver<String>)
    {
        let networking = StockInfoNetworking.newStockInfoNetworking()
        let searching = ActivityIndicator()
        self.searching = searching.asDriver()
        
        stockInfos = query
            .flatMapLatest{query in
                print("Searching \(query)")
                return networking.request(StockInfoService.SearchStockInfo(query: query))
                    .filterSuccessfulStatusCodes()
                    .mapJSON()
                    .map{ json -> [StockInfo] in
                        guard let resultSet: JSON = "ResultSet" <~~ (json as! JSON) else {
                            throw NGNetworkError.Unknown
                        }
                        guard let results: [JSON] = "Result" <~~ resultSet else {
                            throw NGNetworkError.Unknown
                        }
                        return [StockInfo].from(jsonArray: results) ?? []
                    }
                    .mapToFailable()
                    .trackActivity(searching)
                    .asDriver(onErrorJustReturn: .failure(NGNetworkError.NoConnection))
        }
        
        cleanStocks = stockInfos
            .filter{result in
                guard case StockInfoSearchResult.success(_) = result else {
                    return false
                }
                return true
            }
            .map{try! $0.dematerialize()}
            .asDriver(onErrorJustReturn: [])
        
        errors = stockInfos
            .filter{result in
                guard case StockInfoSearchResult.failure(_) = result else {
                    return false
                }
                return true
            }
            .map{$0.error!}
            .asDriver(onErrorJustReturn: NGNetworkError.Unknown)
        
    }
}
