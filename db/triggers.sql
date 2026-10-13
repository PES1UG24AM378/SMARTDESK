-- ============================================================================
-- SmartDesk - Status Change Audit Trigger
-- File: db/triggers.sql
-- Description: Creates an audit logging table and an automated trigger to track
--              lifecycle status changes on tickets for accountability and metrics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. AUDIT LOG TABLE DEFINITION
-- ----------------------------------------------------------------------------
-- Drops existing table if recreating during test runs
DROP TABLE IF EXISTS ticket_status_log CASCADE;

-- Table to record every transition in a ticket's status lifecycle
CREATE TABLE ticket_status_log (
    -- log_id: Auto-incrementing primary key uniquely identifying each audit log entry
    log_id SERIAL PRIMARY KEY,

    -- ticket_id: Foreign key referencing the parent ticket in the tickets table.
    -- ON DELETE CASCADE ensures if a ticket is removed, its history is cleaned up automatically.
    ticket_id INT NOT NULL REFERENCES tickets(ticket_id) ON DELETE CASCADE,

    -- old_status: The status value prior to the update operation
    old_status VARCHAR(50),

    -- new_status: The new status value assigned to the ticket
    new_status VARCHAR(50) NOT NULL,

    -- changed_at: Exact timestamp when the modification occurred with timezone awareness.
    -- Defaults to current database system time (now())
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index on ticket_id to quickly query status history for any specific ticket
CREATE INDEX idx_ticket_status_log_ticket_id ON ticket_status_log(ticket_id);


-- ----------------------------------------------------------------------------
-- 2. PL/pgSQL TRIGGER FUNCTION DEFINITION
-- ----------------------------------------------------------------------------
-- Create or replace the trigger function that handles status transition auditing
CREATE OR REPLACE FUNCTION log_status_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Condition: Check if the status has actually changed.
    -- Using 'IS DISTINCT FROM' handles potential NULL values safely (unlike != or <>).
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        -- Insert a new historical record into the audit table with old and new values
        INSERT INTO ticket_status_log (
            ticket_id,
            old_status,
            new_status,
            changed_at
        ) VALUES (
            NEW.ticket_id,
            OLD.status,
            NEW.status,
            now()
        );
    END IF;

    -- For AFTER triggers, returning NEW or NULL is standard (return value is ignored for AFTER)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ----------------------------------------------------------------------------
-- 3. TRIGGER ATTACHMENT TO TICKETS TABLE
-- ----------------------------------------------------------------------------
-- Drop existing trigger if it already exists to prevent duplicate definitions
DROP TRIGGER IF EXISTS trg_ticket_status_change ON tickets;

-- Attach trigger to fire AFTER an UPDATE specifically targeting the 'status' column
-- FOR EACH ROW ensures the trigger function executes once for every individual row modified
CREATE TRIGGER trg_ticket_status_change
AFTER UPDATE OF status ON tickets
FOR EACH ROW
EXECUTE FUNCTION log_status_change();


-- ----------------------------------------------------------------------------
-- 4. VERIFICATION / TEST SCRIPT
-- ----------------------------------------------------------------------------
-- In your DBMS viva or lab evaluation, demonstrate the working trigger using:
/*
-- Step A: Check the initial state of ticket #1
SELECT ticket_id, status, description 
FROM tickets 
WHERE ticket_id = 1;

-- Step B: Update ticket status (e.g. from 'Resolved' to 'Open' or 'In Progress')
UPDATE tickets 
SET status = 'In Progress' 
WHERE ticket_id = 1;

-- Step C: Verify that the trigger fired and recorded the transition in the log table
SELECT log_id, ticket_id, old_status, new_status, changed_at 
FROM ticket_status_log 
WHERE ticket_id = 1 
ORDER BY changed_at DESC;

-- Step D: Attempt an UPDATE that does NOT modify status (e.g. update description only)
-- and verify no duplicate log is created:
UPDATE tickets 
SET description = description || ' (Reviewed)' 
WHERE ticket_id = 1;

-- Step E: Re-check the log to verify row count remained unchanged
SELECT COUNT(*) AS total_logs 
FROM ticket_status_log 
WHERE ticket_id = 1;
*/
