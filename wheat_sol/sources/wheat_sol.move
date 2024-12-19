module wheat_sol::wheat_sol {
    
    use sui::url;
    use sui::coin::{Self, Coin, TreasuryCap};
    
    

    /// Error codes
    const E_NOT_ENOUGH_BALANCE: u64 = 0;

    /// The type identifier of WHEAT_SOL coin
    public struct WHEAT_SOL has drop {
        // Empty struct for type identification
    }

    /// Module initializer is called once on module publish.
    fun init(witness: WHEAT_SOL, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            witness, 
            9, // Decimals
            b"SWHIT", // Symbol
            b"Wheat-Sol", // Name
            b"Wheat-Sol (SWHIT) is an innovative blockchain-based platform reimagining long-term value storage for the digital age.", // Description
            option::some(url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/wheat-eco/wheatsol-asset/refs/heads/main/swhit_64x64.png")), // Icon URL
            ctx
        );

        // Freeze the metadata object
        transfer::public_freeze_object(metadata);
        // Transfer the treasury cap to the module publisher
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    /// Manager can mint new coins
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<WHEAT_SOL>, 
        amount: u64, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    

    /// Get the balance of a coin
    public fun balance<T>(coin: &Coin<T>): u64 {
        coin::value(coin)
    }

    /// Split a coin into two coins
    public fun split(
        self: &mut Coin<WHEAT_SOL>, 
        amount: u64, 
        ctx: &mut TxContext
    ): Coin<WHEAT_SOL> {
        assert!(balance(self) >= amount, E_NOT_ENOUGH_BALANCE);
        coin::split(self, amount, ctx)
    }

    /// Merge two coins
    public fun join(self: &mut Coin<WHEAT_SOL>, other: Coin<WHEAT_SOL>) {
        coin::join(self, other)
    }
}
