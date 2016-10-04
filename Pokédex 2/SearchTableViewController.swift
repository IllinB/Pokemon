//
//  SearchTableViewController.swift
//  Pokédex 2
//
//  Created by Ben Burford on 22/09/2016.
//  Copyright © 2016 Ben Burford. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol pokémonSelectedProtocol: class {
    func pokémonSelected(selectedPokemonName: String, pokeDataManager: PokemonDataManager, previousVC: SearchTableViewController)
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class SearchTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var dataManager: PokemonDataManager?
    weak var delegate: pokémonSelectedProtocol?
    var filteredPokemon = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.dataManager
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredPokemon.count
        } else {
            let allPokemon = dataManager!.allPokemon()
            return allPokemon.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let selectedPokemonNumber: Int
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedPokemonNumber = filteredPokemon[indexPath.row]
        } else {
            selectedPokemonNumber = dataManager!.pokemonNumberOrderArray()[indexPath.row]
        }
        let selectedPokemonName = dataManager!.pokemonNameDict()[selectedPokemonNumber]
        let pokemon = dataManager!.allPokemon()[selectedPokemonName!]
        let imageString = dataManager!.getPokemonImageStringForNumber(number: pokemon!["Number"] as! Int)
        cell.imageView!.image = UIImage(named:imageString)
        cell.textLabel?.text = selectedPokemonName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemonNumber: Int
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedPokemonNumber = filteredPokemon[indexPath.row]
        } else {
            selectedPokemonNumber = dataManager!.pokemonNumberOrderArray()[indexPath.row]
        }
        
        let selectedPokemonName = dataManager!.pokemonNameDict()[selectedPokemonNumber]
        
        self.delegate!.pokémonSelected(selectedPokemonName: selectedPokemonName!, pokeDataManager: dataManager!, previousVC: self)
        
        if let detailview = self.delegate as? SearchDetailsViewController {
            splitViewController?.showDetailViewController(detailview.navigationController!, sender: nil)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        var allPokemonNames = [String]()
        self.filteredPokemon.removeAll()
        let pokemonNameDict = dataManager!.pokemonNameDict()
        for pokemon in pokemonNameDict {
            allPokemonNames.append(pokemon.1)
        }
        var filteredNames = [String]()
        for pokemon in allPokemonNames {
            if pokemon.lowercased().contains(searchText.lowercased()) {
                filteredNames.append(pokemon)
            }
        }
        let sortedNames = filteredNames.sorted()
        let newPokemonDict = dataManager!.allPokemon()
        for name in sortedNames {
            self.filteredPokemon.append(newPokemonDict[name]!["Number"] as! Int)
        }
        
        self.tableView.reloadData()
    }
}
