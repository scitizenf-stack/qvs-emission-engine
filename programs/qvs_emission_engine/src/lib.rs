use anchor_lang::prelude::*;
use anchor_spl::token::{self, Mint, MintTo, Token, TokenAccount};

declare_id!("11111111111111111111111111111111");

#[program]
pub mod qvs_token_engine {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        let state = &mut ctx.accounts.global_state;
        state.genesis_timestamp = Clock::get()?.unix_timestamp;
        state.total_emitted = 0u128;
        state.bump = *ctx.bumps.get("global-state").unwrap();
        state.paused = false;
        state.max_emission_pool = 20_000_000_000u128.checked_mul(1_000_000_000u128).unwrap();
        state.governance = ctx.accounts.authority.key();
        msg!("Initialized QVS at {}", state.genesis_timestamp);
        Ok(())
    }

    pub fn emit(ctx: Context<Emit>) -> Result<()> {
        require!(!ctx.accounts.global_state.paused, ErrorCode::Paused);
        // Example mint: 1 token (1e9 native units) for testing
        let amount: u64 = 1_000_000_000;
        let bump = ctx.accounts.global_state.bump;
        let seeds = &[b"global-state".as_ref(), &[bump]];
        let signer = &[&seeds[..]];
        let cpi_accounts = MintTo {
            mint: ctx.accounts.token_mint.to_account_info(),
            to: ctx.accounts.destination.to_account_info(),
            authority: ctx.accounts.global_state.to_account_info(),
        };
        let cpi_program = ctx.accounts.token_program.to_account_info();
        let cpi_ctx = CpiContext::new_with_signer(cpi_program, cpi_accounts, signer);
        token::mint_to(cpi_ctx, amount)?;
        ctx.accounts.global_state.total_emitted = ctx.accounts.global_state.total_emitted.checked_add(amount as u128).unwrap();
        msg!("Minted {} native units", amount);
        Ok(())
    }
}

#[account]
pub struct GlobalState {
    pub genesis_timestamp: i64,
    pub total_emitted: u128,
    pub bump: u8,
    pub paused: bool,
    pub max_emission_pool: u128,
    pub governance: Pubkey,
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(init, payer = authority, space = 8 + 8 + 16 + 1 + 1 + 16 + 32, seeds = [b"global-state"], bump)]
    pub global_state: Account<'info, GlobalState>,
    #[account(mut)]
    pub authority: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Emit<'info> {
    #[account(mut, seeds = [b"global-state"], bump = global_state.bump)]
    pub global_state: Account<'info, GlobalState>,
    #[account(mut)]
    pub token_mint: Account<'info, Mint>,
    #[account(mut)]
    pub destination: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
}

#[error_code]
pub enum ErrorCode {
    #[msg("No measurable time has passed.")]
    NoTimeElapsed,
    #[msg("Math overflow occurred.")]
    MathOverflow,
    #[msg("Paused.")]
    Paused,
    #[msg("Unauthorized.")]
    Unauthorized,
}
