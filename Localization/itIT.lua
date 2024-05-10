-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2024 Bernhard Saumweber
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L

if GetLocale() ~= "itIT" then return end

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000Errore di sintassi nell'espressione del filtro|r\n\nCiò significa che l'espressione del filtro non è costruita nel modo giusto, ad es.  manca una parentesi oppure hai scritto 'tanks=1' invece di 'tanks==1'.\n\nMessaggio di errore dettagliato:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Errore semantico nell'espressione del filtro|r\n\nCiò significa che l'espressione del filtro ha la sintassi corretta, ma molto probabilmente hai scritto male il nome di una variabile, ad es. serbatoio invece dei serbatoi.\n\nMessaggio di errore dettagliato:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Errore semantico nell'espressione del filtro|r\n\nLe parole chiave 'nome', 'commento' e 'trovanumero' non sono più supportate. Rimuovili dall'espressione del filtro avanzato o premi il pulsante di ripristino.\n\nA partire dalla prepatch di Battle for Azeroth, questi valori sono protetti da Blizzard e non possono più essere valutati da alcun componente aggiuntivo \n\nUtilizza la barra di ricerca predefinita in alto  l'elenco dei gruppi per filtrare i nomi dei gruppi.\n\nMessaggio di errore dettagliato:\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter: Non verrà applicata la correzione per gli errori 'Azione interfaccia non riuscita a causa di un componente aggiuntivo' perché non sembra che tu disponga di un account completamente protetto e altrimenti non puoi creare gruppi predefiniti. Consulta le domande frequenti sui componenti aggiuntivi per ulteriori informazioni e come risolvere questo problema."
L["message.settingsupgraded"] = "Premade Groups Filter: Impostazioni trasferite alla versione %s"

L["dialog.reset"] = "Ripristina"
L["dialog.reset.confirm"] = "Resettare davvero tutti i campi?"
L["dialog.refresh"] = "Ricerca"
L["dialog.expl.simple"] = "Attiva la casella di controllo, inserisci il minimo e/o il massimo e fai clic su Cerca."
L["dialog.expl.state"] = "Il gruppo dovrebbe contenere:"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "Se le opzioni precedenti sono troppo limitate, prova una query con espressione avanzata."
L["dialog.normal"] = "normale"
L["dialog.heroic"] = "eroico"
L["dialog.mythic"] = "mitico"
L["dialog.mythicplus"] = "mitica+"
L["dialog.to"] = "a"
L["dialog.difficulty"] = "Difficoltà ........................."
L["dialog.members"]    = "Membri ............................"
L["dialog.tanks"]      = "Difensori .............................."
L["dialog.heals"]      = "Curatori .............................."
L["dialog.dps"]        = "Assaltatori ................................"
L["dialog.mprating"]   = "M+ Rating .........................."
L["dialog.pvprating"]  = "PVP Rating ........................."
L["dialog.defeated"]   = "Boss del raid sconfitti"
L["dialog.sorting"] = "Ordinamento"
L["dialog.usepgf.tooltip"] = "Abilita o disabilita Premade Groups Filter."
L["dialog.usepgf.usage"] = "Per ottenere il numero massimo di risultati pertinenti, utilizza la casella di ricerca insieme a PGF, poiché il numero di risultati restituiti dal server è limitato."
L["dialog.usepgf.results.server"] = "Gruppi inviati dal server: |cffffffff%d|r"
L["dialog.usepgf.results.removed"] = "Gruppi nascosti da PGF: |cffffffff%d|r"
L["dialog.usepgf.results.displayed"] = "Gruppi visualizzati: |cffffffff%d|r"
L["dialog.tooltip.title"] = "Espressioni di filtro avanzate"
L["dialog.tooltip.variable"] = "Variabile"
L["dialog.tooltip.description"] = "Descrizione"
L["dialog.tooltip.op.logic"] = "Operatori logici"
L["dialog.tooltip.op.number"] = "Operatori numerici"
L["dialog.tooltip.op.string"] = "Operatori di stringa"
L["dialog.tooltip.op.func"] = "Funzioni"
L["dialog.tooltip.example"] = "Esempio"
L["dialog.tooltip.ilvl"] = "livello oggetto richiesto"
L["dialog.tooltip.myilvl"] = "il mio livello oggetto"
L["dialog.tooltip.hlvl"] = "livello di onore richiesto"
L["dialog.tooltip.pvprating"] = "Punteggio PvP del leader del gruppo"
L["dialog.tooltip.mprating"] = "Punteggio Mitica+  del leader del gruppo"
L["dialog.tooltip.defeated"] = "numero di boss raid sconfitti"
L["dialog.tooltip.members"] = "numero di membri"
L["dialog.tooltip.tanks"] = "numero di difensori"
L["dialog.tooltip.heals"] = "numero di guaritori"
L["dialog.tooltip.dps"] = "numero di assaltatori"
L["dialog.tooltip.partyfit"] = "ha posti per i miei ruoli nel party"
L["dialog.tooltip.classes"] = "numero di classi specifica"
L["dialog.tooltip.age"] = "età del gruppo in minuti"
L["dialog.tooltip.voice"] = "ha la chat vocale"
L["dialog.tooltip.myrealm"] = "il leader viene dal mio reame"
L["dialog.tooltip.noid"] = "casi in cui non ho un ID"
L["dialog.tooltip.matchingid"] = "gruppi con gli stessi boss uccisi"
L["dialog.tooltip.seewebsite"] = "vedere il sito web"
L["dialog.tooltip.difficulty"] = "difficoltà"
L["dialog.tooltip.raids"] = "seleziona solo un raid specifico"
L["dialog.tooltip.dungeons"] = "seleziona una spedizione specifica"
L["dialog.tooltip.timewalking"] = "seleziona la spedizione dei viaggi nel tempo"
L["dialog.tooltip.arena"] = "seleziona il tipo di arena specifico"
L["dialog.tooltip.warmode"] = "modalità guerra abilitata"
L["dialog.copy.url.keywords"] = "Premi CTRL+C per copiare il collegamento all'elenco di parole chiave"
L["dialog.filters.group"] = "Gruppo"
L["dialog.filters.dungeons"] = "Spedizioni"
L["dialog.filters.advanced"] = "Espressione filtro avanzata"
L["dialog.partyfit"] = "Party Adatto"
L["dialog.partyfit.tooltip"] = "Mostra solo i gruppi che dispongono ancora di slot per tutti i ruoli dei membri del gruppo. Funziona anche se sei solo."
L["dialog.notdeclined"] = "Non rifiutato"
L["dialog.notdeclined.tooltip"] = "Nascondi i gruppi che ti hanno rifiutato. Mostra ancora i gruppi in cui è scaduto il timeout dell'applicazione."
L["dialog.blfit"] = "BL Presente"
L["dialog.blfit.tooltip"] = "Se nessuno nel tuo gruppo ha sete di sangue/eroismo, mostra solo i gruppi che hanno già sete di sangue/eroismo, o dopo l'adesione, c'è ancora uno slot DPS o guaritore aperto. Funziona anche se sei solo."
L["dialog.brfit"] = "Battle Res Presente"
L["dialog.brfit.tooltip"] = "Se nessuno nel tuo gruppo ha un Battle Res, mostra solo i gruppi che hanno già un Battle Res, o dopo essersi uniti, c'è ancora uno slot libero. Funziona anche se sei solo."
L["dialog.matchingid"] = "Matching ID"
L["dialog.matchingid.tooltip"] = "Mostra solo i gruppi che hanno esattamente lo stesso blocco delle istanze del tuo. Mostra sempre tutti i gruppi in cui non è presente alcun blocco."

