-- Seed reference conditions and allergens (runs on `supabase db reset`)

insert into public.conditions (name, slug) values
  ('Diabetes', 'diabetes'),
  ('Hypertension', 'hypertension'),
  ('Kidney Disease', 'kidney-disease'),
  ('Celiac Disease', 'celiac-disease'),
  ('Heart Disease', 'heart-disease')
on conflict (slug) do nothing;

insert into public.allergens (name, slug) values
  ('Peanut', 'peanut'),
  ('Tree Nut', 'tree-nut'),
  ('Gluten', 'gluten'),
  ('Dairy', 'dairy'),
  ('Shellfish', 'shellfish'),
  ('Egg', 'egg'),
  ('Soy', 'soy'),
  ('Fish', 'fish'),
  ('Sesame', 'sesame')
on conflict (slug) do nothing;
