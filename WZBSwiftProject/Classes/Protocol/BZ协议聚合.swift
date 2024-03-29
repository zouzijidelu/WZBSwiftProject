//
//  BZ协议聚合.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/11/26.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

protocol Record: CustomStringConvertible{

    var wins: Int {get}
    var losses: Int {get}
}

extension Record{

    var description: String{
        return String(format: "WINS: %d , LOSSES: %d", arguments: [wins,losses])
    }

    var gamePlayed: Int{
        return wins + losses
    }

    func winningPercent() -> Double {
        return Double(wins)/Double(gamePlayed)
    }
}

protocol Tieable {
    var ties: Int {get set}
}

extension Record where Self: Tieable{

    var gamePlayed: Int{
        return wins + losses + ties
    }

    func winningPercent() -> Double {
        return Double(wins)/Double(wins + losses + ties)
    }
}

protocol Prizable{

    func isPrizable() -> Bool
}


struct BasketballRecord: Record, Prizable{

    var wins: Int
    var losses: Int

    func isPrizable() -> Bool{
        return wins > 2
    }
}

struct BaseballRecord: Record, Prizable{

    var wins: Int
    var losses: Int
    let gamePlayed = 162

    func isPrizable() -> Bool{
        return gamePlayed > 10 && winningPercent() >= 0.5
    }
}

struct FootballRecord: Record, Tieable, Prizable{
    var wins: Int
    var losses: Int
    var ties: Int

    func isPrizable() -> Bool{
        return wins > 1
    }
}


var basketballTeamRecord = BasketballRecord(wins: 2, losses: 10)
var baseballTeamRecord = BaseballRecord(wins: 10, losses: 5)
var footballTeamRecord = FootballRecord(wins: 1, losses: 1, ties: 1)

//这里表面传递进来的one不仅要遵守Prizable协议还要遵守CustomStringConvertible协议
func award(one: CustomStringConvertible & Prizable){

    if one.isPrizable(){
        print(one)
        print("Congratulation! You won a prize!")
    }
    else{
        print(one)
        print("You can not have the prize!")
    }
}

//使用
func test1() {
    award(one: baseballTeamRecord)
}




struct Student: CustomStringConvertible, Prizable{//description是CustomStringConvertible必须实现的属性
    var name: String
    var score: Int
    var description: String{
        return name
    }

    func isPrizable() -> Bool {
        return score >= 60
    }
}
//使用
func test2() {
    let liuyubobobo = Student(name: "liuyubobobo", score: 100)
    award(one: liuyubobobo)
}

