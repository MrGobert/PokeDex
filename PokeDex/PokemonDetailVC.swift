//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by James Gobert on 12/14/15.
//  Copyright © 2015 EverydayDigitals. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defense: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIds: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttack: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var movesImg: UIImageView!
    @IBOutlet weak var movesDescLbl: UILabel!
    @IBOutlet weak var moveTitle: UILabel!
    @IBOutlet weak var moveLbl: UILabel!
    @IBOutlet weak var powerTitle: UILabel!
    @IBOutlet weak var powerLbl: UILabel!
    @IBOutlet weak var accTitle: UILabel!
    @IBOutlet weak var accLbl: UILabel!
    @IBOutlet weak var ppTitle: UILabel!
    @IBOutlet weak var ppLbl: UILabel!
    
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        nameLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        self.title = nameLbl.text
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        pokemon.downloadPokemonDetails { () -> () in
           //This closure will be called after download is done
            self.updateUI()
        }
    
    }
    
    func updateUI() {
        
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type.capitalizedString
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexLbl.text = "\(pokemon.pokedexId)"
        attackLbl.text = pokemon.attack
        
        moveLbl.text = pokemon.moveName
        movesDescLbl.text = pokemon.moveDesc
        powerLbl.text = "\(pokemon.movePower)"
        accLbl.text = "\(pokemon.moveAcc)%"
        ppLbl.text = "\(pokemon.movePP)"

        
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        }else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
                evoLbl.text = str
                
            }
        }
        
    }
    
  
    @IBAction func toggleBtnPressed(sender: UISegmentedControl) {
        
        

        if sender.selectedSegmentIndex == 1 {
            
        let image = UIImage(named: "\(pokemon.pokedexId)")
           movesImg.image = image
        
        
        descriptionLbl.hidden = true
        type.hidden = true
        typeLbl.hidden = true
        defense.hidden = true
        defenseLbl.hidden = true
        height.hidden = true
        heightLbl.hidden = true
        pokedexIds.hidden = true
        pokedexLbl.hidden = true
        weight.hidden = true
        weightLbl.hidden = true
        baseAttack.hidden = true
        attackLbl.hidden = true
        mainImg.hidden = true
        separator.hidden = true
            
        movesImg.hidden = false
        moveLbl.hidden = false
        movesDescLbl.hidden = false
        powerLbl.hidden = false
        accLbl.hidden = false
        ppLbl.hidden = false
        moveTitle.hidden = false
        powerTitle.hidden = false
        accTitle.hidden = false
        ppTitle.hidden = false
            
    updateUI()
        
            
        } else {
            
            descriptionLbl.hidden = false
            type.hidden = false
            typeLbl.hidden = false
            defense.hidden = false
            defenseLbl.hidden = false
            height.hidden = false
            heightLbl.hidden = false
            pokedexIds.hidden = false
            pokedexLbl.hidden = false
            weight.hidden = false
            weightLbl.hidden = false
            baseAttack.hidden = false
            attackLbl.hidden = false
            mainImg.hidden = false
            separator.hidden = false
            
            movesImg.hidden = true
            moveLbl.hidden = true
            movesDescLbl.hidden = true
            powerLbl.hidden = true
            accLbl.hidden = true
            ppLbl.hidden = true
            moveTitle.hidden = true
            powerTitle.hidden = true
            accTitle.hidden = true
            ppTitle.hidden = true
            
        }
    }

}
