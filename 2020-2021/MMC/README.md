# Metoda Monte Carlo (AR 2020/2021)

V této složce se nachází všechny zdrojové kódy, výsledky, obrázky i latexovské dokumenty pro vypracování protokolu do předmětu MMC v akademickém roce 2020/2021.

Projekt byl vypracován v jazyce Julia s využitím struktury definované pomocí balíčku DrWatson.

## Struktura, složky

### Kód

Kód obsahují složky

- src: zdrojové kódy s funkcemi a přípravou dat, načtením balíčků atd.
- scripts: kód, který spouští veškeré již definované simulace
- dumped code: pracovní kód sloužící k přípravě, testování, atd. (nahlédnutí pouze na vlastní nebezpečí)

### Data a grafy

Složka *data* obsahuje všechna data získaná ze simulací. Ve složce *plots* je pak možné najít všechny grafy, které byly pro protokol vytvořeny. Obě složky obsahují čtyři podsložky, pro každý problém a metodu jednu.

### LaTeX

Složka *latex* obsahuje všechny soubory pro vypracování PDF protokolu.

## Spuštění

Spuštění všech simulací je pouze ve skriptu *run_simulations.jl*, který obsahuje načtení všech potřebných funkcí a balíčků a následně spuštění simulací pro různý počet iteračních kroků.

Skript *results.jl* pak slouží k vytvoření tabulek z dokumentu pdf.