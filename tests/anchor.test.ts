import * as anchor from '@coral-xyz/anchor';
import { PublicKey, SystemProgram } from '@solana/web3.js';

describe('anchor harness', () => {
  const provider = anchor.AnchorProvider.local();
  anchor.setProvider(provider);

  const program = anchor.workspace.qvsEmissionEngine;

  it('exposes the workspace program', async () => {
    const [statePda] = PublicKey.findProgramAddressSync(
      [Buffer.from('state'), provider.wallet.publicKey.toBuffer()],
      program.programId,
    );

    await program.methods
      .initialize(new anchor.BN(500), new anchor.BN(3), new anchor.BN(0), new anchor.BN(5000))
      .accounts({
        state: statePda,
        authority: provider.wallet.publicKey,
        systemProgram: SystemProgram.programId,
      })
      .rpc();

    const state = await program.account.globalState.fetch(statePda);
    anchor.assert(state.authority.equals(provider.wallet.publicKey));
  });
});
