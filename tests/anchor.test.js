const anchor = require('@coral-xyz/anchor');
const { PublicKey, SystemProgram } = require('@solana/web3.js');

describe('qvs-emission-engine', () => {
  const provider = anchor.AnchorProvider.local();
  anchor.setProvider(provider);

  const program = anchor.workspace.qvsEmissionEngine;

  it('initializes and emits a single epoch', async () => {
    const [statePda] = PublicKey.findProgramAddressSync(
      [Buffer.from('state'), provider.wallet.publicKey.toBuffer()],
      program.programId,
    );

    await program.methods
      .initialize(new anchor.BN(1000), new anchor.BN(2), new anchor.BN(0), new anchor.BN(1000000))
      .accounts({
        state: statePda,
        authority: provider.wallet.publicKey,
        systemProgram: SystemProgram.programId,
      })
      .rpc();

    await program.methods
      .emitEpoch()
      .accounts({
        state: statePda,
        authority: provider.wallet.publicKey,
      })
      .rpc();

    const state = await program.account.globalState.fetch(statePda);
    console.log('state', state.currentEpoch.toNumber(), state.totalEmitted.toNumber());
  });
});
