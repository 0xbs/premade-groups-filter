-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2022 Elotheon-Arthas-EU
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

if GetLocale() ~= "frFR" then return end

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000Erreur de syntaxe dans le filtre d'expression|r\n\nCela indique que vous avez fait une erreur dans l'expression avancée, ex: il manque une paranthèse ou vous avez écrit 'tanks=1' au lieu de 'tanks==1'.\n\nMessage d'erreur détaillé:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Erreur sémantique dans le filtre d'expression|r\n\nCela indique que votre syntaxe est bonne mais que vous avez mal écrit le nom d'une variable, ex: tansk au lieu de tanks.\n\nMessage d'erreur détaillé:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Erreur sémantique dans le filtre d'expression|r\n\nLes mots-clés 'name', 'comment' et 'findnumber' ne sont plus supportés. Veux-tu les supprimer de ton expression de filtre étendu ou appuies sur le bouton de réinitialisation.\n\nA partir du Battle for Azeroth Prepatch, ces valeurs sont maintenant protégées par Blizzard et ne peuvent plus être lues par aucun addon.\n\nUtilise la barre de recherche par défaut au-dessus de la liste des groupes pour filtrer les noms de groupes.\n\nMessage d'erreur détaillé:\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter: L'erreur 'L'action de l'interface a échoué à cause d'un AddOn' n'est pas corrigée, car il semble que tu n'aies pas de compte entièrement sécurisé et que tu ne puisses sinon pas créer de groupes organisés. Voir Addon-FAQ pour plus d'informations et comment corriger ce problème."
L["message.settingsupgraded"] = "Premade Groups Filter: Paramètres migrés vers la version %s"

L["dialog.reset"] = "Réinitialiser"
L["dialog.reset.confirm"] = "Vraiment réinitialiser tous les champs ?"
L["dialog.refresh"] = "Rechercher"
L["dialog.expl.simple"] = "Cochez les cases, entrez un min / max et recherchez"
L["dialog.expl.state"] = "Le groupe doit contenir"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "Si les options dessus sont trop limitées, vous pouvez essayer les requêtes avancées."
L["dialog.normal"] = "Normal"
L["dialog.heroic"] = "Héroïque"
L["dialog.mythic"] = "Mythique"
L["dialog.mythicplus"] = "Mythique +"
L["dialog.to"] = "à"
L["dialog.difficulty"] = "Difficulté ........................."
L["dialog.members"]    = "Membres ............................"
L["dialog.tanks"]      = "Tanks .............................."
L["dialog.heals"]      = "Heals .............................."
L["dialog.dps"]        = "DPS ................................"
L["dialog.mprating"]   = "Classement Mythic+ ................."
L["dialog.pvprating"]  = "Classement PvP ....................."
L["dialog.defeated"]   = "Boss de raid vaincus"
L["dialog.sorting"] = "Tri"
L["dialog.usepgf.tooltip"] = "Activer ou désactiver Premade Groups Filter"
L["dialog.tooltip.title"] = "Filtres d'Expressions Avancées"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Description"
L["dialog.tooltip.op.logic"] = "Opérateurs Logiques"
L["dialog.tooltip.op.number"] = "Operateurs Numériques"
L["dialog.tooltip.op.string"] = "Operateurs Textes"
L["dialog.tooltip.op.func"] = "Fonctions"
L["dialog.tooltip.example"] = "Example"
L["dialog.tooltip.ilvl"] = "niveau d'objet requis"
L["dialog.tooltip.myilvl"] = "mon niveau d'objet"
L["dialog.tooltip.hlvl"] = "niveau d'honneur requis"
L["dialog.tooltip.pvprating"] = "Classement PvP du chef de groupe"
L["dialog.tooltip.mprating"] = "Classement Mythic+ du chef de groupe"
L["dialog.tooltip.defeated"] = "nombre de boss de raids vaincu"
L["dialog.tooltip.members"] = "nombre de membres"
L["dialog.tooltip.tanks"] = "nombres de tanks"
L["dialog.tooltip.heals"] = "nombres de soigneurs"
L["dialog.tooltip.dps"] = "nombre de DPS"
L["dialog.tooltip.partyfit"] = "a place pour les rôles de mon groupe"
L["dialog.tooltip.classes"] = "nombre d'une classe spécifique"
L["dialog.tooltip.age"] = "âge du groupe en minutes"
L["dialog.tooltip.voice"] = "à une discussion audio"
L["dialog.tooltip.myrealm"] = "leader de mon royaume"
L["dialog.tooltip.noid"] = "instances où je n'ai pas d'ID"
L["dialog.tooltip.matchingid"] = "groupes avec les mêmes boss tué"
L["dialog.tooltip.seewebsite"] = "voir site web"
L["dialog.tooltip.difficulty"] = "difficulté"
L["dialog.tooltip.raids"] = "sélection d'un raid spécifique"
L["dialog.tooltip.dungeons"] = "sélection d'un donjon spécifique"
L["dialog.tooltip.timewalking"] = "sélection d'un donjon timewalking"
L["dialog.tooltip.arena"] = "sélection d'une arène spécifique"
L["dialog.tooltip.warmode"] = "warmode enabled"
L["dialog.tooltip.ex.parentheses"] = "(voice or not voice)"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
L["dialog.copy.url.keywords"] = "Appuyez sur CTRL+C pour copier le lien vers la liste des mots-clés"

