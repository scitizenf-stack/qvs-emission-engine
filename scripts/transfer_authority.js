const anchor = require('@coral-xyz/anchor');
const [,, PROGRAM_ID, MINT] = process.argv;

if (!PROGRAM_ID || !MINT) {
  console.error('Usage: node scripts/transfer_authority.js <PROGRAM_ID> <MINT_ADDRESS>');
  process.exit(1);
}

const programKey = new anchor.web3.PublicKey(PROGRAM_ID);
const [pda] = anchor.web3.PublicKey.findProgramAddressSync([Buffer.from('global-state')], programKey);

console.log('GLOBAL_STATE_PDA=' + pda.toBase58());
console.log('');
console.log('Run this command to transfer mint authority to the PDA:');
console.log(`spl-token authorize ${MINT} mint --new-authority ${pda.toBase58()}`);
console.log('');
console.log('Or to permanently burn human authority:');
console.log('spl-token authorize ' + MINT + ' mint --new-authority 11111111111111111111111111111111');
