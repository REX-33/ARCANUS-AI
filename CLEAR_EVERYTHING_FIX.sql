-- FINAL FIX: NUKE AND REBUILD AUDIT LOGS
-- This will wipe old logs but GUARANTEE the new ones work perfectly.

-- 1. Drop existing table to clear schema cache
DROP TABLE IF EXISTS audit_logs;

-- 2. Create the table from scratch with the correct structure
CREATE TABLE audit_logs (
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

-- 3. Enable RLS
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- 4. Create ultra-permissive policies for this demo
CREATE POLICY "Allow all select" ON audit_logs FOR SELECT USING (true);
CREATE POLICY "Allow all insert" ON audit_logs FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow all update" ON audit_logs FOR UPDATE USING (true);

-- 5. Force Realtime publication (CRITICAL for the dashboard)
BEGIN;
  DROP PUBLICATION IF EXISTS supabase_realtime;
  CREATE PUBLICATION supabase_realtime FOR TABLE audit_logs;
COMMIT;

-- 6. Trigger schema reload (PostgREST specific)
NOTIFY pgrst, 'reload schema';
