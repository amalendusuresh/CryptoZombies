 pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

/// @title A contract that create ZombieFactory
/// @author Amalendu Suresh

contract ZombieHelper is ZombieFeeding {

 // Modifier 
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _; // last line of the modifier call
    
   // external function with aboveLevel modifier with 2 args
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) { // a string with the data location set to calldata
    require(msg.sender == zombieToOwner[_zombieId]); // verifying
    zombies[_zombieId].name = _newName;
  }
  
  // external function with aboveLevel modifier with 2 args 
   function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }
  
  // external view function - a method to view a user's entire zombie army
  function getZombiesByOwner(address _owner) external view returns (uint[] memory) { 
    uint[] memory result = new uint[](ownerZombieCount[_owner]); //  uint[] memory variable 
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if(zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;


  }


}
 
