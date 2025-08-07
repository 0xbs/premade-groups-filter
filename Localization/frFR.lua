-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2025 Bernhard Saumweber
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

L["error.syntax"] = "|cffff0000Erreur de syntaxe dans le filtre d’expression|r\n\nCela signifie que votre expression de filtre pour la recherche avancée est incorrecte. Par exemple, il peut manquer une parenthèse, ou alors vous avez écrit 'tanks=1' au lieu de 'tanks==1'.\n\nMessage d’erreur détaillé :\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Erreur sémantique dans le filtre d’expression|r\n\nLa syntaxe est juste mais le nom d’une variable est incorrect. Exemple : tansk au lieu de tanks.\n\nMessage d’erreur détaillé :\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Erreur sémantique dans le filtre d’expression|r\n\nLes mots-clés 'name', 'comment' et 'findnumber' ne sont plus pris en charge. Veuillez les supprimer de votre expression de filtre avancé ou appuyer sur le bouton de réinitialisation.\n\nÀ partir du pré-patch de Battle for Azeroth, ces valeurs sont protégées par Blizzard et ne peuvent plus être lues par aucun addon.\n\nUtilisez la barre de recherche par défaut au-dessus de la liste des groupes pour filtrer les noms manuellement.\n\nMessage d’erreur détaillé :\n|cffaaaaaa%s|r"
L["message.settingsupgraded"] = "Premade Groups Filter : paramètres migrés vers la version %s"

L["dialog.settings"] = GAMEMENU_OPTIONS
L["dialog.reset"] = "Réinitialiser"
L["dialog.reset.confirm"] = "Souhaitez-vous vraiment réinitialiser tous les champs ?"
L["dialog.refresh"] = "Rechercher"
L["dialog.expl.simple"] = "Sélectionner une catégorie en cliquant dessus, puis définir le nombre souhaité"
L["dialog.expl.state"] = "Le groupe doit contenir :"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "Si les options ci-dessus sont trop limitées, utiliser les expressions avancées."
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
L["dialog.mprating"]   = "Cl. M+ ............................."
L["dialog.pvprating"]  = "Classement JcJ ....................."
L["dialog.defeated"]   = "Boss de raid vaincus"
L["dialog.sorting"] = "Tri"
L["dialog.usepgf.tooltip"] = "Activer / désactiver Premade Groups Filter"
L["dialog.usepgf.usage"] = "Pour obtenir des résultats pertinents, utilisez le champ de recherche en même temps que PGF, car le nombre de résultats renvoyés par le serveur est limité."
L["dialog.usepgf.results.server"] = "Groupes affichés par le serveur : |cffffffff%d|r"
L["dialog.usepgf.results.removed"] = "Groupes cachés par PGF : |cffffffff%d|r"
L["dialog.usepgf.results.displayed"] = "Groupes affichés par PGF : |cffffffff%d|r"
L["dialog.tooltip.title"] = "Liste des expressions avancées"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Description"
L["dialog.tooltip.op.logic"] = "Opérateurs logiques"
L["dialog.tooltip.op.number"] = "Opérateurs numériques"
L["dialog.tooltip.op.string"] = "Opérateurs textes"
L["dialog.tooltip.op.func"] = "Fonctions"
L["dialog.tooltip.example"] = "Exemple"
L["dialog.tooltip.ilvl"] = "niveau d’objet requis"
L["dialog.tooltip.myilvl"] = "mon niveau d’objet"
L["dialog.tooltip.hlvl"] = "niveau JcJ requis"
L["dialog.tooltip.pvprating"] = "classement JcJ du chef de groupe"
L["dialog.tooltip.mprating"] = "classement Mythique + du chef de groupe"
L["dialog.tooltip.defeated"] = "nombre de boss déjà tués"
L["dialog.tooltip.members"] = "nombre de joueurs"
L["dialog.tooltip.tanks"] = "nombre de tanks"
L["dialog.tooltip.heals"] = "nombre de soigneurs"
L["dialog.tooltip.dps"] = "nombre de DPS"
L["dialog.tooltip.partyfit"] = "y a-t-il des places pour les « rôles » de mon groupe"
L["dialog.tooltip.classes"] = "nombre de classes spécifiques"
L["dialog.tooltip.age"] = "groupe créé il y a (en minutes)"
L["dialog.tooltip.voice"] = "y a-t-il un vocal"
L["dialog.tooltip.myrealm"] = "le chef de groupe est de mon royaume"
L["dialog.tooltip.noid"] = "instances où je n’ai pas d’ID"
L["dialog.tooltip.matchingid"] = "même boss tué que moi"
L["dialog.tooltip.seewebsite"] = "afficher le site web"
L["dialog.tooltip.difficulty"] = "difficulté"
L["dialog.tooltip.raids"] = "sélection d’un raid spécifique"
L["dialog.tooltip.dungeons"] = "sélection d’un donjon spécifique"
L["dialog.tooltip.timewalking"] = "sélection d’un donjon marcheurs du temps"
L["dialog.tooltip.arena"] = "sélection d’une arène spécifique"
L["dialog.tooltip.warmode"] = "mode guerre activé"
L["dialog.copy.url.keywords"] = "Ctrl + C pour copier le lien vers la liste des mots-clés"
L["dialog.filters.group"] = "Groupe"
L["dialog.filters.dungeons"] = "Donjons"
L["dialog.filters.advanced"] = "Expression de filtre avancée"
L["dialog.partyfit"] = "Rôles spécifiques"
L["dialog.partyfit.tooltip"] = "Afficher seulement les groupes qui ont encore des places pour tous les rôles des membres de mon groupe. Fonctionne également si vous êtes seul."
L["dialog.notdeclined"] = "Candidature refusée"
L["dialog.notdeclined.tooltip"] = "Masquer les groupes qui vous ont refusé."
L["dialog.blfit"] = "Furie sanguinaire"
L["dialog.blfit.tooltip"] = "Si personne dans votre groupe ne dispose de Furie sanguinaire (ou sort équivalent), n’afficher que les groupes qui en ont déjà une, ou, après avoir rejoint le groupe, si une place de DPS ou de soigneur est encore disponible. Fonctionne également si vous êtes seul."
L["dialog.brfit"] = "Résurrection en combat"
L["dialog.brfit.tooltip"] = "Si personne dans votre groupe ne dispose d’une Résurrection en combat, n’afficher que les groupes qui en ont déjà une, ou, après avoir rejoint le groupe, s’il reste une place disponible. Fonctionne également si vous êtes seul."
L["dialog.matchingid"] = "ID de Verrouillage"
L["dialog.matchingid.tooltip"] = "Afficher seulement les groupes qui ont exactement la même ID de verrouillage que vous. Les groupes n’ayant aucune ID s’afficheront quand même."
L["dialog.needsbl"] = "Besoin de furie sanguinaire"
L["dialog.needsbl.tooltip"] = "Afficher seulement les groupes qui n’ont pas encore de classe ayant Furie sanguinaire (ou sort équivalent)."
L["dialog.cancelOldestApp"] = "Cliquez pour annuler la plus ancienne"

