CREATE TRIGGER rev1 AFTER INSERT ON reservations
FOR EACH ROW
UPDATE remains SET user_id = NEW.user_id, reserved_at = NEW.reserved_at WHERE event_id = NEW.event_id AND sheet_id = NEW.sheet_id;

CREATE TRIGGER rev2 AFTER UPDATE ON reservations
FOR EACH ROW
UPDATE remains SET user_id = 0, reserved_at = NULL WHERE event_id = NEW.event_id AND sheet_id = NEW.sheet_id;
