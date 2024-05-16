# DogLovers

## Description

DogLovers is an app designed to help users remember different dog breeds. It provides users with pictures of dogs and asks them to identify the breed. The app aims to give users a sense of satisfaction when they correctly identify the breed.

## Features

You can play a memory game less than 5 minutes each day to help you recognize every puppy you meet.

- `DogCards`: Prompt users to choose the right breed from a selection of dog images.
- `DogGround`: Display the overall progress of the memory game.

## Requirement Analysis

### Requirement

A good friend of yours loves dogs, but struggles to remember which breed is which. They have approached you to see if you can build an app that will help them remember. They’d love an app that shows them a picture of a dog and asks them which breed it is- and gives them a warm sense of satisfaction when they get it right.

### Key Parts Analysis

Use MVC structure to structe the application.

there will be three main parts of this app, each quote represent a key module in the application.

- `Memory` the `Dog`: shows them a picture of a dog and asks them which breed it is.
- `Game`: gives them a warm sense of satisfaction when they get it right.

#### Controller

As the features described, each key feature with a controller.
Prototype as bellow:
![Prototype](/Prototype.png)

- `DogCardsController`: Play the memory game in this controller.
  - Use `CardView` to present the interactive game card.
  - Interact with `Memory` and `Dog` module to update/get information and fill the view.
- `DogGroundController`: Display the progress info and start the game from here.
  - Interact with `Game` and `Memory` module to present the status.
  - Display some `Dog` information with `Memory` status.
  - Display a start button to start the memory game

#### View

- `CardView`: Subview of CollectionView to display CardCell one by one horizontally.
  - `CardCell`: one image with four choice button.

#### Model

##### Dog

- Role: provide all the meta information of the dogs. Including breed/subbreed and images.
- Key Functionality:
  - fetch and cache all data from [API](https://dog.ceo/dog-api/documentation)
  - provide query ability: query all breeds, query images by breed/subbreed

##### Memory

- Role: save and maintain the memory prograss of all `Dog` and provide the `Dog` to remember simply based on the one-time click results
- Key Funcationality:
  - Get current overall memory prograss
  - Update and save memory results(correct/worng, updateTime by day) on each dog.
  - Provide suggestion dogs to remember.

##### Game

- Role: provide positive game status based on the `Remeber` prograss
- Key Funcationality:
  - Get game progress

## Future Enhancements

- add two different types of game: select breed by image and select the right image by breed.
- add notification to notify the user to play.
- use ebbinghaus memory curve to remember breed, [forgetting curve theory](https://en.wikipedia.org/wiki/Forgetting_curve)