L["settings.dialogMovable.title"] = "Déverrouiller la fenêtre PGF"
L["settings.dialogMovable.tooltip"] = "Verrouiller / déverrouiller la fenêtre Premade Groups Filter. Clic droit pour réinitialiser la position."
L["settings.classNamesInTooltip.title"] = "Nom des classes dans l’infobulle"
L["settings.classNamesInTooltip.tooltip"] = "Afficher la liste des classes dans l’infobulle. (trié par rôle)"
L["settings.coloredGroupTexts.title"] = "Colorer le nom du groupe"
L["settings.coloredGroupTexts.tooltip"] = "Afficher le groupe en vert s’il est récent et en rouge si vous avez été refusé. Si cette instance possède un verrouillage, le groupe sera également affiché en rouge."
L["settings.classBar.title"] = "Barre de classe en couleur"
L["settings.classBar.tooltip"] = "Afficher une petite barre en couleur de classe sous chaque rôle dans la liste du groupe prédéfini."
L["settings.classCircle.title"] = "Colorer le cercle des classes"
L["settings.classCircle.tooltip"] = "Afficher un cercle de couleur en arrière-plan pour chaque rôle."
L["settings.leaderCrown.title"] = "Couronne sur le Chef de groupe"
L["settings.leaderCrown.tooltip"] = "Afficher une couronne au-dessus du Chef de groupe."
L["settings.ratingInfo.title"] = "Classement du Chef de groupe"
L["settings.ratingInfo.tooltip"] = "Afficher le classement Mythique + ou JcJ du Chef de groupe."
L["settings.oneClickSignUp.title"] = "Inscription en un clic"
L["settings.oneClickSignUp.tooltip"] = "Cliquer sur un groupe vous inscrira automatiquement."
L["settings.persistSignUpNote.title"] = "Conserver la note d’inscription"
L["settings.persistSignUpNote.tooltip"] = "Conserver la « Note au Chef de groupe » lors de l’inscription à différents groupes. Par défaut, la note est supprimée lorsqu’un nouveau groupe est sélectionné."
L["settings.signupOnEnter.title"] = "S’inscrire avec Entrée"
L["settings.signupOnEnter.tooltip"] = "Activer automatiquement la zone de texte « Note au Chef de groupe » lors de votre inscription à un nouveau groupe et confirmez votre candidature en appuyant sur Entrée."
L["settings.skipSignUpDialog.title"] = "Ignorer la vérification des rôles"
L["settings.skipSignUpDialog.tooltip"] = "Ignorer la sélection du rôle et s’inscrire immédiatement dans le groupe. Appuyez sur la touche Majuscule pour ajouter une note au Chef de groupe."
L["settings.specIcon.title"] = "Afficher la spécialisation"
L["settings.specIcon.tooltip"] = "Affiche une icône représentant la spécialisation de classe de chaque membre dans la liste du groupe prédéfini."
L["settings.missingRoles.title"] = "Afficher les rôles manquants"
L["settings.missingRoles.tooltip"] = "Affiche une icône représentant le rôle manquant dans chaque emplacement vide dans la liste du groupe prédéfini."
L["settings.signUpDeclined.title"] = "S’inscrire aux groupes refusés"
L["settings.signUpDeclined.tooltip"] = "Restaure l’ancien comportement (avant The War Within) et permet de s’inscrire à nouveau dans les groupes qui t’ont précédemment refusé."
L["settings.section.mythicplus.title"] = "Mythique +"
L["settings.section.signup.title"] = "Inscription"
L["settings.rioRatingColors.title"] = "Couleurs de Raider.IO"
L["settings.rioRatingColors.tooltip"] = "Si l’addon Raider.IO est installé et chargé, PGF utilisera la palette de couleur définie par Raider.IO."
L["settings.cancelOldestApp.title"] = "Annuler la plus ancienne candidature"
L["settings.cancelOldestApp.tooltip"] = "Si vous avez atteint le nombre maximal de candidatures en attente, cliquez sur un groupe pour annuler la candidature la plus ancienne, puis cliquez à nouveau pour postuler."
