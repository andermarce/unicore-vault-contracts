contract wUNIV2 is ERC20 {
    using SafeMath for uint256;
    using Address for address;

    address public UniCore;
    address public UNIv2;

    
//=========================================================================================================================================
    constructor(address _UniCore, address _UNIv2) ERC20("Wrapped UniCoreLP","wUNIv2") public {
        UniCore = _UniCore;
        UNIv2 = _UNIv2;
    }

//=========================================================================================================================================
    //WUNIv2 minter
    function _wrapUNIv2(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        
        //Get UniCore Balance of UNIv2
        uint256 UNIv2Balance = ERC20(UNIv2).balanceOf(UniCore);
        
        //transferFrom UNIv2
        ERC20(UNIv2).transferFrom(sender, recipient, amount);
        
        //Mint Tokens, equal to the UNIv2 amount sent
        _mint(sender, amount);

        //Checks if balances OK otherwise throw
        require(UNIv2Balance.add(amount) == ERC20(UNIv2).balanceOf(UniCore), "Math Broken");
    }
    
    function wrapUNIv2(uint256 amount) public {
        _wrapUNIv2(msg.sender, UniCore, amount);
    }
     
    function wTransfer(address recipient, uint256 amount) external {
        require(msg.sender == UniCore, "Only UniCore can send wrapped tokens");
        _mint(recipient, amount);
    }

}
