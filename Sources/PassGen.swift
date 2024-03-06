// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser

@main
struct PassGen: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "Reversible Secure Password Generator",
        usage: """
                passgen <platform> [OPTIONS]
                """,
        discussion: """
                This tool is designed to create safer, unique, and easily recoverable passwords for different platforms. By inputting just the name of the platform (like "Facebook" or "Gmail") and a personal seed (a unique key you choose), PassGen generates a secure password. The beauty of this approach is that the same password can be regenerated anytime by providing the same platform name and seed, eliminating the need to store your passwords externally.
                """)
    
    @Argument(help: "The name of the platform, eg. ‘Gmail’.")
    var platform: String
    
    @Option(name: .shortAndLong,help: "Your personal seed.")
    var seed: String
    
    @Option(name: .shortAndLong, help: "Creates a password with a specific lenght.")
    var lenght: Int = 8
    
    @Flag(help: "Creates long password")
    var long = false
    
    @Flag(help: "Shows the password generation process")
    var verbose = false
    
    func verbosePrint(_ text: String) {
        if verbose == true {
            print(text)
            sleep(1)
        }
    }
    
    mutating func run() throws {
        
//------- SETUP DAS LISTAS
        
        //cria o seedAlphabet[]
        var seedAlphabet: [String] = []
        while seedAlphabet.count < 26 {
            for letter in seed {
                if seedAlphabet.count < 26 {
                    seedAlphabet.append(String(letter))
                }
            }
        }
        
        //cria o seednumbers[]
        var seedNumber: [Int] = []
        let alphabetNumbersDict: [String: Int] = ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9, "j": 10, "k": 11, "l": 12, "m": 13, "n": 14, "o": 15, "p": 16, "q": 17, "r": 18, "s": 19, "t": 20, "u": 21, "v": 22, "w": 23, "x": 24, "y": 25, "z": 26]
        
        for letter in seed {
            if let number = Int(String(letter)) {
                seedNumber.append(number)
            } else if let number = alphabetNumbersDict[String(letter).lowercased()] {
                seedNumber.append(number)
            }
            
            if seedNumber.count >= 10 {
                break // Break the loop if seedNumber has reached 9 elements
            }
        }
        
        //cria o seedSpecial[]
        var seedSpecial: [String] = []
        
        while seedSpecial.count < 10 {
            for number in seedNumber {
                if seedSpecial.count < 10 {
                    if number.isMultiple(of: 5) {
                        seedSpecial.append("#")
                        continue
                    }
                    if number.isMultiple(of: 6){
                        seedSpecial.append("@")
                        continue
                    }
                    if number.isMultiple(of: 3){
                        seedSpecial.append("&")
                    }
                    else {
                        seedSpecial.append("/")
                    }
                }
            }
        }
        
        verbosePrint("...encrypted lists created from seed")
       
//------- INICIO DA CRIAÇÃO DE SENHA
        
        //troca letras por seedAlphabet
        var password: [String] = []
        
        for letter in platform {
            password.append(String(letter))
        }
        
//        for index in password.indices {
//            if index > 3 {
//                password[index] = seedAlphabet[alphabetNumbersDict[password[index].lowercased()]!]
//            }
//        }
        for index in password.indices {
            if index.isMultiple(of: 2){
                password[index] = seedAlphabet[alphabetNumbersDict[password[index].lowercased()]!]
            }
        }
        
        verbosePrint("...password letters changes for encrypted alphabet")

        
        //adiciona os números do seedNumber
        var index = 0
        var count = 0
        
        while count < 9 {
            if index == password.count {
                break
            }
            if index.isMultiple(of: 3){
                password.insert(String(seedNumber[Int(count)]), at: index)
                count = count+1
            }
            index += 1
        }
        
        verbosePrint("...numbers added to the password")
        
        
        
        //adiciona os caracteres especiais
        
//        password[2] = seedSpecial[2]
        
        count = 0
        
        for index in password.indices {
            if count == 1 {
                break
            }
            if Int(String(password[index])) != nil {
                password[index] = seedSpecial[count]
                count += 1
            }
        }
        
        verbosePrint("...special characters added to the password")
        
        //Adiciona uma letras maiúsculas
        
        password.insert(String(platform.prefix(1)).uppercased(), at: 0)
       
        verbosePrint("...upper cased letter added to the password")
        
//------- OPTIONS
        
        //--long
        let longPassword = password
        if long == true {
            // aumentar senha
            verbosePrint("...making it longer")
        }
        
        //--lenght
        password = Array(password[0..<lenght+1])
        verbosePrint("...making the size you want")

        
        
//------- Prints senha final
        
        print("\nYour password is \(password.joined())")
        
    }
}
