python3 -c '
import json, os
path = os.path.expanduser("~/storage/downloads/zmianahajs/CombinedSave.txt")
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- STAN ZASOBÓW I ZAKUPÓW ---")
for item in data.get("serializedData", []):
    k = item.get("_k", "")
    if "Resource_" in k or "Purchased_" in k:
        print(k, ":", item.get("_v"))
'
python3 -c '
import json, os
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- STAN ZASOBÓW I ZAKUPÓW ---")
for item in data.get("serializedData", []):
    k = item.get("_k", "")
    if "Resource_" in k or "Purchased_" in k:
        print(k, ":", item.get("_v"))
'
python3 -c '
import json, os
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- STAN ZASOBÓW I ZAKUPÓW ---")
for item in data.get("serializedData", []):
    k = item.get("_k", "")
    if "Resource_" in k or "Purchased_" in k:
        print(k, ":", item.get("_v"))
'
python3 -c '
import json, os
path = os.path.expanduser("~/storage/downloads/zmianahajs/CombinedSave.txt")
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- STAN ZASOBÓW I ZAKUPÓW ---")
for item in data.get("serializedData", []):
    k = item.get("_k", "")
    if "Resource_" in k or "Purchased_" in k:
        print(k, ":", item.get("_v"))
'
python3 -c '
import json, os
path = os.path.expanduser("~/storage/downloads/zmianahajs/CombinedSave.txt")
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- STAN ZASOBÓW I ZAKUPÓW ---")
for item in data.get("serializedData", []):
    k = item.get("_k", "")
    if "Resource_" in k or "Purchased_" in k:
        print(f"{k} : {item.get(\"_v\")}")
'
python3 -c '
import json, os
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- STAN ZASOBÓW I ZAKUPÓW ---")
for item in data.get("serializedData", []):
    k = item.get("_k", "")
    if "Resource_" in k or "Purchased_" in k:
        print(k, ":", item.get("_v"))
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("serializedData", [])
print("Wszystkých elementów:", len(items))
print("Pierwsze 10 kluczy w pliku:")
for item in items[:10]:
    print(" -", item.get("_k"))
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("serializedData", [])
print("Wszystkých elementów:", len(items))
print("Pierwsze 10 kluczy w pliku:")
for item in items[:10]:
    print(" -", item.get("_k"))
'
cp /sdcard/Download/zmianahajs/CombinedSave.txt.bak /sdcard/Download/zmianahajs/CombinedSave.txt
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)
print("Główne klucze:", list(data.keys()) if isinstance(data, dict) else "Nie słownik")
print("Liczba elementów w serializedData:", len(data.get("serializedData", [])))
'
cp /sdcard/Download/zmianahajs/CombinedSave.txt.bak /sdcard/Download/zmianahajs/CombinedSave.txt && python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)
items = data.get("_serializedData", [])
print("Liczba elementów:", len(items))
print("Pierwsze 5 kluczy:")
for item in items[:5]:
    print(" -", item.get("_k"))
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])
mod_p = 0
mod_r = 0

for item in items:
    k = item.get("_k", "")
    # 1. Zmiana wszystkich ulepszeń i zakupów Purchased_ na True
    if k.startswith("Purchased_"):
        item["_v"] = "True"
        mod_p += 1
    # 2. Ustawienie wszystkich zasobów i portfela na 50000
    elif k.startswith("Resource_") or k.startswith("ResourceTotalAmount_"):
        item["_v"] = "50000"
        mod_r += 1

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print(f"Gotowe! Zmieniono {mod_p} ulepszeń na True oraz {mod_r} wpisów zasobów na 50000.")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- SZUKANIE KLEJNOTÓW (GEMS) ---")
for item in data.get("_serializedData", []):
    k = str(item.get("_k", ""))
    v = str(item.get("_v", ""))
    # Szukamy kluczy z nazwą Gem/Diamond/Currency lub zagnieżdżonych JSON-ów
    if any(w in k.lower() for w in ["gem", "diamond", "currency", "coin", "cash", "wallet", "store", "inventory", "bank"]):
        print(f"KLUCZ: {k}  --->  WARTOŚĆ: {v[:150]}")
'
python3 -c '
import json, re
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# Szukamy i zamieniamy w całym pliku wszelkie wystąpienia ilości klejnotów/waluty premium
# (np. powiązane z modelem sklepu lub ciągami znaków w _v)
data = json.loads(content)

for item in data.get("_serializedData", []):
    k = str(item.get("_k", ""))
    v = str(item.get("_v", ""))
    
    # Jeśli klucz ma coś wspólnego ze sklepem lub paczkami klejnotów, ustawiamy flagi na True
    if "Gem" in k or "Currency" in k:
        if v in ["False", "false", "0"]:
            item["_v"] = "True"
            
    # Szukamy też wpisów w StoreModel lub strukturach z cyframi (np. stan 0)
    if k in ["DataVersion_StoreModel", "DataVersion_InventoryModel"]:
        print(f"Model: {k} -> {v}")

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print("Skrypt zakończył działanie!")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])

