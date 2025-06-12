## Snowman Merkle Airdrop

Snow in the middle of the year? You got it!!!

In anticipation of the upcoming snow season, help secure the **Snowman Merkle Airdrop contract**.

![snowman image](snowman.png)

[//]: # (contest-details-open)

### About

- `Snow.sol`:

    The `Snow` contract is an `ERC20` token that automatically makes one eligible to claim a `Snowman NFT`.

    The `Snow` token is staked in the `SnowmanAirdrop` contract, and the staker receives `Snowman` NFTs in the value of how many `Snow` tokens they own.

    The `Snow` token can either be earned for free onece a week, or bought at anytime, up until during the `::FARMING_DURATION` is over.

    The `Snow` token can be bought with either `WETH` or native `ETH`.

- `Snowman.sol`:

    The `Snowman` contract is an `ERC721` contract that utilizes `Base64` encoding to achieve total on-chain storage.

    Stakers of the Snow token receive this NFT.

- `SnowmanAirdrop.sol`:

    The `SnowmanAirdrop` contract utilizes `Merkle` trees implementation for a more efficient airdrop system.

    Recipients can either claim a `Snowman` NFT themselves, or have someone claim on their behalf using the recipient's `v`, `r`, `s` signatures.

    Recipients stake their `Snow` tokens and receive `Snowman` NFTS equal to their `Snow` balance in return

### Resources:

- Learn about Merkle trees [`here`](https://updraft.cyfrin.io/courses/advanced-foundry/merkle-airdrop/introduction) and [`here`](https://www.youtube.com/watch?v=s7C2KjZ9n2U)
- Learn about ECDSA signtaures [`here`](https://www.youtube.com/watch?v=e3ugVpBBlhc)
- Learn about Snowmen [`here`](https://en.wikipedia.org/wiki/Snowman)

Goodluck ⛄

[//]: # (contest-details-close)

[//]: # (getting-started-open)

### Set-up:

```bash
    git clone https://github.com/CodeHawks-Contests/2025-06-snowman-merkle-airdrop.git 
    cd 2025-06-snowman-merkle-airdrop
    forge install
    forge build
    forge test
```

The `Helper` script is used to deploy the `GenerateInput` and `SnowMerkle` scripts, and also set up the `TestSnowmanAirdrop` test suite. Refactor it for your tests as you see fit to get the necessary `input` and `output` `JSON` files.

[//]: # (getting-started-close)

[//]: # (scope-open)

### Scope:

```
src/
├── Snow.sol
├── Snowman.sol
└── SnowmanAirdrop.sol

script/
├── GenerateInput.s.sol
├── Helper.s.sol
├── SnowMerkle.s.sol
└── flakes/
    ├── input.json
    └── output.json
```

### Compatibility:

- Chain: Ethereum
- Token: Native `ETH` and `WETH`

[//]: # (scope-close)

[//]: # (known-issues-open)

### Known Issues

None!

[//]: # (known-issues-close)

