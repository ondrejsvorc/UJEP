import numpy as np
import pandas as pd

# Apriorní pravděpodobnosti = pravděpodobnosti, které vyjadřují náš odhad před provedením pozorováním.
# Posteriózní pravděpodobnosti = pravděpodobnosti, které vyjadřují náš odhad po provedení pozorování.

# Hypotézy (stavy ženy).
hypotheses = ['Zcela se nelíbí', 'Nelíbí se', 'Neutrální', 'Líbí se', 'Zamilovanost']

# Apriorní pravděpodobnosti hypotéz P(H)
P_H = np.array([0.1, 0.15, 0.5, 0.2, 0.05])

# Pozorování (chování ženy).
observations = ["Kontakt pohledem", "Úsměv", "Požádala o pití", "Dívá se na jiné muže", "Krátké fráze", "Toaleta + make-up"]

# Pravděpodobnostní pozorování při daném stavu ženy.
P_E_given_H = np.array([
    [0.1, 0.2, 0.4, 0.2, 0.1],
    [0.1, 0.1, 0.2, 0.4, 0.2],
    [0.52, 0.45, 0.029, 0.0009, 0.0001],
    [0.3, 0.4, 0.2, 0.08, 0.02],
    [0.1, 0.4, 0.3, 0.1, 0.1],
    [0.05, 0.05, 0.1, 0.2, 0.6]
])
# display(pd.DataFrame(P_E_given_H, columns=hypotheses, index=observations))

# Posteriózní pravděpodobnosti.
posterior_probabilities = pd.DataFrame(index=hypotheses)
for i, observation in enumerate(observations):
    numerator = P_H * P_E_given_H[i] # Čitatel: P(Hi) * P(E|Hi) (tedy Součinový člen)
    print(numerator)
    denominator = np.round(np.sum(numerator), 3) # Jmenovatel: Σ P(Hi) * P(E|Hi) (tedy Normalizační člen)
    print(denominator)
    posterior_probability = np.round(numerator / denominator, 3) # P(Hi) * P(E|Hi) / Σ P(Hi) * P(E|Hi)
    print(f"{posterior_probability}\n")
    posterior_probabilities[observation] = posterior_probability
print(f"{posterior_probabilities.T}\n")

# Závěry (nejpravděpodobnější stav pro každé pozorování).
posterior_df = posterior_probabilities.T
max_indices = posterior_df.idxmax(axis=1)
max_values = posterior_df.max(axis=1)
summary_table = pd.DataFrame({
    "Nejpravděpodobnější stav": max_indices,
    "Posteriorní pravděpodobnost": (max_values * 100).round(1).astype(str) + " %"
})
summary_table.index.name = "Pozorování"
header = f"{'Pozorování':30}{'Nejpravděpodobnější stav':30}{'Posteriorní pravděpodobnost'}"
print(header)
print("-" * len(header))
for idx, row in summary_table.iterrows():
    print(f"{idx:30}{row['Nejpravděpodobnější stav']:30}{row['Posteriorní pravděpodobnost']}")