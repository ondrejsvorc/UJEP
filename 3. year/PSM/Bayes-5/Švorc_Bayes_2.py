import numpy as np
import pandas as pd

# Monty Hall Problem
# ==================
# 1. Moderátor náhodně skryje cenu za jedny ze tří dveří.
# 2. Soutěžící si zvolí jedny dveře.
# 3. Moderátor otevře jedny z jiných dveří, za kterými není cena.
# 4. Soutěžící má možnost zůstat u svých původních dveří nebo změnit na zbývající zavřené dveře.

# Guest	= dveře zvolené soutěžícím.
# Prize	= dveře, za kterými je cena.
# Host	= dveře otevřené moderátorem (nikdy Prize, nikdy Guest).

# Možné dveře
doors = [0, 1, 2]

# Apriorní pravděpodobnosti (původní pravděpodobnost ceny za každými dveřmi)
P_H = np.array([1/3, 1/3, 1/3])

# Pravděpodobnosti chování moderátora
host_behaviour = {
    "Guest": [0, 0, 0, 1, 1, 1, 2, 2, 2],
    "Prize": [0, 1, 2, 0, 1, 2, 0, 1, 2],
    "Host(0)": [0,   0,   0,   0,   0.5, 1.0, 0,   1.0, 0.5],
    "Host(1)": [0.5, 0,   1.0, 0,   0,   0,   1.0, 0,   0.5],
    "Host(2)": [0.5, 1.0, 0,   1.0, 0.5, 0,   0,   0,   0]
}
df = pd.DataFrame(host_behaviour)

# Pro všechny možné volby soutěžícího a dveří, které může moderátor otevřít.
results = []
for guest in doors:
    for host in doors:
        if host == guest:
            continue  # Moderátor nikdy neotevírá dveře zvolené soutěžícím

        valid_prizes = [] # Možné dveře, za kterými může být výhra (v jedné iteraci).
        numerators = []   # Čitatel Bayesovy věty: P(H) * P(E | H) pro každou hypotézu Prize

        # Pro všechny možné umístění ceny
        for prize in doors:
            if prize == host:
                continue  # Moderátor nikdy neotevře dveře, za kterými je výhra

            # P(Host = host | Guest = guest, Prize = prize)
            p_e_given_h = df[
                (df["Guest"] == guest) &
                (df["Prize"] == prize)
            ][f"Host({host})"].values[0]

            # P(Prize = prize) * P(Host = host | Guest, Prize)
            valid_prizes.append(prize)
            numerators.append(P_H[prize] * p_e_given_h)

        # Normalizační člen ve jmenovateli
        numerators = np.array(numerators)
        normalization = numerators.sum()

        # Posteriózní pravděpodobnosti P(Prize = i | Guest, Host)
        posterior = numerators / normalization

        # Uložení výsledku pro každou možnou hypotézu o umístění výhry
        for prize, probability in zip(valid_prizes, np.round(posterior, 3)):
            results.append({
                "Guest": guest,             # Dveře zvolené soutěžícím
                "Host": host,               # Dveře otevřené moderátorem
                "Prize": prize,             # Dveře, za kterými je umístěna cena (hypoteticky)
                "Posterior": probability    # Výsledná posteriorní pravděpodobnost
            })
posterior_probabilities = pd.DataFrame(results)
posterior_probabilities = posterior_probabilities.sort_values(by=["Guest", "Host", "Prize"])
print("\nPosterior Probabilities:")
print(posterior_probabilities)

summary_rows = []
for (guest, host), group in posterior_probabilities.groupby(["Guest", "Host"]):
    p_keep = group[group["Prize"] == guest]["Posterior"].values[0]
    p_switch = group[group["Prize"] != guest]["Posterior"].sum()
    summary_rows.append({
        "Guest": guest,
        "Host": host,
        "P(Win|Keep)": round(p_keep, 3),
        "P(Win|Switch)": round(p_switch, 3),
        "Switch Recommended": p_switch > p_keep
    })

summary_df = pd.DataFrame(summary_rows)
print("\nBayesian Inference:")
print(summary_df)