L["settings.dialogMovable.title"] = "Finestra di dialogo mobile"
L["settings.dialogMovable.tooltip"] = "Consente di spostare la finestra di dialogo con il mouse. Il clic con il tasto destro reimposta la posizione."
L["settings.classNamesInTooltip.title"] = "Nomi delle classi nei suggerimenti"
L["settings.classNamesInTooltip.tooltip"] = "Mostra un elenco di classi per ruolo nei suggerimenti di un gruppo predefinito."
L["settings.coloredGroupTexts.title"] = "Nome del gruppo colorato"
L["settings.coloredGroupTexts.tooltip"] = "Mostra il nome del gruppo in verde se il gruppo è nuovo e in rosso se sei stato rifiutato in precedenza. Mostra il nome dell'attività in rosso se hai un blocco su quell'istanza."
L["settings.classBar.title"] = "Barra con il colore della Classe"
L["settings.classBar.tooltip"] = "Mostra una piccola barra del colore della classe sotto ciascun ruolo nell'elenco dei gruppi di spedizioni predefinite."
L["settings.classCircle.title"] = "Cerchio del colore della classe"
L["settings.classCircle.tooltip"] = "Mostra un cerchio del colore della classe sullo sfondo di ciascun ruolo nell'elenco dei gruppi di spedizioni predefinite."
L["settings.leaderCrown.title"] = "Mostra Leader del Gruppo"
L["settings.leaderCrown.tooltip"] = "Mostra una piccola corona sopra il ruolo del leader del gruppo nell'elenco dei gruppi delle spedizioni predefinite."
L["settings.ratingInfo.title"] = "Punteggio nel titolo del gruppo"
L["settings.ratingInfo.tooltip"] = "Mostra il punteggio Mitica+ o PvP del leader del gruppo nell'elenco dei gruppi precostituiti."
L["settings.oneClickSignUp.title"] = "Iscriviti con un clic"
L["settings.oneClickSignUp.tooltip"] = "Iscriviti direttamente a un gruppo facendo clic su di esso, invece di selezionarlo prima e quindi fare clic su Iscriviti."
L["settings.persistSignUpNote.title"] = "Nota di iscrizione persistente"
L["settings.persistSignUpNote.tooltip"] = "Permane la 'nota al capogruppo' in caso di iscrizione a gruppi diversi.  Per impostazione predefinita, la nota viene eliminata quando viene selezionato un nuovo gruppo."
L["settings.signupOnEnter.title"] = "Iscriviti su Invio"
L["settings.signupOnEnter.tooltip"] = "Seleziona automaticamente la casella di testo 'Nota per il capogruppo' quando ti iscrivi a un nuovo gruppo e conferma la tua richiesta premendo Invio."
L["settings.skipSignUpDialog.title"] = "Salta la finestra di dialogo di registrazione"
L["settings.skipSignUpDialog.tooltip"] = "Salta il ruolo e prendi nota, se possibile, e iscriviti immediatamente al gruppo.  Tieni premuto Maiusc per mostrare sempre la finestra di dialogo."
L["settings.coloredApplications.title"] = "Applicazioni colorate"
L["settings.coloredApplications.tooltip"] = "Mostra uno sfondo rosso sulle domande in sospeso per i gruppi Mythic+ se al gruppo non è rimasto spazio per il tuo ruolo."
