import pandas as pd
import os

data = pd.read_csv("data\\clinic_trial.csv", sep=";")
data.head()

# data characteristics
data.describe().round(2)

# the subgroup of interest
group = data.query('cell==1')
group.describe().round(2)

# data for pacients treated with the drug and placebo
drug = group.query('treat==1')
placebo = group.query('treat==2')

import matplotlib.pyplot as plt

fig, ax1 = plt.subplots()

ax1 = group.boxplot(column='survt', by='treat')
ax1.set_xlabel('Lék vs. Placebo')
ax1.set_ylabel('Survival Time')
plt.show()