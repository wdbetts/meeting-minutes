-- Migration: Add speaker attribution field to transcripts table
-- This migration adds:
--   - speaker: Attribution field ("Me" for microphone, "Them" for system audio)

-- Add speaker column to transcripts table
-- This enables distinguishing between microphone audio (user speaking) and system audio (others speaking)
ALTER TABLE transcripts ADD COLUMN speaker TEXT;
