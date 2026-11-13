import json
path = "/sdcard/Android/data/com.winter.breaker/files/Save/CombinedSave.txt"
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

print("--- KLUCZE NIESTANDARDOWE (PROFIL / WALUTY) ---")
for item in data.get("_serializedData", []):
    k = str(item.get("_k", ""))
    v = str(item.get("_v", ""))
    if not k.startswith("Resource_") and not k.startswith("ResourceTotalAmount_") and not k.startswith("Workshop_"):
        if len(k) < 35:
            print(f"{k} ---> {v}")
