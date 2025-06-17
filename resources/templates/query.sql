SELECT loon.*
FROM loon_coded AS loon
INNER JOIN segments ON loon.segment_id = segments.segment_id
WHERE
  (
    segments.longitude_min >= {{longitude_min}}
    AND segments.longitude_max <= {{longitude_max}}
    AND segments.latitude_min >= {{latitude_min}}
    AND segments.latitude_max <= {{latitude_max}}
    AND segments.duration >= {{duration_min}}
    AND segments.duration <= {{duration_max}}
    AND (
      {{season_statement}}
    )
  )
LIMIT 100  -- remove limit as needed