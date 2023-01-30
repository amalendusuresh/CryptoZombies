pragma solidity >=0.5.0 <0.6.0;

// Importing Ownable
import "./ownable.sol";

// Inheriting Ownable
contract ZombieFactory is Ownable{
    
    //event 
    event NewZombie(uint zombieId, string name, uint dna);

    // varibles
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days; // `cooldownTime`


    // struct
    struct Zombie {
        string name;
        uint dna;
        uint32 level; // for level up over time and get access to more abilities.
        uint32 readyTime; // an amount of time a zombie has to wait after feeding or attacking(`cooldownTime`)

    }
    
    // array
    Zombie[] public zombies;
    
    // added mapping 
    mapping (uint => address) public zombieToOwner; // mapping called zombieToOwner  (key - uint, value - address)
    mapping (address => uint) ownerZombieCount; // mapping called ownerZombieCount 

    // added msg.sender
    function _createZombie(string memory _name, uint _dna) internal { // Changed from private to internal (inheritance property)
        uint id = zombies.push(Zombie(_name, _dna, 1,  uint32(now + cooldownTime))) - 1; new zombie's id (added level, readyTime arguments)
        zombieToOwner[id] = msg.sender; // zombieToOwner mapping to store msg.sender under id
        ownerZombieCount[msg.sender]++; // increase ownerZombieCount
        emit NewZombie(id, _name, _dna); // event emit
    }
    
     function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // added require
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0); require statement to check ownerZombieCount[msg.sender] is equal to 0
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
