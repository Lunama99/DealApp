//
//  Network.swift
//  Vera
//
//  Created by Macbook on 31/08/2021.
//

import Foundation
import SVProgressHUD
import Moya

class NetworkManager {
    var provider: MoyaProvider<API> {
        let provider = MoyaProvider<API>()
        provider.session.sessionConfiguration.timeoutIntervalForRequest = 60
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            SVProgressHUD.dismiss()
        }
        return provider
    }
}
