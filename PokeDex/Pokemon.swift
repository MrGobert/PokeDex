//
//  Pokemon.swift
//  PokeDex
//
//  Created by James Gobert on 12/12/15.
//  Copyright © 2015 EverydayDigitals. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    private var _moveName: String!
    private var _moveDesc: String!
    private var _movePower: String!
    private var _movePP: String!
    private var _moveAcc: String!
    
    var description: String {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    
    
    var type: String {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var moveName: String {
        if _moveName == nil {
            _moveName = ""
        }
        return _moveName
    }
    
    var moveDesc: String {
        if _moveDesc == nil {
            _moveDesc = ""
        }
        return _moveDesc
    }
    
    var movePower: String {
        if _movePower == nil {
            _movePower = ""
        }
        return _movePower
    }
    
    var moveAcc: String {
        if _moveAcc == nil {
            _moveAcc = ""
        }
        return _moveAcc
    }
    
    var movePP: String {
        if _movePP == nil {
            _movePP = ""
        }
        return _movePP
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON{ (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0] ["name"] {
                        self._type = name
                        
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x] ["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0] ["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON{ (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
                            
                            if let descDict = result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                            
                        }
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0] ["to"] as? String {
                        //Can't support mega pokemon right now
                        //API still has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0] ["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvlExist = evolutions[0] ["level"] {
                                    if let lvl = lvlExist as? Int {
                                        self._nextEvolutionLvl = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvolutionLvl = ""
                                }
                                
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                            }
                            
                        }
                    }
                }
                
                if let moveArry = dict["moves"] as? [Dictionary<String, AnyObject>] where moveArry.count > 0 {
                    
                    if let moveUrl = moveArry[0]["resource_uri"] {
                        let NSMovesUrl = NSURL(string: "\(URL_BASE)\(moveUrl)")!
                        
                        Alamofire.request(.GET, NSMovesUrl).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
                        
                            if let movesDict = result.value as? Dictionary<String, AnyObject> {
                                
                                if let moveName = movesDict["name"] as? String {
                                    self._moveName = moveName
                                    print(self._moveName)
                                }
                                
                                if let movePower = movesDict["power"] as? Int {
                                    self._movePower = "\(movePower)"
                                    print(self._movePower)
                                } else {
                                    self._movePower = "N/A"
                                }
                                
                                if let movePP = movesDict["pp"] as? Int {
                                    self._movePP = "\(movePP)"
                                    print(self._movePP)
                                } else {
                                    self._movePP = "N/A"
                                }
                                
                                if let moveDesc = movesDict["description"] as? String {
                                    self._moveDesc = moveDesc
                                    print(self._moveDesc)
                                } else {
                                    self._moveDesc = "N/A"
                                }
                                
                                if let moveAcc = movesDict["accuracy"] as? Int {
                                    self._moveAcc = "\(moveAcc)"
                                    print(self._moveAcc)
                                } else {
                                    self._moveAcc = "N/A"
                                }
                            }
                            
                        }
                        
                    }
                    
                } else {
                    self._moveName = "N/A"
                }
                
            }
            
        }
    }
}


