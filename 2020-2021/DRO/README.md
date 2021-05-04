# DRO projekt (Dynamické rozhodování)

Projekt se zabývá kontinuálním učením variačního autoencoderu pro detekci anomálií. Skript *continual_functions.jl* obsahuje použité funkce, definici variačního autoencoderu a jeho konstruktoru, vytvoření heatmap atd. Druhý skript *continual_seq.jl* obsahuje skript pro samotné trénování modelu. Ve skriptu je třeba pouze nastavit parametr `new_ratio` ve funkci `train_new_solver_animation`, který kontroluje poměr nových a starých dat.

*Skripty není možné spustit bez předchozí úpravy. Skripty jsou převzaté ze struktury vytvořené balíčkem DrWatson.jl a je tedy třeba upravit příslušné `include` a také stáhnout potřebné balíčky. Jinak by měl být skript spustitelný.*

Přiložené PDF obsahuje prezentaci odprezentovanou 4.5.2021 na hodině DRO.