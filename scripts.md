### Bridge 0.1 eth from Sepolia to Blast Sepolia

cast send -i 0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8 --value 0.1ether --rpc-url $ALCHEMY_SEPOLIA

### Get ETH balance on blast sepolia

cast balance $DEPLOYER --rpc-url https://sepolia.blast.io

### Convert ETH to WETH on blast sepolia

cast send --rpc-url https://sepolia.blast.io \
 --private-key=$DEPLOYER_PK \
 0x4200000000000000000000000000000000000023 \
 "deposit()" \
 --value 0.1ether

### Mint USDC on sepolia

cast send -i --rpc-url $ALCHEMY_SEPOLIA \
 0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 \
 "mint(address,uint256)" 0x777BEeF85E717Ab18e44cd054B1a1E33a4A93b83 1000000000000000000000

### Approve Sepolia Bridge can use USDC, then you can bridge over your USDC to USDB

cast send -i --rpc-url=https://rpc.sepolia.org \
 0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 \
 "approve(address,uint256)" "0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8" 10000000000000000000000000000000000000000000

### Bridge USDC from Sepolia to Blast Sepolia

cast send --rpc-url=https://rpc.sepolia.org \
 --private-key=$DEPLOYER_PK \
 0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8 \
 "bridgeERC20(address localToken,address remoteToken,uint256 amount,uint32,bytes)" \
 "0x7f11f79DEA8CE904ed0249a23930f2e59b43a385" \
 "0x4200000000000000000000000000000000000022" \
 1000000000000000000000 500000 0x

### Sometimes the above commands not working, you can use the hex data to bridge usdc to usdb, the hex data parameter is the same as above. Bridge over 1000 USDC to USDB

0x870876230000000000000000000000007f11f79dea8ce904ed0249a23930f2e59b43a385000000000000000000000000420000000000000000000000000000000000002200000000000000000000000000000000000000000000003635c9adc5dea00000000000000000000000000000000000000000000000000000000000000007a12000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000

### Get USDB balance of account address on blast sepolia

cast call 0x4200000000000000000000000000000000000022 "balanceOf(address)(uint256)" 0x777BEeF85E717Ab18e44cd054B1a1E33a4A93b83 --rpc-url https://sepolia.blast.io

### Get Yield Balance from GameTicket.sol on blast sepolia
cast call 0x4300000000000000000000000000000000000002 "readClaimableYield(address)" 0x52836AEfBcbA55C1a5641aa16fE36Da1A6dff852 --rpc-url https://sepolia.blast.io
cast call 0x4300000000000000000000000000000000000002 "readGasParams(address)" 0x52836AEfBcbA55C1a5641aa16fE36Da1A6dff852 --rpc-url https://sepolia.blast.io