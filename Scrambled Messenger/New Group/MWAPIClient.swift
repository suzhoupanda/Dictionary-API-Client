//
//  MWAPIClient.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class MWAPIClient: MWAPIDelegate{
    
    
    static let sharedClient = MWAPIClient()
    
    /** Instance variables **/
    
    private var urlSession: URLSession!
    private var delegate: MWAPIDelegate?
    
    private var dictionaryEntry: MWDictionaryEntry?
    
    private  init(){

        urlSession = URLSession.shared
        delegate = self
        
        
    }
    
    func setOxfordDictionaryAPIClientDelegate(with mwapiDelegate: MWAPIDelegate){
        
        self.delegate = mwapiDelegate
        
    }
    
    func resetDefaultDelegate(){
        self.delegate = self
    }
    
    func downloadXMLData(forHeadWord headWord: String, hasRequestThesaurusAPI: Bool){
        
        let mwapiRequest = MWAPIRequest(withHeadWord: headWord, isThesaurusRequest: false)
        
        let apiRequest = mwapiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: apiRequest)
    }
    
    
    
    /** Wrapper function for executing aynchronous download of JSON data from Oxford Dictionary API **/
    
    private func startDataTask(withURLRequest request: URLRequest){
        
        guard let delegate = self.delegate else {
            fatalError("Error: no delegate specified for Oxford API download task")
        }
        
        _ = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            switch (data,response,error){
            case (.some,.some,.none),(.some,.some,.some): //Able to connect to the server, data received
                
                let httpResponse = (response! as! HTTPURLResponse)
                print("Connected to server with HTTP status code of: \(httpResponse.statusCode)")
                
                
                do{
                    
                   

                    let xmlDocument = try XMLDocument(data: data!, options: 0)
                    
                    delegate.didFinishReceivingXMLDocument(withXMLDocument: xmlDocument, withHTTPResponse: httpResponse)
                    
                    let nodes = try xmlDocument.nodes(forXPath: "//entry")
                
                    if let entryNode = nodes.first{
                        
                        let entry = try self.getDictionaryObject(fromXMLNode: entryNode)
                        
                        delegate.didFinishReceivingDictionaryEntry(withDictionaryEntry: entry, withHTTPResponse: httpResponse)

                    }
                 
                    
                    
    
                } catch let error as NSError{
                    print("Error occurred while attempting to serialize JSON data: \(error.localizedDescription)")
                    delegate.didFailToSerializeXMLData(withHTTPResponse: httpResponse)

                }
            
                break
            case (.none,.some,.none),(.none,.some,.some): //Able to connect to the server but failed to get data or received a bad HTTP Response
                if let httpResponse = (response as? HTTPURLResponse){
                    delegate.didFailToGetXMLData(withHTTPResponse: httpResponse)
                }
                break
            case (.none,.none,.some): //Unable to connect to the server, with an error received
                delegate.didFailToConnectToEndpoint(withError: error!)
                break
            case (.none,.none,.none): //Unable to connect to the server, no error received
                let error = NSError(domain: "Failed to get a response: Error occurred while attempting to connect to the server", code: 0, userInfo: nil)
                delegate.didFailToConnectToEndpoint(withError: error)
                break
            default:
                break
            }
            
        }).resume()
    }
    
    private func getDictionaryObject(fromXMLNode entryNode: XMLNode) throws -> MWDictionaryEntry{
        
        let dictionaryEntry = MWDictionaryEntry()

        do{
            
            if let pronunication = try entryNode.nodes(forXPath: "//pr").first,let stringValue = pronunication.stringValue{
                
                dictionaryEntry.pronunciation = stringValue
            }
            
            if let functionalLabel = try entryNode.nodes(forXPath: "//fl").first,let stringValue = functionalLabel.stringValue{
                
                dictionaryEntry.functionalLabel = stringValue
            }
            
            if let soundFilePath = try entryNode.nodes(forXPath: "//wav").first,let stringValue = soundFilePath.stringValue{
                
                dictionaryEntry.audioFilePath = stringValue
            }
            
            if let headWord = try entryNode.nodes(forXPath: "//hw").first,let stringValue = headWord.stringValue{
                
                dictionaryEntry.headWord = stringValue
            }
            
            if let etymology = try entryNode.nodes(forXPath: "//et").first,let stringValue = etymology.stringValue{
                
                dictionaryEntry.etymology = stringValue
            }
            
            
            
            if let definitionNode = try entryNode.nodes(forXPath: "//def").first{
                
                let definitions: [String] = try definitionNode.nodes(forXPath: "//dt").map({
                    
                    (definitionNode: DDXMLNode) in
                    
                    return definitionNode.stringValue

                }).filter({ return $0 != nil}) as! [String]
                
                
                let processedDefinitions: [String] = definitions.map({
                    
                    var mutableDef = $0
                    
                    if(mutableDef.first! == ":"){
                        mutableDef.removeFirst()
                    }
                    
                    return mutableDef
                })
                
                dictionaryEntry.definitions = processedDefinitions
                    
    
            }
            
     
            return dictionaryEntry

        } catch _ as NSError{
            throw NSError(domain: "XMLParsingError: failed to convert the XML dictionary entry into a valid dictionary object", code: 0, userInfo: nil)
        }
        
      
    }

}

