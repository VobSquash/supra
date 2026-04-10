-- Optional sample rows for SettingsTypeEnum keys (skip if you migrate from Parse).

insert into public.settings (id, name, value, legacy_object_id) values
  (gen_random_uuid(), 'LadderBreakdown2026',
   '{"objectId":"seed-ladder","LeagueTeams":[],"LeagueLadiesTeams":[],"LeagueMastersTeams":[]}', null),
  (gen_random_uuid(), 'Fees2026',
   '[{"Cost":0,"ProRataCost":null,"FeeType":"seed"}]', null),
  (gen_random_uuid(), 'SystemSettings',
   '{"objectId":"seed-sys","showLadderBreakdown":false}', null)
on conflict (name) do nothing;
