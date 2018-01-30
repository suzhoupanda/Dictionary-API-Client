//
//  MWAPIDelegate.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


protocol MWAPIDelegate{
    
    typealias XMLResponse = XMLParser
    
    func didFailToConnectToEndpoint(withError error: Error)
    
    func didFailToGetXMLData(withHTTPResponse httpResponse: HTTPURLResponse)
    
    func didFailToSerializeXMLData(withHTTPResponse httpResponse: HTTPURLResponse)
    
    func didFailToSerializeXMLData(withError error: Error?)

    func didFinishReceivingHTTPResponse(withHTTPResponse httpResponse: HTTPURLResponse)
    
    func didFinishReceivingXMLData(withXMLResponse xmlResponse: XMLResponse, withHTTPResponse httpResponse: HTTPURLResponse)
    
    func didFinishReceivingXMLDocument(withXMLDocument xmlDocument: XMLDocument, withHTTPResponse httpResponse: HTTPURLResponse)
    
    func didFinishReceivingDictionaryEntry(withDictionaryEntry dictionaryEntry: MWDictionaryEntry, withHTTPResponse httpResponse: HTTPURLResponse)


    
}
