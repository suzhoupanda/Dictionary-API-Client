//
//  OxfordUtilityAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordUtilityAPIRequest: OxfordAPIRequest{
    
    enum UtiltyRequestEndpoint: String{
        case languages
        case filters
        case lexicalcategories
        case registers
        case domains
        case regions
        case grammaticalFeatures
    }
    
    var targetLanguage: OxfordAPILanguage?
    var utilityRequestEndpoint: UtiltyRequestEndpoint
    var endpointForAllFiltersRequest: OxfordAPIEndpoint?
    
    init(withUtilityRequestEndpoint endpoint: UtiltyRequestEndpoint, andWithTargetLanguage targetLang: OxfordAPILanguage? = nil, andWithEndpointForAllFiltersRequest requestedEndpointAllFiltersRequest: OxfordAPIEndpoint? = nil){
        
        self.utilityRequestEndpoint = endpoint
        self.targetLanguage = targetLang
        self.endpointForAllFiltersRequest = requestedEndpointAllFiltersRequest
        
        super.init()

        
    }
    
    
    override func getURLString() -> String {
        
        var baseURL = self.baseURLString
        
        baseURL = getURLStringFromAppendingUtilityRequestEndpoint(relativeToURLString: baseURL)
        
        switch utilityRequestEndpoint {
        case .domains:
            baseURL = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURL)
            if let targetLanguage = self.targetLanguage{
                baseURL = getURLStringFromAppendingTargetLanguageSpecifier(relativeToURLString: baseURL)
            }

            break
        case .registers:
            baseURL = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURL)
            if let targetLanguage = self.targetLanguage{
                baseURL = getURLStringFromAppendingTargetLanguageSpecifier(relativeToURLString: baseURL)
            }
            break
        case .regions,.grammaticalFeatures,.lexicalcategories:
            baseURL = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURL)
            break
        case .filters:
            if let endpointForAllFiltersRequest = self.endpointForAllFiltersRequest{
                baseURL = getURLStringFromAppendingEndpointForAllFiltersRequest(relativeToURLString: baseURL)

            }

            break
        default:
            break
        }
        return String()
    }
    
    func getURLStringFromAppendingEndpointForAllFiltersRequest(relativeToURLString urlString: String) -> String{
        
        if(self.endpointForAllFiltersRequest == nil){
            print("Error: A target language was not specified for this API Request - As a result, the source language will therefore be used in place of the target language.  Please make sure to pass in a value for the target language during initialization")
            
            /** Remove the final forward slash **/
            
            urlString.removeLast()
            
            return urlString
        }
        
        return urlString.appending("\(self.endpointForAllFiltersRequest!.rawValue)/")
    }
    
    func getURLStringFromAppendingTargetLanguageSpecifier(relativeToURLString urlString: String) -> String{
        
        if(self.targetLanguage == nil){
            print("Error: A target language was not specified for this API Request - As a result, the source language will therefore be used in place of the target language.  Please make sure to pass in a value for the target language during initialization")
            
            self.targetLanguage = self.language
        }
        
        return urlString.appending("\(self.targetLanguage!.rawValue)/")
    }
    
    private func getURLStringFromAppendingUtilityRequestEndpoint(relativeToURLString urlString: String) -> String{
        
        
        return urlString.appending("\(self.utilityRequestEndpoint.rawValue)/")
        
        
    }

}
