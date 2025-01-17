async function main() {
    const HelloWorld = await ethers.getContractFactory("HelloWorld");
    const helloWorld = await HelloWorld.deploy("Hello, Avalanche!");

    console.log("HelloWorld deployed to:", helloWorld.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