# Sprawdzamy, czy wpis o gemach (Resource_1) już istnieje, jeśli nie - dodajemy go
istnieje = False
for item in items:
    if item.get("_k") == "Resource_1":
        item["_v"] = "50000"
        istnieje = True
    elif item.get("_k") == "ResourceTotalAmount_1":
        item["_v"] = "50000"

if not istnieje:
    # Dodajemy brakujące wpisy dla klejnotów (Resource_1 oraz ResourceTotalAmount_1)
    items.append({"_k": "Resource_1", "_v": "50000"})
    items.append({"_k": "ResourceTotalAmount_1", "_v": "50000"})
    items.append({"_k": "ResourceEverCollected_1", "_v": "True"})
    items.append({"_k": "ResourceIsNew_1", "_v": "True"})

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print("Pomyślnie dodano/zaktualizowano klejnoty (Resource_1) na 50000!")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])

# Sprawdzamy, czy wpis o gemach (Resource_1) już istnieje, jeśli nie - dodajemy go
istnieje = False
for item in items:
    if item.get("_k") == "Resource_1":
        item["_v"] = "50000"
        istnieje = True
    elif item.get("_k") == "ResourceTotalAmount_1":
        item["_v"] = "50000"

if not istnieje:
    # Dodajemy brakujące wpisy dla klejnotów (Resource_1 oraz ResourceTotalAmount_1)
    items.append({"_k": "Resource_1", "_v": "50000"})
    items.append({"_k": "ResourceTotalAmount_1", "_v": "50000"})
    items.append({"_k": "ResourceEverCollected_1", "_v": "True"})
    items.append({"_k": "ResourceIsNew_1", "_v": "True"})

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print("Pomyślnie dodano/zaktualizowano klejnoty (Resource_1) na 50000!")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- SZUKANIE KLEJNOTÓW (GEMS) ---")
for item in data.get("_serializedData", []):
    k = str(item.get("_k", ""))
    v = str(item.get("_v", ""))
    # Szukamy kluczy z nazwą Gem/Diamond/Currency lub zagnieżdżonych JSON-ów
    if any(w in k.lower() for w in ["gem", "diamond", "currency", "coin", "cash", "wallet", "store", "inventory", "bank"]):
        print(f"KLUCZ: {k}  --->  WARTOŚĆ: {v[:150]}")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])

# Sprawdzamy, czy wpis o gemach (Resource_1) już istnieje, jeśli nie - dodajemy go
istnieje = False
for item in items:
    if item.get("_k") == "Resource_1":
        item["_v"] = "50000"
        istnieje = True
    elif item.get("_k") == "ResourceTotalAmount_1":
        item["_v"] = "50000"

if not istnieje:
    # Dodajemy brakujące wpisy dla klejnotów (Resource_1 oraz ResourceTotalAmount_1)
    items.append({"_k": "Resource_1", "_v": "50000"})
    items.append({"_k": "ResourceTotalAmount_1", "_v": "50000"})
    items.append({"_k": "ResourceEverCollected_1", "_v": "True"})
    items.append({"_k": "ResourceIsNew_1", "_v": "True"})

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print("Pomyślnie dodano/zaktualizowano klejnoty (Resource_1) na 50000!")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])
mod_p = 0
mod_r = 0

for item in items:
    k = item.get("_k", "")
    # 1. Zmiana wszystkich ulepszeń i zakupów Purchased_ na True
    if k.startswith("Purchased_"):
        item["_v"] = "True"
        mod_p += 1
    # 2. Ustawienie wszystkich zasobów i portfela na 50000
    elif k.startswith("Resource_") or k.startswith("ResourceTotalAmount_"):
        item["_v"] = "50000"
        mod_r += 1

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print(f"Gotowe! Zmieniono {mod_p} ulepszeń na True oraz {mod_r} wpisów zasobów na 50000.")
'
cp /sdcard/Download/zmianahajs/CombinedSave.txt.bak /sdcard/Download/zmianahajs/CombinedSave.txt && python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)
items = data.get("_serializedData", [])
print("Liczba elementów:", len(items))
print("Pierwsze 5 kluczy:")
for item in items[:5]:
    print(" -", item.get("_k"))
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- LISTA WSZYSTKICH ZASOBÓW W PLIKU ---")
for item in data.get("_serializedData", []):
    k = item.get("_k", "")
    if k.startswith("Resource_") and not k.startswith("ResourceTotalAmount_") and not k.startswith("ResourceEverCollected_") and not k.startswith("ResourceIsNew_"):
        print(f"Klucz: {k} -> Wartość: {item.get(\"_v\")}")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- LISTA ZASOBÓW ---")
for item in data.get("_serializedData", []):
    k = item.get("_k", "")
    if k.startswith("Resource_") and not "Total" in k and not "Ever" in k and not "IsNew" in k:
        print(k, "->", item.get("_v"))
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])
licznik = 0

