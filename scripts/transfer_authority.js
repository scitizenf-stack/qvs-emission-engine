const { PublicKey } = require("@solana/web3.js");

// transfer_authority.js - compute PDA and print spl-token authorize command
// Usage: node scripts/transfer_authority.js <PROGRAM_ID> <MINT_ADDRESS>

const [, , PROGRAM_ID, MINT] = process.argv;
if (!PROGRAM_ID || !MINT) {
  console.error('Usage: node scripts/transfer_authority.js <PROGRAM_ID> <MINT_ADDRESS>');
  process.exit(1);
}

try {
  const programKey = new PublicKey(PROGRAM_ID);
  const [pda] = PublicKey.findProgramAddressSync([Buffer.from('global-state')], programKey);
  console.log('GLOBAL_STATE_PDA=' + pda.toBase58());
  console.log('');
  console.log('Run this command to transfer mint authority to the PDA:');
  console.log(`spl-token authorize ${MINT} mint ${pda.toBase58()}`);
  console.log('');
  console.log('Or to permanently burn human authority:');
  console.log('spl-token authorize ' + MINT + ' mint 11111111111111111111111111111111');
} catch (err) {
  console.error('Failed to compute PDA:', err.message || err);
  process.exit(2);
}
