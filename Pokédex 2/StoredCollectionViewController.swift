//
//  StoredCollectionViewController.swift
//  Pokédex 2
//
//  Created by Ben Burford on 23/09/2016.
//  Copyright © 2016 Ben Burford. All rights reserved.
//

import Foundation
import UIKit

extension StoredCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let windowWidth = collectionView.frame.width
        let gapWidth = (windowWidth - 252)/3
        return UIEdgeInsets(top: 20.0, left: gapWidth, bottom: 20.0, right: gapWidth)
    }
}

protocol StoredSelectionProtocol: class {
    func pokémonSelected(selectedPokemonObject: Pokemon, selectedIndex: Int, previousViewController: StoredCollectionViewController)
}

class StoredCollectionViewController: UICollectionViewController {
    
    var savedPokemonData = [Dictionary <String, AnyObject>]()
    var allPokemonData = [String: Dictionary <String, AnyObject>]()
    weak var delegate: StoredSelectionProtocol?
    var dataManager: PokemonDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.dataManager
        savedPokemonData = dataManager!.savedPokemonArray
        allPokemonData = dataManager!.allPokemonDict
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedPokemonData = dataManager!.savedPokemonArray
        self.collectionView!.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPokemonData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPaths = self.collectionView!.indexPathsForSelectedItems
        let selectedPath = indexPaths![0]
        let pokemonData = self.savedPokemonData[selectedPath.row]
        let name = pokemonData["Name"] as! String
        let selectedPokemon = Pokemon.init(name: name, level: nil, savedStats: pokemonData, data: dataManager!)
        
        self.delegate!.pokémonSelected(selectedPokemonObject: selectedPokemon, selectedIndex: selectedPath.row, previousViewController: self)
        if let detailViewController = self.delegate as? StoredDetailViewController {
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PokemonCollectionViewCell
        cell.nameTextField!.text = "\(savedPokemonData[indexPath.row]["Name"] as! String)"
        cell.levelTextField!.text = "lvl. \(savedPokemonData[indexPath.row]["Level"]!)"
        let number = allPokemonData[savedPokemonData[indexPath.row]["Name"] as! String]!["Number"]
        let imageName = dataManager!.getPokemonImageStringForNumber(number: number as! Int)
        cell.pokemonImageView!.image = UIImage(named:imageName)
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 10.0
        return cell
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "PokemonDetailSegue" {
                let navController = segue.destination as! UINavigationController
                let destinationVC = navController.viewControllers.first as! StoredDetailViewController
                let indexPaths = self.collectionView!.indexPathsForSelectedItems
                let selectedPath = indexPaths![0]
                let pokemonData = self.savedPokemonData[selectedPath.row]
                let name = pokemonData["Name"] as! String
                let selectedPokemon = Pokemon.init(name: name, level: nil, savedStats: pokemonData, data: dataManager!)
                destinationVC.selectedPokemon = selectedPokemon
                destinationVC.index = selectedPath.row
                destinationVC.previousVC = self
            }
        }
}
