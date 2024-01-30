cast balance $DEPLOYER --rpc-url https://sepolia.blast.io
cast send -i 0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8 --value 0.1ether --rpc-url $ALCHEMY_SEPOLIA



5502009373318056936


contract A {

}


EOA 5eth -> Contract A


function claim() {

}


cast send -i --rpc-url $ALCHEMY_SEPOLIA \
    0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 \
    "mint(address,uint256)" 0x777BEeF85E717Ab18e44cd054B1a1E33a4A93b83 1000000000000000000000


cast send -i --rpc-url=https://rpc.sepolia.org \
  0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 \
  "approve(address,uint256)" "0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8" 10000000000000000000000000000000000000000000


cast send --rpc-url=https://rpc.sepolia.org \
  --private-key=$DEPLOYER_PK \
  0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8 \
  "bridgeERC20(address localToken,address remoteToken,uint256 amount,uint32,bytes)" \
  "0x7f11f79DEA8CE904ed0249a23930f2e59b43a385" \
  "0x4200000000000000000000000000000000000022" \
  1000000000000000000000 500000 0x
