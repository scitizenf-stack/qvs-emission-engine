const anchor = require('@project-serum/anchor');
const assert = require('assert');

describe('anchor-harness-basic', () => {
  const provider = anchor.AnchorProvider.local();
  anchor.setProvider(provider);

  it('initializes provider and program', async () => {
    const program =
      anchor.workspace['qvs_emission_engine'] ||
      anchor.workspace['quantum_vault_ui'];

    assert.ok(program, 'Program workspace not found in anchor.workspace');
  });
});
