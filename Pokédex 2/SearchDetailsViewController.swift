//
//  SearchDetailsViewController.swift
//  Pokédex 2
//
//  Created by Ben Burford on 26/09/2016.
//  Copyright © 2016 Ben Burford. All rights reserved.
//

import Foundation
import UIKit

extension SearchDetailsViewController: pokémonSelectedProtocol {
    func pokémonSelected(selectedPokemonName: String, pokeDataManager: PokemonDataManager, previousVC: SearchTableViewController) {
        
        pokemonName = selectedPokemonName
        self.previousVC = previousVC
        pokemon = Pokemon.init(name: pokemonName, level: 0, savedStats: nil, data: pokeDataManager)
        self.dataManager = pokeDataManager
        dataForPokemon = dataManager!.allPokemon()[pokemonName]!
        
        configureView()
    }
}

class SearchDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelTextField: UITextField!
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
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func createButtonTapped(_ sender: AnyObject) {
        if pokemon != nil {
            dataManager!.saveNewPokemon(pokemon: pokemon!)
        }
        
        if let splitView = self.navigationController?.navigationController {
            splitView.popToViewController(previousVC!, animated: true)
        }
    }
    
    var pokemonName: String = ""
    var pokemon: Pokemon?
    var previousVC: SearchTableViewController?
    let notificationCenter = NotificationCenter.default
    var imageName: String = ""
    var dataManager: PokemonDataManager?
    var dataForPokemon = [String : AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonToKeyboard()
        
        levelTextField.delegate = self
        notificationCenter.addObserver(
            self,
            selector: #selector(SearchDetailsViewController.textFieldTextChanged(sender:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: nil
        )
        
        if pokemon == nil {
            print("Pokemon is nil")
            createButton.isEnabled = false
            createButton.titleLabel?.textColor = UIColor.gray
            print(createButton.titleLabel?.text)
        } else {
            createButton.isEnabled = true
            createButton.titleLabel?.textColor = UIColor.red
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldTextChanged(sender : AnyObject) {
        let level = Int(levelTextField.text!)
        pokemon = Pokemon.init(name: pokemonName, level: level, savedStats:nil, data: dataManager!)
        configureView()
    }
    
    func addDoneButtonToKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectFromString("{{0,0},{320,50}}"))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SearchDetailsViewController.doneButtonTapped))
        done.tintColor = UIColor.white
        let create: UIBarButtonItem = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.done, target:self, action: #selector(SearchDetailsViewController.secondCreateButtonTapped))
        create.tintColor = UIColor.white
        
        let items = [create, flexSpace, done]
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        levelTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonTapped() {
        levelTextField.resignFirstResponder()
    }
    
    func secondCreateButtonTapped() {
        createButtonTapped(self)
        textFieldTextChanged(sender: self)
    }
    
    func configureView() {
        
        if pokemon == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            dataManager = appDelegate.dataManager
            pokemon = Pokemon.init(name: "Bulbasaur", level: 0, savedStats: nil, data: dataManager!)
        }
        
        self.navigationItem.title = pokemonName
        imageName = dataManager!.getPokemonImageStringForNumber(number: pokemon!.getNumber())
        iconImageView.image = UIImage(named: imageName)
        nameLabel.text = self.pokemon!.name
        HPLabel.text = String(self.pokemon!.HP())
        attackLabel.text = String(self.pokemon!.attack())
        defenceLabel.text = String(self.pokemon!.defence())
        specialAttackLabel.text = String(self.pokemon!.specAttack())
        specialDefenceLabel.text = String(self.pokemon!.specDefence())
        speedLabel.text = String(self.pokemon!.speed())
        attackModLabel.text = String(self.pokemon!.attackMod())
        defenceModLabel.text = String(self.pokemon!.defenceMod())
        specialAttackModLabel.text = String(self.pokemon!.specAttackMod())
        specialDefenceModLabel.text = String(self.pokemon!.specDefenceMod())
        speedModLabel.text = String(self.pokemon!.speedMod())
    }
}

