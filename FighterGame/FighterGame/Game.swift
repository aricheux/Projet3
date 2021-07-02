//
//  Game.swift
//  FighterGame
//
//  Created by Yoan on 22/06/2021.
//

import Foundation

class Game {
    var playerOne: Player
    var playerTwo: Player
    var index = 1
    var choice = ""
    var numberRound : Int = 0
    var present: Weapons?
    
    //on initialise le nom des joueurs par défaut
    init() {
        playerOne = Player(name: "Player 1")
        playerTwo = Player(name: "Player 2")
    }
    
    func startNewGame() {
        // on créée les équipes des joueurs 1 et 2
        gameCreateTeam(player: playerOne)
        gameCreateTeam(player: playerTwo)
        
        //combat tour par tour jusqu'a la sortie de la fonction
        roundByRound()
        
        // les caractéristiques du jeux que l'on informe
        //nombre de tour du jeux
        print("\nYou have played \(numberRound) round"
                
                //liste de l'équipe 1 avec les caractéristiques de chaque personnage
                + "\n############ \(playerOne.name) your team was: ")
        playerOne.listTeam()
        
        //liste de l'équipe 1 avec les caractéristiques de chaque personnage
        print("\n############ \(playerTwo.name) your team was: ")
        playerTwo.listTeam()
        print("Game Over")
    }
}



// check character name already exist
extension Game {
    
    func gameCreateTeam(player: Player) {
        print("-----\(player.name) begin----")
        
        // on boucle tant que nous n'avons pas nos 3 personnages
        for index in 1...3 {
            print("Enter name of personage \(index)")
            
            // on récupère le nom du joueur inscrit par l'utilisateur
            var newName = readLine()
            
            // on boucle tant que characterNameExist n'est pas different de faux
                while characterNameExist(newName: newName ?? "") == false {
                    
                    //sinon on demande un nouveau nom
                    newName = readLine()
                }
            
            // créée une nouvelle personne
            let newPerson: Character = Character(newName: newName ?? "")
                newPerson.name = newName ?? ""
                print("\(newPerson.name) has added in your team ")
                player.team.append(newPerson)
        }
        print("Successful! \n your team is create")
        print("-------\(player.name) your team is: -----------")
    }
    
    func characterNameExist(newName: String) ->Bool {
        // on vérifie que le paramètre soit bien renseigné sinon la fonction renvoie la valeur faux avec le message associé.
        if newName == "" {
            print("I don't understand your response. \nTry again please.")
            return false
            
            // on vérifie que le nom ne soit pas présent dans une des deux équipes
        } else if  playerOne.checkNameAlreadyExist(newName: newName) || playerTwo.checkNameAlreadyExist(newName: newName) { // on vérifie dans les deux équipes le nom
            print("This name already exist in a teams. \nTry again please.")
            return false
        } else {
            return true
        }
    }
}





// fight round by round
extension Game {
    
    private func roundByRound() {
        // on initialise le bonus avec un nombre aléatoire de 1 à 5
        var bonus : Int = Int.random(in: 1...5)
        choice = ""
        
        // on vérifie que gameContinue ne soit pas faux
        while gameContinue {
            
            // on ajoute un aux nombre de tour
            numberRound += 1
            
            // on vérifie que le nombre de tour correspond au nombre bonus
            if numberRound == bonus {
                
                //on informe l'utilisateur qu'il a obtenu u bonus et on initialise le cadeau "present" avec une arme aléatoire
                print("You have bonus")
                present = randomBonus()
                
                // ajoute un nombre aléatoire pour le prochain bonus
                bonus += Int.random(in: 1...5)
            } else {
                
                // sinon le cadeau vaut nil
                present = nil
            }
            
            // on vérifie qui doit jouer
            if playerOne.playing == true {
                print("\(playerOne.name) Attack !")
                
                // on force a renter dans la boucle while
                choice = ""
                while choice == "" {
                    
                    // on demande ce que l'utilisateur veut effectuer
                    print("What do you want do: " + "\n- 1 - Attack" + "\n- 2 - Healing")
                    choice = readLine() ?? ""
                    switch choice {
                    case "1":
                        
                        // on fait une attack
                        playerOne.attack(playerDefense: playerTwo, weaponBonus: present)
                    case "2":
                        
                        // on soigne
                        playerOne.healing()
                    default:
                        print("I don't understand your response. \nTry again please")
                        choice = ""
                    }
                }
                // une fois l'acton faite on décharge le cadeau et on change le tour du joueur
                present = nil
                playerOne.playing = false
                playerTwo.playing = true
                
            } else {
                // même commentaire que précédemment mais pour le joueur 2
                print("\(playerTwo.name) Attack !")
                choice = ""
                while choice == "" {
                    print("What do you want do: " + "\n- 1 - Attack" + "\n- 2 - Healing")
                    choice = readLine() ?? ""
                    switch choice {
                    case "1":
                        playerTwo.attack(playerDefense: playerOne, weaponBonus: present)
                    case "2":
                        playerTwo.healing()
                    default:
                        print("I don't understand your response. \nTry again please")
                        choice = ""
                    }
                }
                present = nil
                playerOne.playing = true
                playerTwo.playing = false
            }
        }
    }
}


// create bonus
extension Game {
    private func randomBonus()-> Weapons{
        
        // on créée un tableau avec les armes bonus
        let cataloguesWeapons: [Weapons] = [Knife(), Gun(), Rocket(), Boomerang(), Flamethrower(), Rifle(), Grenade()]
        
        //on récupère la valeur max du tableau
        let max = cataloguesWeapons.count - 1
        
        // on sélectionne aléatoirement une arme
        return cataloguesWeapons[Int.random(in: 0...max)]
    }
}
