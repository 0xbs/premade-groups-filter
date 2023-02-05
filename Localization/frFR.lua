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
L["message.noplaystylefix"] = "Premade Groups Filter : L'erreur 'L'action de l'interface a échoué à cause d'un AddOn' n'est pas corrigée, car il semble que vous n'ayez pas de compte entièrement sécurisé et que vous ne puissiez pas  créer de groupes organisés. Voir Addon-FAQ pour plus d'informations et comment corriger ce problème."
L["message.settingsupgraded"] = "Premade Groups Filter : Paramètres migrés vers la version %s"

L["dialog.reset"] = "Réinitialiser"
L["dialog.reset.confirm"] = "Vraiment réinitialiser tous les champs ?"
L["dialog.refresh"] = "Rechercher"
L["dialog.expl.simple"] = "Sélectionner une catégorie en cliquant dessus, puis définir le nombre souhaité"
L["dialog.expl.state"] = "Nombre de joueurs"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "Si les options ci-dessus sont trop limitées, utiliser les requêtes avancées."
L["dialog.normal"] = "Normal"
L["dialog.heroic"] = "Héroïque"
L["dialog.mythic"] = "Mythique"
L["dialog.mythicplus"] = "Mythique +"
L["dialog.to"] = "à"
L["dialog.difficulty"] = "Difficulté ........................."
L["dialog.members"]    = "Membres ............................"
L["dialog.tanks"]      = "Tanks .............................."
L["dialog.heals"]      = "Soigneurs .........................."
L["dialog.dps"]        = "DPS ................................"
L["dialog.mprating"]   = "Classement Mythique+ ..............."
L["dialog.pvprating"]  = "Classement JcJ ....................."
L["dialog.defeated"]   = "Boss de raid vaincus"
L["dialog.sorting"] = "Tri"
L["dialog.usepgf.tooltip"] = "Activer / désactiver Premade Groups Filter"
L["dialog.tooltip.title"] = "Liste des expressions avancées"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Description"
L["dialog.tooltip.op.logic"] = "Opérateurs logiques"
L["dialog.tooltip.op.number"] = "Operateurs numériques"
L["dialog.tooltip.op.string"] = "Operateurs textes"
L["dialog.tooltip.op.func"] = "Fonctions"
L["dialog.tooltip.example"] = "Exemple"
L["dialog.tooltip.ilvl"] = "niveau d'objet requis"
L["dialog.tooltip.myilvl"] = "mon niveau d'objet"
L["dialog.tooltip.hlvl"] = "niveau JcJ requis"
L["dialog.tooltip.pvprating"] = "classement JcJ du chef de groupe"
L["dialog.tooltip.mprating"] = "classement Mythique+ du chef de groupe"
L["dialog.tooltip.defeated"] = "nombre de boss déjà tué"
L["dialog.tooltip.members"] = "nombre de membres"
L["dialog.tooltip.tanks"] = "nombre de tanks"
L["dialog.tooltip.heals"] = "nombre de soigneurs"
L["dialog.tooltip.dps"] = "nombre de DPS"
L["dialog.tooltip.partyfit"] = "y a-t-il des places pour les « rôles » de mon groupe"
L["dialog.tooltip.classes"] = "nombre de classes spécifique"
L["dialog.tooltip.age"] = "âge du groupe (en minute)"
L["dialog.tooltip.voice"] = "y a-t-il une vocal"
L["dialog.tooltip.myrealm"] = "le chef du groupe est de mon royaume"
L["dialog.tooltip.noid"] = "instances où je n'ai pas d'ID"
L["dialog.tooltip.matchingid"] = "même boss tué que mon moi"
L["dialog.tooltip.seewebsite"] = "afficher le site web"
L["dialog.tooltip.difficulty"] = "difficulté"
L["dialog.tooltip.raids"] = "sélection d'un raid spécifique"
L["dialog.tooltip.dungeons"] = "sélection d'un donjon spécifique"
L["dialog.tooltip.timewalking"] = "sélection d'un donjon marcheurs du temps"
L["dialog.tooltip.arena"] = "sélection d'une arène spécifique"
L["dialog.tooltip.warmode"] = "mode guerrre activé"
L["dialog.tooltip.ex.parentheses"] = "(voice or not voice)"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
L["dialog.copy.url.keywords"] = "Ctrl + C pour copier le lien vers la liste des mots-clés"

L["settings.dialogMovable.title"] = "Verrouiller Premade Groups Filter"
L["settings.dialogMovable.tooltip"] = "Verrouiller / déverrouiller la fenêtre Premade Groups Filter. Clic droit pour réinitialiser la position."
L["settings.classNamesInTooltip.title"] = "Noms des classes dans l'infobulle"
L["settings.classNamesInTooltip.tooltip"] = "Afficher la liste des classes, trié par rôle, dans l'infobulle"
L["settings.coloredGroupTexts.title"] = "Colorer le nom du groupe"
L["settings.coloredGroupTexts.tooltip"] = "Afficher le groupe en vert si il est récent. L'afficher en rouge si vous avez été refusé. Si cette instance possède un verouillage, l'afficher également en rouge."
L["settings.classBar.title"] = "Barre de la classe en couleur"
L["settings.classBar.tooltip"] = "Affiche une petite barre de couleur en dessous du nom de la classe de chaque rôle."
L["settings.classCircle.title"] = "Cercle coloré pour les classes"
L["settings.classCircle.tooltip"] = "Affiche un cercle de couleur sur l'arrière-plan de chaque rôle."
L["settings.leaderCrown.title"] = "Couronne pour le chef !"
L["settings.leaderCrown.tooltip"] = "Affiche une couronne au-dessus du chef de groupe."
L["settings.ratingInfo.title"] = "Classement du chef de groupe"
L["settings.ratingInfo.tooltip"] = "Affiche le classement Mythique + ou JcJ du chef de groupe."
L["settings.oneClickSignUp.title"] = "Inscription en un clic"
L["settings.oneClickSignUp.tooltip"] = "Cliquer sur un groupe s'inscrire directement."
L["settings.persistSignUpNote.title"] = "Note d'inscription persistante"
L["settings.persistSignUpNote.tooltip"] = "Persiste la « note au chef de groupe » lors de l'inscription à différents groupes. Par défaut, la note est supprimée lorsqu'un nouveau groupe est sélectionné."
L["settings.signupOnEnter.title"] = "Inscrivez-vous avec Entrée"
L["settings.signupOnEnter.tooltip"] = "Mettre en évidence la zone de texte « note au chef du groupe » automatiquement lorsque vous vous inscrivez à un groupe, puis confirmer appuyant sur Entrée."
L["settings.skipSignUpDialog.title"] = "Ignorer la vérification des rôles"
L["settings.skipSignUpDialog.tooltip"] = "S'inscrire directement en ignorant le rôle. Maj + Clic : afficher la fenêtre des rôles."
L["settings.coloredApplications.title"] = "Colorer les candidatures"
L["settings.coloredApplications.tooltip"] = "Affiche un fond rouge sur les candidature en cours pour les groupes Mythique+ si le groupe n'a plus de place pour votre rôle."
