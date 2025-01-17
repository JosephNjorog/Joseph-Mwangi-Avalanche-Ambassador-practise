async function main() {
    const SimpleToken = await ethers.getContractFactory("SimpleToken");
    const simpleToken = await SimpleToken.deploy();

    console.log("SimpleToken deployed to:", simpleToken.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});