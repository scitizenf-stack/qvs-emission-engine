const anchor = require('@coral-xyz/anchor');
const { PublicKey } = anchor.web3;

async function main() {
  const connection = new anchor.web3.Connection('http://127.0.0.1:8899', 'confirmed');
  const wallet = anchor.Wallet.local();
  const provider = new anchor.AnchorProvider(connection, wallet, { commitment: 'confirmed' });
  anchor.setProvider(provider);

  const programId = new PublicKey(process.env.PROGRAM_ID || '11111111111111111111111111111111');
  const program = new anchor.Program(require('../target/idl/qvs_emission_engine.json'), programId, provider);
  const [globalState] = PublicKey.findProgramAddressSync([Buffer.from('global-state')], program.programId);

  const state = await program.account.globalState.fetch(globalState);
  console.log(JSON.stringify(state, null, 2));
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
