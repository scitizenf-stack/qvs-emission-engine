use anchor_lang::prelude::*;
use std::convert::TryInto;

declare_id!("6pw4r97FHFyTsqC5Z7NHYA278i4HgWjK16wmrxWgTXe2");

#[program]
pub mod qvs_emission_engine {
    use super::*;

    pub fn initialize(
        ctx: Context<Initialize>,
        emission_per_epoch: u64,
        halving_period: u64,
        epoch_length: u64,
        max_supply: u64,
    ) -> Result<()> {
        require!(emission_per_epoch > 0, QvsError::InvalidEmissionRate);
        require!(halving_period > 0, QvsError::InvalidHalvingPeriod);
        require!(max_supply > 0, QvsError::InvalidSupplyCap);

        let clock = Clock::get()?;
        let state = &mut ctx.accounts.state;

        state.authority = ctx.accounts.authority.key();
        state.paused = false;
        state.current_epoch = 0;
        state.emission_per_epoch = emission_per_epoch;
        state.halving_period = halving_period;
        state.epoch_length = epoch_length;
        state.max_supply = max_supply;
        state.total_emitted = 0;
        state.last_emitted_at = clock.unix_timestamp;
        state.bump = ctx.bumps.state;

        msg!(
            "QVS Emission Engine initialized with per-epoch emission {}, max supply {}, halving period {}",
            emission_per_epoch,
            max_supply,
            halving_period
        );
        Ok(())
    }

    pub fn emit_epoch(ctx: Context<EmitEpoch>) -> Result<()> {
        let state = &mut ctx.accounts.state;
        require!(!state.paused, QvsError::Paused);
        require!(state.authority == ctx.accounts.authority.key(), QvsError::Unauthorized);

        let clock = Clock::get()?;
        let elapsed = clock.unix_timestamp.saturating_sub(state.last_emitted_at);
        if state.epoch_length > 0 && elapsed < state.epoch_length as i64 {
            return Err(QvsError::EpochNotReady.into());
        }

        let halving_steps = state.current_epoch / state.halving_period;
        let divisor = 2u64
            .checked_pow(halving_steps.try_into().unwrap_or(u32::MAX))
            .unwrap_or(u64::MAX)
            .max(1);

        let base_emission = state
            .emission_per_epoch
            .checked_div(divisor)
            .unwrap_or(1)
            .max(1);
        let remaining = state.max_supply.saturating_sub(state.total_emitted);
        let amount = base_emission.min(remaining);
        require!(amount > 0, QvsError::NoEmissionAvailable);

        state.total_emitted = state.total_emitted.checked_add(amount).ok_or(QvsError::SupplyCapReached)?;
        state.current_epoch = state.current_epoch.checked_add(1).ok_or(QvsError::Overflow)?;
        state.last_emitted_at = clock.unix_timestamp;

        emit!(EmissionEvent {
            epoch: state.current_epoch,
            amount,
            total_emitted: state.total_emitted,
        });

        Ok(())
    }

    pub fn set_paused(ctx: Context<SetPaused>, paused: bool) -> Result<()> {
        require!(ctx.accounts.state.authority == ctx.accounts.authority.key(), QvsError::Unauthorized);
        ctx.accounts.state.paused = paused;
        emit!(PauseEvent {
            paused,
            authority: ctx.accounts.authority.key(),
        });
        Ok(())
    }
}

#[account]
pub struct GlobalState {
    pub authority: Pubkey,
    pub paused: bool,
    pub current_epoch: u64,
    pub emission_per_epoch: u64,
    pub halving_period: u64,
    pub epoch_length: u64,
    pub max_supply: u64,
    pub total_emitted: u64,
    pub last_emitted_at: i64,
    pub bump: u8,
}

impl GlobalState {
    pub const LEN: usize = 8 + 32 + 1 + 8 + 8 + 8 + 8 + 8 + 8 + 1;
}

#[event]
pub struct EmissionEvent {
    pub epoch: u64,
    pub amount: u64,
    pub total_emitted: u64,
}

#[event]
pub struct PauseEvent {
    pub paused: bool,
    pub authority: Pubkey,
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(
        init,
        payer = authority,
        space = 8 + GlobalState::LEN,
        seeds = [b"state", authority.key().as_ref()],
        bump
    )]
    pub state: Account<'info, GlobalState>,
    #[account(mut)]
    pub authority: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct EmitEpoch<'info> {
    #[account(mut, has_one = authority @ QvsError::Unauthorized)]
    pub state: Account<'info, GlobalState>,
    pub authority: Signer<'info>,
}

#[derive(Accounts)]
pub struct SetPaused<'info> {
    #[account(mut, has_one = authority @ QvsError::Unauthorized)]
    pub state: Account<'info, GlobalState>,
    pub authority: Signer<'info>,
}

#[error_code]
pub enum QvsError {
    #[msg("The emission rate must be greater than zero.")]
    InvalidEmissionRate,
    #[msg("The halving period must be greater than zero.")]
    InvalidHalvingPeriod,
    #[msg("The max supply must be greater than zero.")]
    InvalidSupplyCap,
    #[msg("The engine is currently paused.")]
    Paused,
    #[msg("This action is unauthorized.")]
    Unauthorized,
    #[msg("The current epoch is not ready yet.")]
    EpochNotReady,
    #[msg("No emission is available.")]
    NoEmissionAvailable,
    #[msg("The emission cap has been reached.")]
    SupplyCapReached,
    #[msg("Arithmetic overflow detected.")]
    Overflow,
}
