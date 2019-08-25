CREATE TRIGGER rev1 AFTER INSERT ON reservations
FOR EACH ROW
UPDATE remains SET user_id = NEW.user_id, reserved_at = NEW.reserved_at WHERE event_id = NEW.event_id AND sheet_id = NEW.sheet_id;

CREATE TRIGGER rev2 AFTER UPDATE ON reservations
FOR EACH ROW
UPDATE remains SET user_id = 0, reserved_at = NULL WHERE event_id = NEW.event_id AND sheet_id = NEW.sheet_id;

ALTER TABLE remains ADD UNIQUE KEY tmp_idx (event_id, `rank`, num);

REPLACE INTO remains(event_id, sheet_id, `rank`, num, price, user_id, reserved_at)
SELECT event_id,
       sheet_id,
       s.`rank`,
       num,
       price,
       user_id,
       reserved_at
FROM reservations
         INNER JOIN sheets s on reservations.sheet_id = s.id
WHERE reservations.id in (
    SELECT max(id)
    FROM reservations
    WHERE canceled_at IS NULL
    group by event_id, sheet_id
);

ALTER TABLE remains DROP KEY tmp_idx;
