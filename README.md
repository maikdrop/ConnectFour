# Connect Four Overview

## Author

* **Maik Müller** *Applied Computer Science (M. Sc.)* - [LinkedIn](https://www.linkedin.com/in/maik-m-253357107), [Xing](https://www.xing.com/profile/Maik_Mueller215/cv)

#### Background

<p align="justify">I finished my studies in <a href="https://ai-master.htw-berlin.de">Applied Computer Science</a> (B.Sc and M.Sc.) at the HTW University of Applied Science Berlin in January 2020. During my studies, I worked on several projects that contained app prototypes in the areas of public health and professional environments. All apps were written in Swift (I started with Swift 2.2 in 2016). The present project, ConnectFour, based on a coding challenge of a company.

## Table of Contents

* [1. About the App](#1-about-the-app)
  * [1.1. Goals](#11-goals)
  * [1.2. What's the Game About?](#12-whats-the-game-about)
  * [1.3. Game Features](#13-game-features)
  * [1.4. Technical Infos](#14-technical-infos)
* [2. Concept and Implementation](#2-concept-and-implementation)
  * [2.1. MVC Design Pattern](#21-mvc-design-pattern)
  * [2.2. Auto Layout](#22-auto-layout)
* [3. Network](#3-network)
* [4. Testing](#4-testing)

## 1. About the App

### 1.1. Goals

<p align="justify">Overall, the goal in all my projects is to gain knowledge in Swift and general iOS development.</p>

There were two subgoals:

* Implementing the MVC pattern ([chapter 2.1](#21-mvc-design-pattern))
* Autolayout for landscape and portrait orientation of an iPad ([chapter 2.2](#22-auto-layout))

### 1.2. What's the Game About?

<p>Wikipedia: <a href="https://en.wikipedia.org/wiki/Connect_Four">Connect Four</a></p>

### 1.3. Game Features

The following game features haven been implemented:

* 2 players play against each other on the device
* the player names can be changed
* the color configuration can be changed
* the play field has a grid layout of 6x7 columns
* the game is finished when either all fields are set or when one of the players have a row of 4 of their color diagonal, horizontal or vertical

### 1.4. Technical Infos

The following list contains the most important technical informations about the app:

* Development Environment: Xcode
* Interface: Storyboard
* Life Cycle: UIKit App Delegate
* Language: Swift
* Deployment Info: iOS 15.0, iPad (portrait and landscape)

---

## 2. Concept and Implementation

### 2.1. MVC Design Pattern

<p align="justify">MVC stands for Model-View-Controller and consists, as the name stated, of three entities (model, view and controller). The controller has access to the model and can change it. If the model changes, the controller has to update the connected view. So, the view must always reflect the model data. There is no direct communication between the model and the view. The goal of this design pattern is to encapsule the business logic and make it reusable and better testable. In the present project the model implements the game logic.</p>

**Code Links:**
  * [ConnectFour](ConnectFour/Models/ConnectFour.swift)
  * [ConnectFourViewController](ConnectFour/Scenes/ConnectFourViewController.swift)

### 2.2. Auto Layout

<p align="justify">In order to play in portrait and landscape mode, the play field was implemented with several stack views building a 6x7 column grid layout. It has a 5:4 aspect ratio and a high constant width. Both constraints have a high priority (@750) and define the size of the play field. But it's needed to add more constraints to define the location withing the safe area. The following screenshots illustrate the play field in landscape and portrait mode.</p>

<br/>
<figure>
  <p align="center">
    <img src="/AutoLayoutLandscape.jpg" align="center" width="450">
     <p align="center">Screenshot 1: Game Scene Landscape; Source: Own Illustration
  </p>
</figure>
<br/>

<figure>
  <p align="center">
    <img src="/AutoLayoutPortrait.jpg" align="center" width="350">
     <p align="center">Screenshot 2: Game Scene Portrait; Source: Own Illustration
  </p>
</figure>
<br/>

## 3. Network

<p align="justify">Network requests are used to fetch possible game configurations from a local backend, which was created with Spring Boot. The configurations consist of default player names and color combinations. Screenshot 3 illustrates the list of the fetched and displayed colors. The default player names aren`t used in this list. Instead, the current player names will be used to reflect the possible colors. The checkmark on the right side shows the current selection.</p>
<br/>

<figure>
  <p align="center">
    <img src="/ColorConfigurationLandscape.jpg" align="center" width="450">
     <p align="center">Screenshot 3: Color Configuration List Landscape; Source: Own Illustration
  </p>
</figure>
<br/>

**Code Links:**
  * [ChooseColorTableViewController](ConnectFour/Scenes/ChooseColorTableViewController.swift)
  * [Network](ConnectFour/Helper/Utility Helper/Network.swift)
  * [Network](ConnectFour/Models/GameConfig.swift)

## 4. Testing

<p align="justify">Unit tests have been used to test and verify the game logic. It's tested if 4 discs in a row are detected horizotally, vertically and diagonally. Furthermore, it's tested when all fields are set.</p>

**Code Links:**
* [Unit tests](ConnectFourTests/ConnectFourTests.swift)
