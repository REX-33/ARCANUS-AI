-- RUN THIS IN YOUR SUPABASE SQL EDITOR

-- 1. Create the audit_logs table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS audit_logs (
  id         BIGSERIAL PRIMARY KEY,
  timestamp  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  user_id    VARCHAR(255) NOT NULL,
  role       VARCHAR(255) NOT NULL,
  original_prompt TEXT NOT NULL,
  action     VARCHAR(50) NOT NULL,
  layer_triggered INTEGER NOT NULL,
  threat_score    INTEGER NOT NULL,
  reason     TEXT NOT NULL,
  agent_analysis TEXT NULL,
  n8n_status VARCHAR(50) NULL DEFAULT 'PENDING'
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- 3. Create a policy to allow anonymous READ access (for the frontend dashboard)
DROP POLICY IF EXISTS "Allow anon select" ON audit_logs;
CREATE POLICY "Allow anon select" ON audit_logs
  FOR SELECT USING (true);

-- 4. Create a policy to allow the backend service role to INSERT
DROP POLICY IF EXISTS "Allow service role insert" ON audit_logs;
CREATE POLICY "Allow service role insert" ON audit_logs
  FOR INSERT WITH CHECK (true);

-- 5. Enable Realtime updates
BEGIN;
  DROP PUBLICATION IF EXISTS supabase_realtime;
  CREATE PUBLICATION supabase_realtime FOR TABLE audit_logs;
COMMIT;
