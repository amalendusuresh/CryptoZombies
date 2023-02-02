pragma solidity >=0.5.0 <0.6.0;

/// @title A contract that create ZombieFactory
/// @author Amalendu Suresh

contract ZombieFactory {
     // event
     event NewZombie(uint zombieId, string name, uint dna);
   
    // state Variables & Integers 
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // struct
    struct Zombie {
        string name;
        uint dna;
    }
    
    // array
    Zombie[] public zombies;

    // private function declaration
    function _createZombie(string memory _name, uint _dna) private {
        // and fire it here
        uint id = zombies.push(Zombie(_name, _dna)) - 1; // Working With Structs and Arrays
        emit NewZombie(id, _name, _dna);
    }

    // view function
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str))); // keccak256 hash of abi.encodePacked(_str) and storing the result in rand
        return rand % dnaModulus; //  return rand value modulus(%) dnaModulus.
    }

    // public function
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name); // run the _generateRandomDna function on _name, and store it in a uint named randDna
        _createZombie(_name, randDna); // run the _createZombie function and pass it _name and randDna.
    }

}
