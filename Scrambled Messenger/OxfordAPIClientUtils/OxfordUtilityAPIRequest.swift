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
        
        super.init(withQueryWord: String(), andWithLanguage: .English)


        
    }
    
    
    override func getURLString() -> String {
        
        var baseURLStr = self.baseURLString
        
        appendUtilityRequestEndpoint(relativeToURLString: &baseURLStr)
        
        switch utilityRequestEndpoint {
        case .domains:
            appendSourceLanguageSpecifier(relativeToURLString: &baseURLStr)
            appendTargetLanguageSpecifier(relativeToURLString: &baseURLStr)
            break
        case .registers:
            appendSourceLanguageSpecifier(relativeToURLString: &baseURLStr)
            appendTargetLanguageSpecifier(relativeToURLString: &baseURLStr)
            break
        case .regions,.grammaticalFeatures,.lexicalcategories:
            appendSourceLanguageSpecifier(relativeToURLString: &baseURLStr)
            break
        case .filters:
            appendEndpointForAllFiltersRequest(relativeToURLString: &baseURLStr)
            break
        default:
            break
        }
        
        if let lastChar = baseURLStr.last, lastChar == "/"{
            baseURLStr.removeLast()
        }
        
        return baseURLStr
    }
    
    
    func appendSourceLanguageSpecifier(relativeToURLString urlString: inout String){
        
        urlString.append("\(self.language.rawValue)/")
    }
    
    func appendEndpointForAllFiltersRequest(relativeToURLString urlString: inout String){
        
        if let endpointStr = self.endpointForAllFiltersRequest{
            
            urlString.append("\(endpointStr)/")
        }
    }
    
    func appendTargetLanguageSpecifier(relativeToURLString urlString: inout String){
        if(self.targetLanguage != nil){
            
            urlString.append("\(self.targetLanguage!.rawValue)/")
        }
    }
    
    
    
    func appendUtilityRequestEndpoint(relativeToURLString urlString: inout String){
        
        urlString.append("\(self.utilityRequestEndpoint.rawValue)/")
    }
   

}
