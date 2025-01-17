require("@nomiclabs/hardhat-ethers");

module.exports = {
    solidity: "0.8.0",
    networks: {
        fuji: {
            url: "https://api.avax-test.network/ext/bc/C/rpc",
            accounts: [0x8e915284ef06f304c3a38b072f3847f1a7cd14354e0837a85d847b37da5e918fn],
        },
    },
};
