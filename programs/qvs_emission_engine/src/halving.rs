pub const ONE_QVS: u128 = 1_000_000_000;
pub const HALVING_INTERVAL_SECONDS: u64 = 365 * 24 * 60 * 60;

pub fn emission_per_era(era_index: u64) -> u128 {
    let shift = era_index.min(31);
    let divisor = 2u128.checked_pow(shift as u32).unwrap_or(u128::MAX);
    ONE_QVS.checked_mul(ONE_QVS).unwrap_or(u128::MAX).checked_div(divisor).unwrap_or(u128::MAX)
}

pub fn next_emission_amount(genesis_timestamp: i64, now_timestamp: i64) -> u128 {
    let elapsed = now_timestamp.saturating_sub(genesis_timestamp) as u64;
    let era_index = elapsed / HALVING_INTERVAL_SECONDS;
    emission_per_era(era_index)
}
