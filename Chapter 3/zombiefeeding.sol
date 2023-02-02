pragma solidity >=0.5.0 <0.6.0;

// Inheritance
import "./zombiefactory.sol";

/// @title A contract that create ZombieFactory
/// @author Amalendu Suresh

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

   // 1. Removed address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  
  // declaration:
   KittyInterface kittyContract;  
   
 // setKittyContractAddress - external function 
  function setKittyContractAddress(address _address) external onlyOwner { // added onlyOwner modifier
    kittyContract = KittyInterface(_address); // kittyContract equal to KittyInterface(_address).
  }
  
  // Define `_triggerCooldown` - internal function 
  function _triggerCooldown(Zombie storage _zombie) internal { //  a Zombie storage pointer 
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  // Define `_isReady` - internal view function 
  //  function will tell us if enough time has passed since the last time the zombie fed.
  function _isReady(Zombie storage _zombie) internal view returns (bool) { 
    return (_zombie.readyTime <= now); // evaluate to either true or false.
  }


  //  Make this function internal
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    // Add a check for `_isReady` 
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    // Call `_triggerCooldown`
     _triggerCooldown(myZombie);

  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
