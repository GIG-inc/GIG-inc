#[derive(Clone)]
pub struct C2BService {
    pool: sqlx::PgPool,
}

impl C2BService {
    pub fn new(pool: sqlx::PgPool) -> Self {
        Self { pool }
    }

    pub async fn is_account_valid(&self, account_ref: &str) -> bool {
        let row = sqlx::query!(
            "SELECT is_active FROM accounts WHERE account_reference = $1",
            account_ref
        )
            .fetch_optional(&self.pool)
            .await
            .ok()
            .flatten();

        matches!(row, Some(r) if r.is_active)
    }
}
