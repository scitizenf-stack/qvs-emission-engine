import * as anchor from '@coral-xyz/anchor';
import { PublicKey, SystemProgram } from '@solana/web3.js';

describe('qvs-emission-engine', () => {
  const provider = anchor.AnchorProvider.local();
  anchor.setProvider(provider);

  const program = anchor.workspace.qvsEmissionEngine;

  it('initializes state and emits the first epoch', async () => {
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

    const stateBefore = await program.account.globalState.fetch(statePda);
    anchor.assert(stateBefore.currentEmission.toNumber() === 1000);

    await program.methods
      .emitEpoch()
      .accounts({
        state: statePda,
        authority: provider.wallet.publicKey,
      })
      .rpc();

    const stateAfter = await program.account.globalState.fetch(statePda);
    anchor.assert(stateAfter.currentEpoch.toNumber() === 1);
    anchor.assert(stateAfter.totalEmitted.toNumber() > 0);
  });
});
