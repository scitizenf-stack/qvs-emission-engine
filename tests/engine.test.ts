import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";

describe("qvs-emission-engine", () => {
  const provider = anchor.AnchorProvider.local();
  anchor.setProvider(provider);

  const program = anchor.workspace.qvs_emission_engine as Program;

  it("initializes the engine", async () => {
    const tx = await program.methods.initialize().rpc();
    console.log("TX:", tx);
  });
});