L["settings.dialogMovable.title"] = "Dialogue mobile"
L["settings.dialogMovable.tooltip"] = "Permet de déplacer la boîte de dialogue avec la souris. Un clic droit réinitialise la position."
L["settings.classNamesInTooltip.title"] = "Noms de classe dans l'info-bulle"
L["settings.classNamesInTooltip.tooltip"] = "Affiche une liste des classes par rôle dans l'info-bulle d'un groupe prédéfini."
L["settings.coloredGroupTexts.title"] = "Nom du groupe coloré"
L["settings.coloredGroupTexts.tooltip"] = "Affiche le nom du groupe en vert si le groupe est nouveau et en rouge si vous avez déjà été refusé. Affiche le nom de l'activité en rouge si vous avez un verrouillage sur cette instance."
L["settings.classBar.title"] = "Barre en couleur de classe"
L["settings.classBar.tooltip"] = "Affiche une petite barre de couleur de classe sous chaque rôle dans la liste des groupes de donjons prédéfinis."
L["settings.classCircle.title"] = "Cercle en couleur de classe"
L["settings.classCircle.tooltip"] = "Affiche un cercle de couleur de classe à l'arrière-plan de chaque rôle dans la liste des groupes de donjons prédéfinis."
L["settings.leaderCrown.title"] = "Afficher chef de groupe"
L["settings.leaderCrown.tooltip"] = "Affiche une petite couronne au-dessus du rôle du chef de groupe dans la liste des groupes de donjon prédéfinis."
L["settings.ratingInfo.title"] = "Classement du chef de groupe"
L["settings.ratingInfo.tooltip"] = "Affiche le classement Mythic+ ou PvP du chef de groupe dans la liste de groupes prédéfinie."
L["settings.oneClickSignUp.title"] = "Inscription en un clic"
L["settings.oneClickSignUp.tooltip"] = "Inscrivez-vous directement à un groupe en cliquant dessus, au lieu de le sélectionner d'abord, puis de cliquer sur s'inscrire."
L["settings.persistSignUpNote.title"] = "Note d'inscription persistante"
L["settings.persistSignUpNote.tooltip"] = "Persiste la « note au chef de groupe » lors de l'inscription à différents groupes. Par défaut, la note est supprimée lorsqu'un nouveau groupe est sélectionné."
L["settings.signupOnEnter.title"] = "Inscrivez-vous avec Entrée"
L["settings.signupOnEnter.tooltip"] = "Concentrez automatiquement la zone de texte « note au chef de groupe » lors de l'inscription à un nouveau groupe et confirmez votre candidature en appuyant sur Entrée."
L["settings.skipSignUpDialog.title"] = "Ignorer dialogue d'inscription"
L["settings.skipSignUpDialog.tooltip"] = "Ignorez le rôle et notez l'invite si possible et inscrivez-vous immédiatement au groupe. Maintenez la touche Maj enfoncée pour toujours afficher la boîte de dialogue."
