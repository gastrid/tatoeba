select
  sources.id as source_id,
  targets.id as target_id,
  sources.sentence as source_sentence,
  targets.sentence as target_sentence
from
  sources
  join targets on targets.source_id = sources.id
where
  targets.lang = 'ru'
  and sources.sentence like "%cold%"
limit
  10
offset
  10;