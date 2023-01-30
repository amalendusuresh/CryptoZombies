pragma solidity >=0.5.0 <0.6.0;

// Importing
import "./zombiefactory.sol";

// Interacting with other contracts(Interface)
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

// Inheritance
contract ZombieFeeding is ZombieFactory {

  // Initialize kittyContract using `ckAddress` - using a interface
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; // initialized with ckAddress
  KittyInterface kittyContract = KittyInterface(ckAddress); // KittyInterface named kittyContract

  // if statement added
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]); // require statement to verify that msg.sender is equal to this zombie's owner
    Zombie storage myZombie = zombies[_zombieId]; // Declare a local Zombie named myZombie
    _targetDna = _targetDna % dnaModulus; // Zombie DNA  - set _targetDna equal to _targetDna % dnaModulus
    uint newDna = (myZombie.dna + _targetDna) / 2; // declare a uint named newDna, and set it equal to the average of myZombie's DNA and _targetDna. 
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) { // comparing the keccak256 hashes of _species and the string "kitty"
       newDna = newDna - newDna % 100 + 99; // replace the last 2 digits of DNA with 99 (logic)
    }
    _createZombie("NoName", newDna); //  call _createZombie.
  }
  
  // Multiple Return Values
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna; //  declare a uint named kittyDna. 
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId); //  kittyContract.getKitty function with _kittyId and store genes in kittyDna
    feedAndMultiply(_zombieId, kittyDna, "kitty"); // function call feedAndMultiply
  }

}
