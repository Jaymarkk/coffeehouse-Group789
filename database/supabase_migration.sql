-- Create users table in Supabase
-- Run this SQL in your Supabase SQL Editor (Project > SQL Editor > New Query)

CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  middle_name TEXT,
  phone_number TEXT,
  is_admin BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can read their own data
CREATE POLICY "Users can read their own data"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);

-- Create policy: Users can update their own data
CREATE POLICY "Users can update their own data"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);

-- Create policy: Admins can read all users
CREATE POLICY "Admins can read all users"
  ON public.users
  FOR SELECT
  USING (
    (SELECT is_admin FROM public.users WHERE id = auth.uid()) = true
  );

-- Create products table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  category TEXT,
  image_url TEXT,
  in_stock BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable Row Level Security for products
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Create policy: Everyone can read products
CREATE POLICY "Everyone can read products"
  ON public.products
  FOR SELECT
  USING (true);

-- Create policy: Only admins can modify products
CREATE POLICY "Only admins can insert products"
  ON public.products
  FOR INSERT
  WITH CHECK (
    (SELECT is_admin FROM public.users WHERE id = auth.uid()) = true
  );

CREATE POLICY "Only admins can update products"
  ON public.products
  FOR UPDATE
  USING (
    (SELECT is_admin FROM public.users WHERE id = auth.uid()) = true
  );

CREATE POLICY "Only admins can delete products"
  ON public.products
  FOR DELETE
  USING (
    (SELECT is_admin FROM public.users WHERE id = auth.uid()) = true
  );
