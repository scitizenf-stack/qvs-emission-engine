import * as anchor from "@coral-xyz/anchor";
import { assert } from "chai";

describe("qvs_token_engine", () => {
  const program = pg.program;
  const [globalStatePda] = anchor.web3.PublicKey.findProgramAddressSync(
    [Buffer.from("global-state")],
    program.programId
  );

  it("initialize and emit", async () => {
    await program.methods.initialize().accounts({
      globalState: globalStatePda,
      authority: pg.wallet.publicKey,
      systemProgram: anchor.web3.SystemProgram.programId,
    }).rpc();

    const mint = await pg.createMint();
    const dest = await pg.createTokenAccount(mint);

    await new Promise(r => setTimeout(r, 1000));

    await program.methods.emit().accounts({
      globalState: globalStatePda,
      tokenMint: mint,
      destination: dest,
      authority: pg.wallet.publicKey,
      tokenProgram: anchor.spl.Token.TOKEN_PROGRAM_ID,
    }).rpc();

    const state = await program.account.globalState.fetch(globalStatePda);
    assert(state.totalEmitted.toNumber() > 0);
  });
});
