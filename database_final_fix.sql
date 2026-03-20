-- RUN THIS IN YOUR SUPABASE SQL EDITOR TO FIX EVERYTHING
-- This will add the missing columns to your existing table correctly.

-- 1. Safely add n8n_status if it doesn't exist
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='audit_logs' AND column_name='n8n_status') THEN
        ALTER TABLE audit_logs ADD COLUMN n8n_status VARCHAR(50) DEFAULT 'PENDING';
    END IF;
END $$;

-- 2. Safely add agent_analysis if it doesn't exist
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='audit_logs' AND column_name='agent_analysis') THEN
        ALTER TABLE audit_logs ADD COLUMN agent_analysis TEXT;
    END IF;
END $$;

-- 3. Ensure Realtime is enabled for this table
BEGIN;
  DROP PUBLICATION IF EXISTS supabase_realtime;
  CREATE PUBLICATION supabase_realtime FOR TABLE audit_logs;
COMMIT;

-- 4. Clean up any bad data that might have N/A status
UPDATE audit_logs SET n8n_status = 'PENDING' WHERE n8n_status IS NULL;
