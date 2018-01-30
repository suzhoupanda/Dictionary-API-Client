//
//  MWAPIDataStructures.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


enum ElementTag: String{
    
    /** Root Tag **/
    
    case AlphaSectionRoot = "alpha"
    
    /** Basic Entry Information **/
    
    case DictionaryEntry = "entry"
    case HeadWord = "hw"
    case FunctionalLabel = "fl"
    case Definition = "def"
    case Etymology = "et"
    case Pronunciation = "pr"
    case Subject = "subj"
    case AudioFile = "wav"
    
    /** Other Tags **/
    
    case Art = "art"
    case CognateCrossEntry = "cx"
    case Date = "date"
    case Table = "table"
    case Formula = "formula"
    
    case Inflections = "in"
        case InflectionLabel = "il" //inflection label
        case BoldfaceInflectedForm = "if" //boldface inflected form
        /** An optional pronuncation field is also possible for the inflections field **/
    case Label = "lb"
    case ListOfSelfExplanatoryUndefinedWords = "list"
    case ParagraphText = "pt"
    case Sense = "sense"
    case SenseNumber = "sn"
    case SenseNumberP = "snp"
    case SenseSpecificInflectionField = "sin"
    case Subject_StatusLabel = "sl"
    case AlternateHeadword = "ahw"
    case DefinedRunonEntry = "dro"
    case UndefinedRunonEntry = "uro"
    case SynonymCrossReference = "ss"
    case SynonymInAddition = "sa"
    case Usage = "us"
    case VariantSpelling = "vr"
        case VariantSpellingLabel = "vl"
        case VariantSpellingForm = "va"
    
    case VerbDivider = "vt"

    /** Formatting Tags **/
    
    case Bold = "bold"
    case BoldItalic = "bit"
    case Note = "note"
    case Superscript = "sup"
    case Subscript = "inf"
    case Italic = "it"
    case ItalicSmallCaps = "isc"
    case SmallCaps = "sc"
    case Roman = "rom"


}
