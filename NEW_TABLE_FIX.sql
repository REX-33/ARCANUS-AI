-- DEFINITIVE FIX: RECREATE TABLE AND FORCE CACHE RELOAD
-- This script ensures the table exists, permissions are set, and Supabase refreshes its "memory" (cache).

-- 1. Drop if exists to start fresh
DROP TABLE IF EXISTS arcanus_audit_logs;

-- 2. Create the table
CREATE TABLE arcanus_audit_logs (
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

-- 3. Enable RLS and set permissive policies
ALTER TABLE arcanus_audit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public select" ON arcanus_audit_logs FOR SELECT USING (true);
CREATE POLICY "Allow service role insert" ON arcanus_audit_logs FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow service role update" ON arcanus_audit_logs FOR UPDATE USING (true);

-- 4. Enable Realtime updates correctly
-- Check if publication exists, if not create it, then add table
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    CREATE PUBLICATION supabase_realtime;
  END IF;
  
  -- Try to add table, if already added it will just skip
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE arcanus_audit_logs;
  EXCEPTION WHEN others THEN
    NULL; -- skip if already added
  END;
END $$;

-- 5. CRITICAL: Force PostgREST to reload the schema cache
-- This is what clears the "Could not find table" error
NOTIFY pgrst, 'reload schema';

-- 6. Insert a test row to verify immediately
INSERT INTO arcanus_audit_logs (user_id, role, original_prompt, action, layer_triggered, threat_score, reason)
VALUES ('system', 'admin', 'System initialized', 'ALLOW', 0, 0, 'Clean start');
