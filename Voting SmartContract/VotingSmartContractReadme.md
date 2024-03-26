# Voting Smart Contract

This Solidity smart contract simulates a basic voting system for an election process. It allows candidates to register, voters to register and cast their votes, and the election commissioner to manage the voting process.

## Contract Overview

The smart contract consists of two main structs: `Voter` and `Candidate`. It also includes functionalities for candidate and voter registration, casting votes, managing the voting period, and determining the election result.

## Functionality

### Candidate Registration

Candidates can register themselves for the election by providing their name, party affiliation, age, and gender.

### Voter Registration

Voters can register themselves for the election by providing their name, age, and gender.

### Vote Casting

Registered voters can cast their votes for a candidate by specifying the candidate's ID. Once a voter casts their vote, it cannot be changed.

### Voting Period Management

The election commissioner can set the start time and duration of the voting period. Voters can only cast their votes during this period.

### Voting Status

Voters and candidates can check the current status of the voting process, including whether it's in progress or has ended.

### Result Determination

Once the voting period ends, the election commissioner can determine the winner based on the number of votes received by each candidate.

### Emergency Stop

The election commissioner can stop the voting process in case of emergencies.

## Usage

1. Deploy the smart contract to a blockchain network.
2. Use the provided functions to register candidates and voters, manage the voting period, and determine the election result.
3. Interact with the contract through transactions to register candidates, register voters, cast votes, and manage the voting process.

## License

This smart contract is licensed under the [MIT License](LICENSE).


## Run and Test :
Use Remix Ide to run test and deploy.

## Author : Yash Rastogi