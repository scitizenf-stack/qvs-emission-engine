use anchor_lang::prelude::*;

declare_id!("5RSv4nJufUjDgpZNysecUxAXbLcvaRoUpNTZY4ufi7Yz");

#[program]
pub mod qvs_emission_engine {
    use super::*;

    pub fn initialize(
        ctx: Context<Initialize>,
        initial_emission: u64,
        halving_interval: u64,
        start_epoch: u64,
        max_emissions: u64,
    ) -> Result<()> {
        let state = &mut ctx.accounts.state;

        require!(halving_interval > 0, QvsError::InvalidEmissionWindow);
        require!(initial_emission <= max_emissions, QvsError::InvalidEmissionWindow);

        state.authority = ctx.accounts.authority.key();
        state.paused = false;
        state.current_epoch = start_epoch;
        state.total_emitted = 0;
        state.current_emission = initial_emission;
        state.halving_interval = halving_interval;
        state.max_emissions = max_emissions;
        state.bump = ctx.bumps.state;

        emit!(EmissionUpdated {
            authority: state.authority,
            epoch: state.current_epoch,
            amount: state.current_emission,
            total_emitted: state.total_emitted,
            paused: state.paused,
        });

        Ok(())
    }

    pub fn emit_epoch(ctx: Context<EmitEpoch>) -> Result<()> {
        let state = &mut ctx.accounts.state;
        require!(!state.paused, QvsError::Paused);

        let halving_steps = state.current_epoch / state.halving_interval;
        let divisor = 2_u64.checked_pow(halving_steps.min(63) as u32).unwrap_or(u64::MAX);
        let amount = state
            .max_emissions
            .checked_div(divisor)
            .unwrap_or(state.max_emissions)
            .min(state.max_emissions.saturating_sub(state.total_emitted));

        state.current_emission = amount;
        state.total_emitted = state.total_emitted.checked_add(amount).unwrap_or(u64::MAX);
        state.current_epoch = state.current_epoch.checked_add(1).unwrap_or(state.current_epoch);

        emit!(EmissionUpdated {
            authority: state.authority,
            epoch: state.current_epoch,
            amount: state.current_emission,
            total_emitted: state.total_emitted,
            paused: state.paused,
        });

        Ok(())
    }

    pub fn set_paused(ctx: Context<SetPaused>, paused: bool) -> Result<()> {
        let state = &mut ctx.accounts.state;
        require_keys_eq!(state.authority, ctx.accounts.authority.key(), QvsError::Unauthorized);

        state.paused = paused;

        emit!(PauseChanged {
            authority: state.authority,
            paused,
        });

        Ok(())
    }
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

#[account]
pub struct GlobalState {
    pub authority: Pubkey,
    pub paused: bool,
    pub current_epoch: u64,
    pub total_emitted: u64,
    pub current_emission: u64,
    pub halving_interval: u64,
    pub max_emissions: u64,
    pub bump: u8,
}

impl GlobalState {
    pub const LEN: usize = 32 + 1 + 8 + 8 + 8 + 8 + 8 + 1;
}

#[event]
pub struct EmissionUpdated {
    pub authority: Pubkey,
    pub epoch: u64,
    pub amount: u64,
    pub total_emitted: u64,
    pub paused: bool,
}

#[event]
pub struct PauseChanged {
    pub authority: Pubkey,
    pub paused: bool,
}

#[error_code]
pub enum QvsError {
    #[msg("The authority is not authorized to perform this action.")]
    Unauthorized,
    #[msg("The emission engine is paused.")]
    Paused,
    #[msg("The emission window configuration is invalid.")]
    InvalidEmissionWindow,
}