for item in items:
    k = item.get("_k", "")
    # Ustawiamy 50000 dla wszystkich zasobów i ich stanów całkowitych
    if k.startswith("Resource_") or k.startswith("ResourceTotalAmount_"):
        item["_v"] = "50000"
        licznik += 1
    # Ustawiamy też flagi ze ze zbieraniem na True
    elif k.startswith("ResourceEverCollected_") or k.startswith("ResourceIsNew_"):
        item["_v"] = "True"

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print(f"Zaktualizowano pomyślnie {licznik} wpisów zasobów na 50000!")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])
znaleziono_gemy = False

# Szukamy klucza odpowiedzialnego za gemy i ustawiamy 50000
for item in items:
    k = item.get("_k", "")
    if k in ["Resource_1", "Resource_0", "Resource_61"] or "Gem" in k:
        item["_v"] = "50000"
        print(f"Naprawiono klucz: {k}")
        znaleziono_gemy = True

# Jeśli nie było dedykowanego klucza, dodajemy Resource_1 jako gemy
if not znaleziono_gemy:
    items.append({"_k": "Resource_1", "_v": "50000"})
    items.append({"_k": "ResourceTotalAmount_1", "_v": "50000"})
    print("Dodano nowy klucz gemów (Resource_1) = 50000")

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print("Zapisano pomyślnie!")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- PEŁNY SKAN UKRYTYCH WARTOŚCI LICZBOWYCH ---")
for item in data.get("_serializedData", []):
    k = str(item.get("_k", ""))
    v = str(item.get("_v", ""))
    # Szukamy kluczy, które nie mają jeszcze ustawionych dużych wartości i mogą być powiązane z portfelem/walutą
    if not k.startswith("Destructible_") and not k.startswith("Workshop_") and not k.startswith("Fixable_"):
        if len(v) < 15 and any(char.isdigit() for char in v):
            print(f"{k} ---> {v}")
'
cp /sdcard/Download/zmianahajs/CombinedSave.txt.bak /sdcard/Download/zmianahajs/CombinedSave.txt
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- ANALIZA ZASOBÓW Z WARTOŚCIĄ 0 ---")
for item in data.get("_serializedData", []):
    k = str(item.get("_k", ""))
    v = str(item.get("_v", ""))
    # Szukamy surowców, które mają wartość 0 (potencjalne gemy lub waluta premium)
    if k.startswith("Resource_") and v == "0":
        print(f"Znaleziono pusty zasób: {k}")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- SZUKANIE WSZYSTKICH WARTOŚCI 0 W PLIKU ---")
for item in data.get("_serializedData", []):
    k = str(item.get("_k", ""))
    v = str(item.get("_v", ""))
    # Pomijamy długie listy obiektów i warsztatów, szukamy krótkich kluczy i flag
    if not any(x in k for x in ["Workshop_", "Fixable_", "Destructible_", "SpawnedEntities"]):
        if v == "0" or v == "0.0":
            print(f"Klucz: {k} ---> Wartość: {v}")
'
python3 -c '
import json
path = "/sdcard/Download/zmianahajs/CombinedSave.txt"

# 1. Przywrócenie z backupu dla pewności
import shutil
shutil.copy(path + ".bak", path)

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

items = data.get("_serializedData", [])
zmieniono = False

for item in items:
    k = item.get("_k", "")
    # Celujemy w klucz Units oraz potencjalne ID gemów
    if k == "Units" or k == "Resource_1" or k == "Resource_2":
        item["_v"] = "50000"
        print(f"Zmieniono klucz gemów: {k} na 50000")
        zmieniono = True

# Jeśli nie było tych kluczy, dodajemy je na siłę
if not zmieniono:
    items.append({"_k": "Units", "_v": "50000"})
    items.append({"_k": "Resource_1", "_v": "50000"})
    items.append({"_k": "ResourceTotalAmount_1", "_v": "50000"})
    print("Utworzono brakujące wpisy dla gemów (Units / Resource_1).")

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, separators=(",", ":"))

print("Gotowe! Plik zapisany.")
'
ls -la /sdcard/Android/data/com.winter.breaker/files/
rish
ls
mv /sdcard/Download/rish /sdcard/Download/rish_shizuku.dex ~ 2>/dev/null || cp /sdcard/Download/rish ~ && cp /sdcard/Download/rish_shizuku.dex ~
cp /sdcard/Download/Rishh/rish /sdcard/Download/Rishh/rish_shizuku.dex ~ && echo "Przeniesiono pomyślnie!"
rish
chmod +x rish
chmod +x rish_shizuku.dex
rish
ls
pkg setup_env.sh
setup_env.sh
run setup_env.sh
apt setup_env.sh
pm setup_env.sh
rish
chmod +x rish
chmod +x rish_shizuku.dex
rish
bash rish
nano rish
bash rish
exit
