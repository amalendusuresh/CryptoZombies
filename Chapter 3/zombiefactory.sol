pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    
    //event 
    event NewZombie(uint zombieId, string name, uint dna);

    // varibles
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // struct
    struct Zombie {
        string name;
        uint dna;
    }
    
    // array
    Zombie[] public zombies;
    
    // added mapping 
    mapping (uint => address) public zombieToOwner; // mapping called zombieToOwner  (key - uint, value - address)
    mapping (address => uint) ownerZombieCount; // mapping called ownerZombieCount 

    // added msg.sender
    function _createZombie(string memory _name, uint _dna) internal { // Changed from private to internal (inheritance property)
        uint id = zombies.push(Zombie(_name, _dna)) - 1; new zombie's id
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
