//
//  PokemonDataManager.swift
//  Pokédex 2
//
//  Created by Ben Burford on 23/09/2016.
//  Copyright © 2016 Ben Burford. All rights reserved.
//

import Foundation
import CloudKit

class PokemonDataManager: NSObject {
    
    var allPokemonDict = [String:Dictionary <String, AnyObject>]()
    var savedPokemonArray = Array <Dictionary <String, AnyObject>>()
    
    override init() {
        super.init()
        getPokemonData()
    }
    
    func getPokemonImageStringForNumber(number: Int) -> String {
        let nsNumberValue = number as NSNumber
        var numberString = nsNumberValue.stringValue
        while numberString.characters.count < 3 {
            numberString = "0\(numberString)"
        }
        numberString = "\(numberString)MS.png"
        return numberString
    }

    func allPokemon() -> [String:Dictionary <String, AnyObject>] {
        return self.allPokemonDict
    }
    
    func savedPokemon() -> [Dictionary <String, AnyObject>] {
        return self.savedPokemonArray
    }
    
    func pokemonNumberOrderArray() -> [Int] {
        var array: [Int] = []
        for pokemon in self.allPokemonDict {
            let number = pokemon.1["Number"]! as! Int
            array.insert(number, at: 0)
        }
        array = array.sorted()
        return array
    }
    
    func pokemonNameDict() -> [Int: String] {
        var dict: [Int: String] = [:]
        for pokemon in self.allPokemonDict {
            let name = pokemon.0
            let number = pokemon.1["Number"]! as! Int
            dict[number] = name
        }
        
        return dict
    }
    
    func getPokemonData() {
        var dataPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("Data.txt")
        if !FileManager.default.fileExists(atPath: dataPath) {
            dataPath = Bundle.main.path(forResource: "Data", ofType: "txt")!
        }
        
        let pokemonData = NSData(contentsOfFile: dataPath)
        self.allPokemonDict = try! JSONSerialization.jsonObject(with: pokemonData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Dictionary <String, AnyObject>]
        
        let savedPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("Saved.txt")
        if !FileManager.default.fileExists(atPath: savedPath) {
            savedPokemonArray = []
        } else {
            let savedData = NSData(contentsOfFile: savedPath)
            savedPokemonArray = try! JSONSerialization.jsonObject(with: savedData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [Dictionary<String, AnyObject>]
        }
    }
    
    func savePokemonData() {
        print(savedPokemonArray)
        if JSONSerialization.isValidJSONObject(self.allPokemonDict) {
            let json = try! JSONSerialization.data(withJSONObject: self.allPokemonDict, options:JSONSerialization.WritingOptions.prettyPrinted)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("Data.txt")
            FileManager.default.createFile(atPath: path, contents: json, attributes: nil)
        }
        
        if JSONSerialization.isValidJSONObject(self.savedPokemonArray) {
            let json = try! JSONSerialization.data(withJSONObject: self.savedPokemonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("Saved.txt")
            FileManager.default.createFile(atPath: path, contents: json, attributes: nil)
        }
    }
    
    func saveNewPokemon(pokemon: Pokemon) {
        let newPokemonDict = ["Name": pokemon.name, "Level": pokemon.level, "Bonus HP": pokemon.bonusHP, "Bonus Attack": pokemon.bonusAtt, "Bonus Defence": pokemon.bonusDef, "Bonus Special Attack": pokemon.bonusSpecAtt, "Bonus Special Defence": pokemon.bonusSpecDef, "Bonus Speed": pokemon.bonusSpeed] as [String : Any]
        if JSONSerialization.isValidJSONObject(newPokemonDict) {
            savedPokemonArray.append(newPokemonDict as Dictionary<String, AnyObject>)
            let json = try! JSONSerialization.data(withJSONObject: savedPokemonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("Saved.txt")
            FileManager.default.createFile(atPath: path, contents: json, attributes: nil)
        }
    }
}
