//
//  Pokemon.swift
//  Pokédex 2
//
//  Created by Ben Burford on 23/09/2016.
//  Copyright © 2016 Ben Burford. All rights reserved.
//

import Foundation
import GameplayKit

class Pokemon: NSObject {
    
    var dataSource: PokemonDataManager
    var name: String
    var level: Int
    var number: Int
    var evolutions = [String]()
    //var lastUpdate: String
    //var UUID: String
    
    var baseHP: Int
    var baseAtt: Int
    var baseDef: Int
    var baseSpecAtt: Int
    var baseSpecDef: Int
    var baseSpeed: Int
    
    var bonusHP: Int
    var bonusAtt: Int
    var bonusDef: Int
    var bonusSpecAtt: Int
    var bonusSpecDef: Int
    var bonusSpeed: Int
    
    
    init(name:String, level:Int?, savedStats:Dictionary <String, AnyObject>?, data:PokemonDataManager) {
        
        self.name = name
        
        self.dataSource = data
        let baseStats = self.dataSource.allPokemon()[self.name]!
        
        self.evolutions = baseStats["Evolutions"]! as! Array <String>
        
        self.number = baseStats["Number"] as! Int
        self.baseHP = baseStats["HP"] as! Int
        self.baseAtt = baseStats["Attack"] as! Int
        self.baseDef = baseStats["Defence"] as! Int
        self.baseSpecAtt = baseStats["Special Attack"] as! Int
        self.baseSpecDef = baseStats["Special Defence"] as! Int
        self.baseSpeed = baseStats["Speed"] as! Int
        
        /*if savedStats != nil {
            self.lastUpdate = savedStats!["Last Update"] as! String
            self.UUID = savedStats!["UUID"] as! String
        } else {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyy HH:mm:ss a +zzzz"
            let date = NSDate.init()
            let dateString = formatter.string(from: date as Date)
            self.lastUpdate = dateString
            self.UUID = NSUUID().uuidString
        }*/
        
        if let bonusStats = savedStats {
            
            self.level = bonusStats["Level"] as! Int
            self.bonusHP = bonusStats["Bonus HP"] as! Int
            self.bonusAtt = bonusStats["Bonus Attack"] as! Int
            self.bonusDef = bonusStats["Bonus Defence"] as! Int
            self.bonusSpecAtt = bonusStats["Bonus Special Attack"] as! Int
            self.bonusSpecDef = bonusStats["Bonus Special Defence"] as! Int
            self.bonusSpeed = bonusStats["Bonus Speed"] as! Int
            
        } else {
            
            func oneToTen() -> Int {
                return Int(arc4random_uniform(10) + 1)
            }
            
            self.level = 1
            self.bonusHP = oneToTen()
            self.bonusAtt = oneToTen()
            self.bonusDef = oneToTen()
            self.bonusSpecAtt = oneToTen()
            self.bonusSpecDef = oneToTen()
            self.bonusSpeed = oneToTen()
            
        }
        
        super.init()
        
        if let selectedLevel = level {
            if selectedLevel > 1 {
                for _ in (self.level + 1) ... selectedLevel {
                    levelUp()
                }
            }
        }
    }
    
    func getNumber() -> Int {
        return self.number
    }
    
    func HP() -> Int {
        let HP = self.baseHP + self.bonusHP
        return HP
    }
    
    func attack() -> Int {
        let attack = self.baseAtt + self.bonusAtt
        return attack
    }
    
    func defence() -> Int {
        let defence = self.baseDef + self.bonusDef
        return defence
    }
    
    func specAttack() -> Int {
        let specAttack = self.baseSpecAtt + bonusSpecAtt
        return specAttack
    }
    
    func specDefence() -> Int {
        let specDefence = self.baseSpecDef + self.bonusSpecDef
        return specDefence
    }
    
    func speed() -> Int {
        let speed = self.baseSpeed + self.bonusSpeed
        return speed
    }
    
    func attackMod() -> Int {
        let mod = attack()/5
        return mod
    }
    
    func defenceMod() -> Int {
        let mod = defence()/10
        return mod
    }
    
    func specAttackMod() -> Int {
        let mod = specAttack()/5
        return mod
    }
    
    func specDefenceMod() -> Int {
        let mod = specDefence()/10
        return mod
    }
    
    func speedMod() -> Int {
        let mod = speed()/10
        return mod
    }
    
    func levelUp() {
        
        self.level += 1
        self.bonusHP += 1
        self.bonusHP += 1
        self.bonusAtt += 1
        self.bonusDef += 1
        self.bonusSpecAtt += 1
        self.bonusSpecDef += 1
        self.bonusSpeed += 1
        
        var statArray: [String] = ["HP", "Attack", "Defence", "SpecAttack", "SpecDefence", "Speed"]
        statArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: statArray) as! [String]
        
        let selectedStats: [String] = [statArray[0], statArray[1]]
        
        for stat in selectedStats {
            switch stat {
            case "HP":
                self.bonusHP += 1
            case "Attack":
                self.bonusAtt += 1
            case "Defence":
                self.bonusDef += 1
            case "SpecAttack":
                self.bonusSpecAtt += 1
            case "SpecDefence":
                self.bonusSpecDef += 1
            case "Speed":
                self.bonusSpeed += 1
            default:
                print("Error")
            }
        }
        
        //update()
    }
    
    func evolveInto(evolvedName: String) {
        let allPokemon = self.dataSource.allPokemon()
        let evolvedForm = allPokemon[evolvedName]
        self.name = evolvedName
        self.number = evolvedForm!["Number"]! as! Int
        self.evolutions = evolvedForm!["Evolutions"]! as! Array<String>
        self.baseHP = evolvedForm!["HP"]! as! Int
        self.baseAtt = evolvedForm!["Attack"]! as! Int
        self.baseDef = evolvedForm!["Defence"]! as! Int
        self.baseSpecAtt = evolvedForm!["Special Attack"]! as! Int
        self.baseSpecDef = evolvedForm!["Special Defence"]! as! Int
        self.baseSpeed = evolvedForm!["Speed"]! as! Int
        //update()
    }
    
    /*func update() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyy HH:mm:ss a +zzzz"
        let date = NSDate.init()
        let dateString = formatter.string(from: date as Date)
        self.lastUpdate = dateString
    }*/
}
