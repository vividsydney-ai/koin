-- KO-271 / KO-272: the Vercel market-data cron may revalue portfolios after
-- EOD ingestion. Browser roles remain explicitly excluded.

GRANT EXECUTE ON FUNCTION refresh_paper_portfolio_values(DATE) TO service_role;
