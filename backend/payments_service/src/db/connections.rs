use sqlx::PgPool;
use sqlx::postgres::PgPoolOptions;

pub async fn connection_pool(
    database_url: &str
) -> Result<PgPool, sqlx::Error>{
    let pool = PgPoolOptions::new()
        .max_connections(25)
        .min_connections(5)
        .connect(&database_url)
        .await?;
    Ok(pool)
}