//
//  StoredDetailViewController.swift
//  Pokédex 2
//
//  Created by Ben Burford on 23/09/2016.
//  Copyright © 2016 Ben Burford. All rights reserved.
//

import Foundation
import UIKit

extension StoredDetailViewController: StoredSelectionProtocol {
    
    func pokémonSelected(selectedPokemonObject: Pokemon, selectedIndex: Int, previousViewController: StoredCollectionViewController) {
        selectedPokemon = selectedPokemonObject
        index = selectedIndex
        previousVC = previousViewController
        /*let myDefaults = UserDefaults.standard
        if ((myDefaults.object(forKey: "Pokemon")) != nil) {
            myDefaults.set(nil, forKey: "Pokemon")
        }*/
        updateDisplay()
    }
}

class StoredDetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var HPLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var attackModLabel: UILabel!
    @IBOutlet weak var defenceModLabel: UILabel!
    @IBOutlet weak var specialAttackModLabel: UILabel!
    @IBOutlet weak var specialDefenceModLabel: UILabel!
    @IBOutlet weak var speedModLabel: UILabel!
    @IBOutlet weak var levelUpButton: UIButton!
    @IBOutlet weak var evolveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func levelUpButtonPushed(_ sender: AnyObject) {
        selectedPokemon?.levelUp()
        updateDisplay()
        saveChanges()
    }
    
    @IBAction func evolveButtonPushed(_ sender: AnyObject) {
        if selectedPokemon?.evolutions.count == 1{
            selectedPokemon?.evolveInto(evolvedName: selectedPokemon!.evolutions[0])
        } else if (selectedPokemon?.evolutions.count)! > 1 {
            //self.performSegue(withIdentifier: "multipleEvolutionSegue", sender: self)
            selectedPokemon?.evolveInto(evolvedName: selectedPokemon!.evolutions[0])
        }
        updateDisplay()
        saveChanges()
    }
    
    @IBAction func deleteButtonPushed(_ sender: AnyObject) {
        dataManager!.savedPokemonArray.remove(at: index!)
        dataManager!.savePokemonData()
        //dataManager!.deleteInCloud(selectedPokemon!.UUID)
        selectedPokemon = nil
        
        if let splitView = self.navigationController?.navigationController {
            splitView.popToViewController(previousVC!, animated: true)
        }
        
        updateDisplay()
        dataManager!.savePokemonData()
        previousVC?.collectionView?.reloadData()
    }
    
    var selectedPokemon: Pokemon?
    var index: Int?
    var previousVC: StoredCollectionViewController?
    var imageName: String = ""
    var dataManager: PokemonDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedPokemon?.name
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.dataManager
        updateDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateDisplay()
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "multipleEvolutionSegue" {
            let destinationVC = segue.destinationViewController as! EvolutionTableViewController
            destinationVC.selectedPokemon = selectedPokemon
            destinationVC.previousVC = self
            destinationVC.index = index
        }
    }*/
    
    func updateDisplay() {
        
        if selectedPokemon != nil {
            nameLabel.text = selectedPokemon!.name
            levelLabel.text = ("lvl. \(selectedPokemon!.level)")
            HPLabel.text = String(selectedPokemon!.HP())
            attackLabel.text = String(selectedPokemon!.attack())
            defenceLabel.text = String(selectedPokemon!.defence())
            specialAttackLabel.text = String(selectedPokemon!.specAttack())
            specialDefenceLabel.text = String(selectedPokemon!.specDefence())
            speedLabel.text = String(selectedPokemon!.speed())
            attackModLabel.text = String(selectedPokemon!.attackMod())
            defenceModLabel.text = String(selectedPokemon!.defenceMod())
            specialAttackModLabel.text = String(selectedPokemon!.specAttackMod())
            specialDefenceModLabel.text = String(selectedPokemon!.specDefenceMod())
            speedModLabel.text = String(selectedPokemon!.speedMod())
            imageName = dataManager!.getPokemonImageStringForNumber(number: selectedPokemon!.number)
            image.image = UIImage(named: imageName)
            if selectedPokemon!.evolutions.count == 0 {
                evolveButton.isEnabled = false
                evolveButton.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
            } else {
                evolveButton.isEnabled = true
            }
            self.navigationItem.title = selectedPokemon?.name
            
            if selectedPokemon!.name == "Phione" && selectedPokemon!.level == 100 {
                evolveButton.isEnabled = true
                evolveButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            }
            levelUpButton.isEnabled = true
            levelUpButton.titleLabel?.textColor = UIColor.red
            deleteButton.isEnabled = true
            deleteButton.titleLabel?.textColor = UIColor.red
            
        } else {
            nameLabel.text = ""
            levelLabel.text = ""
            HPLabel.text = ""
            attackLabel.text = ""
            defenceLabel.text = ""
            specialAttackLabel.text = ""
            specialDefenceLabel.text = ""
            speedLabel.text = ""
            attackModLabel.text = ""
            defenceModLabel.text = ""
            specialAttackModLabel.text = ""
            specialDefenceModLabel.text = ""
            speedModLabel.text = ""
            image.image = nil
            evolveButton.isEnabled = false
            evolveButton.titleLabel?.textColor = UIColor.gray
            levelUpButton.isEnabled = false
            levelUpButton.titleLabel?.textColor = UIColor.gray
            deleteButton.isEnabled = false
            deleteButton.titleLabel?.textColor = UIColor.gray
        }
    }
    
    func saveChanges() {
        /*let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        let date = NSDate.init()
        let dateString = formatter.string(from: date as Date)*/
        //selectedPokemon!.lastUpdate = dateString
        let dict = ["Name": selectedPokemon!.name as AnyObject, "Level": selectedPokemon!.level as AnyObject, "Bonus HP": selectedPokemon!.bonusHP as AnyObject, "Bonus Attack": selectedPokemon!.bonusAtt as AnyObject, "Bonus Defence": selectedPokemon!.bonusDef as AnyObject, "Bonus Special Attack": selectedPokemon!.bonusSpecAtt as AnyObject, "Bonus Special Defence": selectedPokemon!.bonusSpecDef as AnyObject, "Bonus Speed": selectedPokemon!.bonusSpeed as AnyObject] as [String : Any]
        dataManager!.savedPokemonArray[index!] = dict as [String : AnyObject]
        dataManager!.savePokemonData()
    }
}
