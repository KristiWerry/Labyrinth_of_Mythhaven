//
//  PlayerContext.swift
//  Labyrinth of Mythhaven
//
//  Created by William Ritchie on 12/17/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation

class SceneContext {
    private var _name: String?
    var name: String? {
        get {
            return _name
        }
        set {
            _name = newValue
            defaults.set(_name, forKey: "Name")
        }
    }
    
    private var _gender: String?
    var gender: String? {
        get {
            return _gender
        }
        set {
            _gender = newValue
            defaults.set(_gender, forKey: "Gender")
        }
    }
    
    private var _hp: Int?
    var hp: Int? {
        get {
            return _hp
        }
        set {
            _hp = newValue
            defaults.set(_hp, forKey: "HP")
        }
    }
    
    private var _attack: Int?
    var attack: Int? {
        get {
            return _attack
        }
        set {
            _attack = newValue
            defaults.set(_attack, forKey: "Attack")
        }
    }
    
    private var _defense: Int?
    var defense: Int? {
        get {
            return _defense
        }
        set {
            _defense = newValue
            defaults.set(_defense, forKey: "Defense")
        }
    }
    
    private var _currentLevel: Int?
    var currentLevel: Int? {
        get {
            return _currentLevel
        }
        set {
            _currentLevel = newValue
            defaults.set(_currentLevel, forKey: "CurrentLevel")
        }
    }
    
    private var _finalLevel: Int?
    var finalLevel: Int? {
        get {
            return _finalLevel
        }
        set {
            _finalLevel = newValue
            defaults.set(_finalLevel, forKey: "FinalLevel")
        }
    }
    
    var defaults: UserDefaults
    
    init (defaults: UserDefaults) {
        self.defaults = defaults
        _name = defaults.string(forKey: "Name")
        _gender = defaults.string(forKey: "Gender")
        _hp = defaults.integer(forKey: "HP")
        _attack = defaults.integer(forKey: "Attack")
        _defense = defaults.integer(forKey: "Defense")
        _currentLevel = defaults.integer(forKey: "CurrentLevel")
        _finalLevel = defaults.integer(forKey: "FinalLevel")
        guard _finalLevel != 0 else {
            finalLevel = Int.random(in: 4...10)
            return
        }
    }
}
