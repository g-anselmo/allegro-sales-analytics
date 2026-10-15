# %%
import pandas as pd
import numpy as np
import os



# %%
df = pd.read_csv("data/raw/orders_raw.csv", na_values=['-','?','N/A','n/a'])
df.columns = df.columns.str.lower().str.strip().str.replace(' ', '_').str.replace('(', '').str.replace(')', '')


# %%
df = df.drop_duplicates()

# %%
df['customer_city'] = df['customer_city'].str.strip().str.title()
df['customer_city'] = df['customer_city'].fillna("Unknown")

# %%
df['category'] = df['category'].str.title().str.replace('  ',' ')
compliance = {'Dom I Ogród':'Home & Garden','Eletronika': 'Electronics',
            'Książki': 'Books', 'Zabawki':'Toys', 'Sport':'Sports', 'Fashion': 'Fashion',
            'Books':'Books','Electronics':'Electronics','Sports':'Sports','Toys':'Toys',
            'Moda':'Fashion','Home & Garden': 'Home & Garden','Elektronika':'Electronics',
            'Home And Garden': 'Home & Garden'
            }
df['category'] = df['category'].map(compliance)


# %%
df['unit_price_pln'] = df['unit_price_pln'].astype(str)

df['unit_price_pln'] = np.where(df['unit_price_pln'].str.contains(','),
                                df['unit_price_pln'].str.replace('.','').str.replace(',','.'),
                                df['unit_price_pln'])

df['unit_price_pln'] = df['unit_price_pln'].astype(float)

# %%
df['quantity'] = np.where(df['quantity'] <= 0,
                          np.nan,
                          df['quantity'])
df['quantity'] = df['quantity'].astype('Int64')

# %%
df['order_date'] = pd.to_datetime(df['order_date'])


# %%
df['revenue_pln'] = df['unit_price_pln'] * df['quantity']
df['revenue_pln'] = df['revenue_pln'].round(2)

# %%

os.makedirs("data/clean", exist_ok=True)
df.to_csv("data/clean/orders_clean.csv", index=False)
print(df.shape)