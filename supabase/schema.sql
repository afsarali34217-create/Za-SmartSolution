-- ZA Smart Solution database schema (Supabase / PostgreSQL)
-- Run in Supabase SQL Editor after creating a project.
create extension if not exists pgcrypto;
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 name text not null, category text not null, format text,
 length_mm numeric, width_mm numeric, gusset_mm numeric,
 thickness_micron numeric, material_structure text, notes text,
 is_active boolean not null default true,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.enquiries (
 id uuid primary key default gen_random_uuid(),
 customer_name text, email text, phone text,
 category text, format text, standard_size text,
 length_mm numeric, width_mm numeric, gusset_mm numeric,
 thickness_micron numeric, material_structure text,
 quantity text, printing text, artwork_notes text,
 status text not null default 'new',
 created_at timestamptz not null default now()
);
create table if not exists public.site_settings (
 id integer primary key default 1 check (id=1),
 business_name text not null default 'ZA Smart Solution',
 email text not null default 'zasmartsolutionrawalpindi@gmail.com',
 production_time text not null default 'Up to 20 working days',
 delivery_terms text not null default 'Delivery charges are paid by the customer',
 phone_1 text, phone_2 text,
 updated_at timestamptz not null default now()
);
insert into public.site_settings(id) values(1) on conflict do nothing;
alter table public.products enable row level security;
alter table public.enquiries enable row level security;
alter table public.site_settings enable row level security;
-- Public visitors may read active products and site contact settings.
create policy "Public read active products" on public.products for select using (is_active=true);
create policy "Public read settings" on public.site_settings for select using (true);
-- No public insert/update/delete policies are intentionally added.
-- Admin writes require authenticated users and an admin-only policy you configure
-- after setting up Supabase Auth. Never expose the service_role key in browser code.
