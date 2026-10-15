COPY orders FROM '/data/clean/orders_clean.csv' WITH (FORMAT csv, HEADER true);
COPY targets FROM '/data/raw/targets.csv' WITH (FORMAT csv, HEADER true);