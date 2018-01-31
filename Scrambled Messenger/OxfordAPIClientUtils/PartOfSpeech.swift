//
//  PartOfSpeech.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


enum OxfordAPILanguage: String{
    case English = "en"
    case Spanish = "es"
    case Malay = "ms"
    case Setswana = "tn"
    case Swahili = "sw"
    case NorthernSoho = "nso"
    case Indonesia = "id"
    case Latvian = "lv"
    case Urdu = "ur"
    case Romanian = "ro"
    case Hindi = "hi"
    case German = "de"
    case Portuguese = "pt"
    case Tamil = "ta"
    case Gujarati = "gu"
}

enum OxfordRegion: String{
    case gb,us
}

enum NGramSize: Int{
    case ngram1 = 1
    case ngram2 = 2
    case ngram3 = 3
    case ngram4 = 4
}

enum TokenReturnFormat: String{
    case SingleString = "google"
    case ListOfStrings = "oup"
}

enum ValidCollateOption: String{
    case wordform
    case lemma
    case trueCase
    case lexicalCategory
}

enum ValidSortOption: String{

    case wordform
    case trueCase
    case lemma
    case lexicalCategory
    case frequency
    case normalizedFrequency
}

enum OxfordAPIEndpoint: String{
    
    case entries, inflections, search, translations, wordlist
    
    case utility = ""
    
    case stats_word_frequency = "stats/frequency/word"
    case stats_words_frequency = "stats/frequency/words"
    case stats_ngrams_frequency = "stats/frequency/ngrams"
    

    /** These are treated as subdivisions of the dictionary entries endpoint rather than as filters per se **/
    enum DictionaryEntryFilter: String{
        case examples
        case pronunciations
        case definitions
        case etymologies
        case variantForms
        case registers
        case regions
        case domains
        case grammaticalFeatures
        case lexicalCategory
        case sentences
        case none = ""
    }
    
    enum OxfordAPIFilter: Hashable{
        
        var hashValue: Int{
            switch self {
            case .definitions( _):
                return 0
            case .domains( _):
                return 1
            case .etymologies( _):
                return 2
            case .examples( _):
                return 3
            case .grammaticalFeatures( _):
                return 4
            case .lexicalCategory( _):
                return 5
            case .pronunciations( _):
                return 6
            case .regions( _):
                return 7
            case .registers( _):
                return 8
            case .translations( _):
                return 9
            case .variantForms( _):
                return 10
            case .trueCase(_):
                return 11
            case .format(_):
                return 12
            case .collate(_):
                return 13
            case .sort(_):
                return 14
            case .punctuation(_):
                return 15
            case .limit(_):
                return 16
            case .offset(_):
                return 17
            case .tokens(_):
                return 18
            case .contains(_):
                return 19
            case .minFrequency(_):
                return 20
            case .minDocumentFrequency(_):
                return 21
            case .minNormalizedFrequency(_):
                return 22
            case .maxFrequency(_):
                return 23
            case .maxDocumentFrequency(_):
                return 24
            case .maxNormalizedFrequency(_):
                return 25
            case .wordform(_):
                return 26
            case .wordforms(_):
                return 27
            case .lemma(_):
                return 28
            }
        }
        
        static func ==(lhs: OxfordAPIEndpoint.OxfordAPIFilter, rhs: OxfordAPIEndpoint.OxfordAPIFilter) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        
        func getDebugName() -> String{
            switch self {
            case .domains(_):
                return "domains"
            case .lexicalCategory(_):
                return "lexicalCategory"
            case .regions(_):
                return "regions"
            case .registers(_):
                return "registers"
            case .translations(_):
                return "translations"
            case .definitions(_):
                return "definitions"
            case .etymologies(_):
                return "etymologies"
            case .examples(_):
                return "examples"
            case .grammaticalFeatures(_):
                return "grammaticalFeatures"
            case .pronunciations(_):
                return "pronunciations"
            case .variantForms(_):
                return "variantForms"
            case .lemma(_):
                return "lemma"
            case .wordform(_):
                return "wordform"
            case .wordforms(_):
                return "wordforms"
            case .trueCase(_):
                return "trueCase"
            case .limit(_):
                return "limit"
            case .offset(_):
                return "offset"
            case .collate(_):
                return "collate"
            case .contains(_):
                return "contains"
            case .sort(_):
                return "sort"
            case .format(_):
                return "format"
            case .minFrequency(_):
                return "minFrequency"
            case .minNormalizedFrequency(_):
                return "minNormalizedFrequency"
            case .minDocumentFrequency(_):
                return "minDocumentFrequency"
            case .maxFrequency(_):
                return "maxFrequency"
            case .maxDocumentFrequency(_):
                return "maxDocumentFrequency"
            case .maxNormalizedFrequency(_):
                return "maxNormalizedFrequency"
            case .tokens(_):
                return "tokens"
            case .punctuation(_):
                return "punctuation"
            }
        }
        