/**
extension MWAPIClient: XMLParserDelegate{
  
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Started parsing document....")
        
       
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Finished parsing the document")
        
   
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if(elementName == "entry"){
            self.dictionaryEntry = DictionaryEntry()
        }
        
        currentElement = elementName
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        guard let dictEntry = self.dictionaryEntry else {
            print("Error: no dictionary entry has been intialized, unable to store parsed XML data")
            return
        }
        
        
        if(elementName == "entry"){
            dictionaryEntries.append(dictEntry)
            self.dictionaryEntry = nil
        }
      
        if(elementName == currentElement){
            
            
            if let elementTag = ElementTag(rawValue: elementName), let stringData = self.stringData{
                switch(elementTag){
                case .Pronunciation:
                    print("Saving pronunciation data: \(stringData)")
                    dictEntry.pronunciation = stringData
                    self.stringData = nil
                    break
                case .Definition:
                    print("Saving definition data: \(stringData)")
                    dictEntry.addDefinition(def: stringData)
                    self.stringData = nil
                    break
                case .FunctionalLabel:
                    print("Saving functionalLabel data: \(stringData)")
                    dictEntry.functionalLabel = stringData
                    self.stringData = nil
                    break
                case .Etymology:
                    print("Saving etymology data: \(stringData)")
                    dictEntry.etymology = stringData
                    self.stringData = nil
                    break
                case .HeadWord:
                    print("Saving headword data: \(stringData)")
                    dictEntry.headWord = stringData
                    self.stringData = nil
                    break
                case .AudioFile:
                    print("Saving audiofile data: \(stringData)")
                    dictEntry.audioFilePath = stringData
                    self.stringData = nil
                    break
                default:
                    break
                }
                
                

            }
            
            currentElement = String()
        }
   
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if(stringData == nil){
            print("Setting string data to string : \(string)")
            stringData = string
        } else {
            print("Appending new string data: \(string) to existing string: \(stringData!)")
            stringData = stringData!.appending(string)
        }
    }
    
   
  
 
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error occurred while parsing: \(parseError.localizedDescription)")
        
        delegate!.didFailToSerializeXMLData(withError: parseError)

    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print("Validation error occurred while parsing")
        delegate!.didFailToSerializeXMLData(withError: validationError)

    }
    
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        
        print("Found CDATA block")

    }
    
    
   
}
**/

extension MWAPIClient{

    
    func didFinishReceivingXMLDocument(withXMLDocument xmlDocument: XMLDocument, withHTTPResponse httpResponse: HTTPURLResponse){
        
        print("XML document received: \(xmlDocument.description)")
        
    }
    
    func didFinishReceivingDictionaryEntry(withDictionaryEntry dictionaryEntry: MWDictionaryEntry, withHTTPResponse httpResponse: HTTPURLResponse){
        
        
    }
    
    
    func didFailToSerializeXMLData(withHTTPResponse httpResponse: HTTPURLResponse) {
        
    }
    
    func didFailToSerializeXMLData(withError error: Error?) {
        
    }
    
    func didFinishReceivingXMLData(withXMLResponse xmlResponse: MWAPIDelegate.XMLResponse, withHTTPResponse httpResponse: HTTPURLResponse) {
        
    }
    func didFailToGetXMLData(withHTTPResponse httpResponse: HTTPURLResponse) {
        
    }
    func didFailToConnectToEndpoint(withError error: Error) {
        
    }
    func didFinishReceivingHTTPResponse(withHTTPResponse httpResponse: HTTPURLResponse) {
        
    }
}



/**
 let xmlResponse = XMLParser(data: data!)
 xmlResponse.delegate = self
 
 print("XML data description is as follows: \(data!.description)")
 print("XML data debug description is as follows: \(data!.debugDescription)")
 
 if(xmlResponse.parse()){
 print("Success: successfully parsed the xmlResponse")
 self.dictionaryEntries.forEach({
 print($0.debugDescription)
 })
 
 } else {
 print("Error: failed to parse the xmlResponse")
 delegate.didFailToSerializeXMLData(withHTTPResponse: httpResponse)
 }
 **/
