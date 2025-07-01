# Focus List – Task Manager with Time Limits

En enkel Flutter-app för att skapa, visa och hantera tidsbegränsade uppgifter.  
Uppgifterna ska slutföras innan tiden går ut, annars markeras de som **Missed**.  
Appen använder Cubit för state management och Hive för datahantering.

---

## Funktioner

- Skapa uppgifter med titel och tidsgräns (5–60 minuter)  
- Visa tre sektioner på startsidan:  
  - Active Tasks (pågående)  
  - Completed Tasks (avslutade manuellt)  
  - Missed Tasks (tidsgräns passerad)  
- Aktiv uppgift visar nedräkning och "Mark as Done"-knapp  
- Uppgifter flyttas automatiskt till Missed när tiden löper ut  
- Redigera och schemalägg om missade uppgifter  
- Lokal datalagring med Hive för snabb återställning vid appstart  
- Ren och strukturerad kod med Cubit och Hive
- Appen hanterar tidsgränser lokalt och räknar ned även när appen är stängd, baserat på tidsstämplar.

---

## Installation

1. Klona repot:

   ```bash
   git clone https://github.com/Juandr0/Focus-list.git

2. Navigera till repot lokalt:

   ```bash
   cd Focus-list


3. Installera dependencies:

   ```bash
   flutter pub get

4. Generera Hive-adapters och andra genererade filer:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   
5. Starta appen:

   ```bash
   flutter run

## Screenshots
<p float="left">
  <img src="https://github.com/user-attachments/assets/1bfc4ebd-93ba-4abc-a885-37ddf31fdd66" width="45%" style="margin-right: 10px;">
  <img src="https://github.com/user-attachments/assets/bd014dd8-506d-410a-99e5-13affcdb0cec" width="45%">
</p>