        case domains([String])
        case lexicalCategory([String])
        case regions([String])
        case registers([String])
        case translations([String])
        case definitions([String])
        case etymologies([String])
        case examples([String])
        case grammaticalFeatures([String])
        case pronunciations([String])
        case variantForms([String])
        case wordform(String)
        case wordforms([String])
        case lemma([String])
        case trueCase([String])
        case limit(Int)
        case offset(Int)
        case collate([OxfordAPIFilter])
        case sort([OxfordAPIFilter])
        case minFrequency(Int)
        case maxFrequency(Int)
        case minNormalizedFrequency(Int)
        case maxNormalizedFrequency(Int)
        case minDocumentFrequency(Int)
        case maxDocumentFrequency(Int)
        case punctuation(Bool)
        case tokens([String])
        case contains([String])
        case format(Bool)
        
        func getParameterValues() -> Any?{
            
            switch self {
            case .contains(let tokenStrings):
                return tokenStrings
            case .collate(let oxfordAPIfilters):
                return oxfordAPIfilters
            case .definitions(let definitionsStrings):
                return definitionsStrings
            default:
                return nil
            }
        }
        
        func getQueryParameterString(isLastQueryParameter: Bool) -> String{
            
            var queryString = "\(getDebugName())="
            
            switch self {
            case .lexicalCategory(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .grammaticalFeatures(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .regions(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .domains(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .registers(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .definitions(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .etymologies(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .pronunciations(let parameterValues):
                queryString = "\(getDebugName())="
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .variantForms(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .wordforms(let parameterValues):
                queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .collate(let filters):
                let filterStrings = filters.map({ return $0.getDebugName()} )
                queryString = filterStrings.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .sort(let filters):
                let filterStrings = filters.map({ return $0.getDebugName()} )
                queryString = filterStrings.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .wordform(let wordform):
                queryString = queryString.appending("\(wordform)")
                break
            case .limit(let resultsLimit):
                queryString = queryString.appending("\(resultsLimit)")
                break
            case .offset(let resultsOffset):
                queryString = queryString.appending("\(resultsOffset)")
                break
            case .maxFrequency(let maxFrequency):
                queryString = queryString.appending("\(maxFrequency)")
                break
            case .minFrequency(let minFrequency):
                queryString = queryString.appending("\(minFrequency)")
                break
            case .maxNormalizedFrequency(let maxNormalizedFrequency):
                queryString = queryString.appending("\(maxNormalizedFrequency)")
                break
            case .minNormalizedFrequency(let minNormalizedFrequency):
                queryString = queryString.appending("\(minNormalizedFrequency)")
                break
            case .minDocumentFrequency(let minDocumentFrequency):
                queryString = queryString.appending("\(minDocumentFrequency)")
                break
            case .maxDocumentFrequency(let maxDocumentFrequency):
                queryString = queryString.appending("\(maxDocumentFrequency)")
                break
            case .punctuation(let shouldIncludePunctuation):
                queryString = queryString.appending("\(shouldIncludePunctuation ? "true" : "false")")
                break
            case .format(let shouldReturnAsSingleString):
                queryString = queryString.appending("\(shouldReturnAsSingleString ? "google" : "oup")")
                break
            case .tokens(let tokenValues):
                queryString = tokenValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            case .contains(let tokenValues):
                queryString = tokenValues.reduce(queryString, {$0.appending("\($1),")})
                queryString.removeLast()
                break
            default:
                queryString = String()
            }
            
          
            
            if(!isLastQueryParameter){
                queryString = queryString.appending(";")
            }
            
            return queryString
        }
    }
    
    
    private func addParameterValues(parameterValues: [String], toQueryString queryString: inout String){
        queryString = parameterValues.reduce(queryString, {$0.appending("\($1),")})
        queryString.removeLast()
    }
    
   
    
    func getAvailableFilters() -> Set<OxfordAPIFilter>{
        
        let resultLimitationFilters: Set<OxfordAPIFilter> = Set([OxfordAPIFilter.offset(0),OxfordAPIFilter.limit(1000)])
    
        switch self {
        case .entries:
            return Set([.definitions([]),.domains([]),.etymologies([]),.examples([]),.grammaticalFeatures([]),.lexicalCategory([]),
                       .pronunciations([]),.regions([]),.registers([]), .variantForms([])])
        case .inflections:
            return Set([.grammaticalFeatures([]),.lexicalCategory([])])
        case .translations:
            return Set([])
        case .wordlist:
            return Set([ .domains([]),.lexicalCategory([]),.regions([]),.registers([]),.translations([])])
        case .stats_word_frequency:
            return Set([ .wordform(""),.trueCase([]),.lemma([]),.lexicalCategory([]) ])
        case .stats_words_frequency:
            return Set([.collate([]),.sort([]),.minFrequency(0),.maxFrequency(10000),.minNormalizedFrequency(0),.maxNormalizedFrequency(10000),.wordforms([]),.trueCase([]),.lemma([]),.lexicalCategory([]),.grammaticalFeatures([])]).union(resultLimitationFilters)
        case .stats_ngrams_frequency:
            return Set([.minDocumentFrequency(0),.maxDocumentFrequency(10000),.minFrequency(0),.maxFrequency(10000),.contains([]),.tokens([])]).union(resultLimitationFilters)
        case .search:
            return Set([])
        case .utility:
            return Set([])
        }
    }
}

enum OxfordDomain: String{
    case air_force, alcoholic,american_civil_war,american_football,amerindian
    case anatomy,ancient_history,angling,anthropology, archaeology, archery, architecture
    case art, artefacts, arts_and_humanities, astrology, astronomy
    case athletics, audio, australian_rules, aviation, ballet, baseball, basketball, bellringing
    case biblical, billiards, biochemistry, biology, bird, bookbinding, botany, bowling, bowls,boxing
    case breed, brewing
    case bridge,broadcasting,buddhism,building,bullfighting,camping,canals,cards,carpentry
    case chemistry, chess, christian,church_architecture,civil_engineering,clock_making
    case clothing, coffee,commerce,commercial_fishing,complementary_medicine,computing
    case cooking,cosmetics,cricket,crime,croquet,crystallography,currency,cycling
    case dance,dentistry,drink,dyeing,early_modern_history,ecclesiastical
    case ecology,economics,education,egyptian_history,electoral,electrical,electronics,element
    case english_civil_war,falconry,farming,fashion,fencing,film,finance,fire_service,first_world_war
    case fish, food, forestr,freemasonry,french_revolution,furniture,gambling,games,gaming,genetics
    case geography,geology,geometry,glassmaking,golf,goods_vehicles,grammar,greek_histroy,gymnastics
    case hairdressing,handwriting,heraldry,hinduism,history,hockey,honour,horology,horticulture,hotels
    case hunting,insect,instruments,intelligence,invertebrate,islam,jazz,jewellery
    case journalism,judaism,knitting,language,law,leather,linguistics
    case literature,logic,lower_plant,mammal,marriage,martial_arts
    case mathematics,measure,mechanics,medicine,medieval_histor
     case metallurgy,meteorology,microbiology,military,military_history
     case mineral,mining,motor_racing,motoring,music,mountaineering,musical_direction,mythology
    case napoleonic_wars,narcotics,nautical,naval,needlework,numismatics,occult,oceanography
    case office, oil_industry,optics,palaeontology,parliament,pathology,penal
   case people,pharmaceutics,philately,philosophy,phonetics,photography,physics
    case physiology,plant,plumbing,politics, police,popular_music,postal,potter,printing,professions
    case prosody,psychiatry,psychology,publishing,racing,railways,rank,relationships
    case religion, reptile,restaurants,retail,rhetoric, riding,roads,rock,roman_catholic_church
    case roman_history,rowing,royalty,rugby,savoury,scouting,second_world_war
    case sex,shoemaking,sikhism,skateboarding,skating,skiing,smoking,snowboarding,soccer
    case sociology,space,sport,statistics,stock_exchange,surfing,surgery,surveying,sweet,swimming
    case tea, team_sports,technology,telecommunications,tennis,textiles,theatre,theology,timber,title
      case tools, trade_unionism,transport,university,variety,veterinar,video
    case war_of_american_independence,weapons,weightlifting,wine,wrestling,yoga,zoology


}

enum OxfordLanguageRegister: String{
    case allusive
    case archaic
    case allusively
    case army_slang
    case black_english
    case coarse_slang
    case cant
    case college_slang
    case concrete
    case contemptuous
    case dated
    case depreciative,depreciatively
    case derogatory
    case dialect
    case dismissive
    case disused
    case emphatically
    case especially
    case euphemism
    case euphemistic
    case figurative
    case generally
    case historical
    case humorous, humorously
    case hyperbolical, hyperbolically
    case informal
    case ironic, ironically
    case literal
    case literary
    case military_slang
    case nautical_slang
    case nursery
    case obsolete
    case offensive
    case personified
    case poetic
    case police_slang
    case prison_slang
    case proverb
    case pseuodo_archaic
    case rare,rarely
    case rhyming_slang
    case school_slang
    case slang
    case technical
    case temporary
    case theatrical_slang
    case trademark
    case trademark_in_uk
    case trademark_in_us
    case transferred
    case university_slang
    case vulgar_slang
    
    case non_standard = "non-standard"
    case nonce_use = "nonce-use"
    case RAF_slang = "R.A.F_slang"
 
    /**
=     case children%27S_Slang
     case criminals%27_Slang
     case journalists%27_Slang
        case services%27_Slang
        case showmen%27S_Slang
     case children_slang = "children%27S_Slang"
     case criminal_slang = "criminals%27_slang"
    **/
}

enum OxfordHTTPStatusCode: Int{
    case Success = 200
    case BadRequest = 400
    case AuthenticationFailed = 403
    case NotFound = 404
    case InternalServerError = 500
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case OtherStatusCode
    
    func statusCodeMessage() -> String{
        switch self {
        case .AuthenticationFailed:
            return "The request failed due to invalid credentials.Please check that the app_id and app_key are correct, and that the URL you are trying to access is correct. These can be found in the API Credentials page"
        case .BadGateway:
            return "Oxford Dictionaries API is down or being upgraded."
        case .BadRequest:
            return "The request was invalid or cannot be otherwise served. An accompanying error message will explain further.For example, when the filters provided are unknown, the source and target languages in the translation endpoint are the same, or a numeric parameter such as offset and limit in the wordlist endpoint cannot be evaluated as a number."
        case .GatewayTimeout:
            return "The Oxford Dictionaries API servers are up, but the request couldn’t be serviced due to some failure within our stack. Please try again later."
        case .InternalServerError:
            return "Something is broken. Please contact us so the Oxford Dictionaries API team can investigate."
        case .NotFound:
            return "No information available or the requested URL was not found on the server.For example, when the headword could not be found, a region or domain identifier do not exist, or the headword does not contain any attribute that match the filters in the request. It may also be the case that the URL is misspelled or incomplete."
        case .ServiceUnavailable:
            return "The Oxford Dictionaries API servers are up, but overloaded with requests. Please try again later."
        case .Success:
            return "Success!"
        case .OtherStatusCode:
            return "Unknown http status code received"
        default:
            return "Unknown http status code received"
        }
    }
    
}

enum OxfordLexicalCategory: String{
    
    case noun, verb
    case combining_form
    case adjective,adverb
    case conjunction, contraction
    case determiner,idiomatic,interjection
    case numeral, particle, other
    case predeterminer, prefix, suffix 
    case preposition,pronoun,residual
    
    
    
    static let allPartsOfSpeech: [OxfordLexicalCategory] = [
        .noun, .verb, .combining_form, .adjective, .adverb, .conjunction, .contraction,
        .determiner, .idiomatic, .interjection, .numeral, .particle, .other,
        .predeterminer, .prefix,.suffix,.preposition,.pronoun,.residual
    ]
}

enum OxfordGrammaticalFeature: String{
    
    //mass
    case mass
    
    //collectivity
    case collective
    
    //adjective function
    case attributive
    case predicative
    
    //subcategorization
    case intransitive
    case transitive
    
    //auxiliary
    case auxiliary
    
    //residual
    case abbreviation
    case symbol
    
    case interrogative
    case possessive
    case relative
    
    //person
    case third
    
    //unit structure
    case phrasal
    
    //number
    case singular
    case plural
    
    //numeral
    case cardinal
    case ordinal
    
    //tense
    case past
    case present
    
    //degree
    case comparative
    case positive
    case superlative
    
    //event modality
    case modal
    
    //gender
    case feminine
    
    //mood
    case conditional
    case subjunctive
    
    //non finiteness
    case infinitive
    case past_participle
    case present_participle
    
}


