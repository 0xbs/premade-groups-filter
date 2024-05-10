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

if GetLocale() ~= "frFR" then return end

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000Erreur de syntaxe dans le filtre d’expression|r\n\nCela signifie que votre expression de filtre pour la recherche avancée est incorrecte. Par exemple, il peut manquer une paranthèse, ou alors ou vous avez écrit 'tanks=1' au lieu de 'tanks==1'.\n\nMessage d’erreur détaillé :\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Erreur sémantique dans le filtre d’expression|r\n\nLa syntaxe est juste mais le nom d’une variable est incorrecte. Exemple : tansk au lieu de tanks.\n\nMessage d’erreur détaillé :\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Erreur sémantique dans le filtre d’expression|r\n\nLes mots-clés 'name', 'comment' et 'findnumber' ne sont plus pris en charge. Veuillez les supprimer de votre expression de filtre avancé ou appuyer sur le bouton de réinitialisation.\n\nÀ partir du pré-patch de Battle for Azeroth, ces valeurs sont protégées par Blizzard et ne peuvent plus être lues par aucun addon.\n\nUtilisez la barre de recherche par défaut au-dessus de la liste des groupes pour filtrer les noms manuellement.\n\nMessage d’erreur détaillé :\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter n’appliquera pas de correctif pour les erreurs liées à « L’action d'interface a échoué en raison d'un Adddon » car vous ne semblez pas disposer d'un compte entièrement sécurisé et ne pouvez pas créer de groupes prédéfinis. Consultez la FAQ de l’addon pour plus d’informations et comment résoudre ce problème."
L["message.settingsupgraded"] = "Premade Groups Filter : paramètres migrés vers la version %s"

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
L["dialog.tooltip.op.number"] = "Operateurs numériques"
L["dialog.tooltip.op.string"] = "Operateurs textes"
L["dialog.tooltip.op.func"] = "Fonctions"
L["dialog.tooltip.example"] = "Exemple"
L["dialog.tooltip.ilvl"] = "niveau d’objet requis"
L["dialog.tooltip.myilvl"] = "mon niveau d’objet"
L["dialog.tooltip.hlvl"] = "niveau JcJ requis"
L["dialog.tooltip.pvprating"] = "classement JcJ du chef de groupe"
L["dialog.tooltip.mprating"] = "classement Mythique + du chef de groupe"
L["dialog.tooltip.defeated"] = "nombre de boss déjà tué"
L["dialog.tooltip.members"] = "nombre de joueurs"
L["dialog.tooltip.tanks"] = "nombre de tanks"
L["dialog.tooltip.heals"] = "nombre de soigneurs"
L["dialog.tooltip.dps"] = "nombre de DPS"
L["dialog.tooltip.partyfit"] = "y a-t-il des places pour les « rôles » de mon groupe"
L["dialog.tooltip.classes"] = "nombre de classes spécifique"
L["dialog.tooltip.age"] = "groupe créé il y a (en minute)"
L["dialog.tooltip.voice"] = "y a-t-il un vocal"
L["dialog.tooltip.myrealm"] = "le chef du groupe est de mon royaume"
L["dialog.tooltip.noid"] = "instances où je n’ai pas d’ID"
L["dialog.tooltip.matchingid"] = "même boss tué que mon moi"
L["dialog.tooltip.seewebsite"] = "afficher le site web"
L["dialog.tooltip.difficulty"] = "difficulté"
L["dialog.tooltip.raids"] = "sélection d’un raid spécifique"
L["dialog.tooltip.dungeons"] = "sélection d’un donjon spécifique"
L["dialog.tooltip.timewalking"] = "sélection d’un donjon marcheurs du temps"
L["dialog.tooltip.arena"] = "sélection d’une arène spécifique"
L["dialog.tooltip.warmode"] = "mode guerrre activé"
L["dialog.copy.url.keywords"] = "Ctrl + C pour copier le lien vers la liste des mots-clés"
L["dialog.filters.group"] = "Groupe"
L["dialog.filters.dungeons"] = "Donjons"
L["dialog.filters.advanced"] = "Expression de filtre avancée"
L["dialog.partyfit"] = "Rôles spécifiques"
L["dialog.partyfit.tooltip"] = "Afficher uniquement les groupes qui ont encore des places pour tous les rôles des membres de mon groupe. Fonctionne également si vous êtes seul."
L["dialog.notdeclined"] = "Candidature refusée"
L["dialog.notdeclined.tooltip"] = "Masquer les groupes qui vous ont refusé. Affiche toujours les groupes pour lesquels votre demande a expiré."
L["dialog.blfit"] = "Furie sanguinaire"
L["dialog.blfit.tooltip"] = "Dans votre groupe, si personne n’a de Furie sanguinaire (ou autre sort similaire) alors PGF affichera uniquement les groupes qui ont en une, ou seulement après avoir rejoint le groupe, il y a toujours une place de dps ou de soigneur ouvert. Fonctionne également si vous êtes seul."
L["dialog.brfit"] = "Résurrection en combat"
L["dialog.brfit.tooltip"] = "Dans votre groupe, si personne n’a de résurrection en combat alors PGF affichera uniquement les groupes qui ont en une, ou seulement après avoir rejoint le groupe, il y a toujours une place de disponible. Fonctionne également si vous êtes seul."
L["dialog.matchingid"] = "ID de Verrouillage"
L["dialog.matchingid.tooltip"] = "Afficher seulement les groupes qui ont exactement la même ID de verrouillage que vous. Les groupes n’ayant aucune ID s’afficheront quand même."

L["settings.dialogMovable.title"] = "Déverrouiller la fenêtre PGF"
L["settings.dialogMovable.tooltip"] = "Verrouiller / déverrouiller la fenêtre Premade Groups Filter. Clic droit pour réinitialiser la position."
L["settings.classNamesInTooltip.title"] = "Nom des classes dans l’infobulle"
L["settings.classNamesInTooltip.tooltip"] = "Afficher la liste des classes dans l’infobulle. (trié par rôle)"
L["settings.coloredGroupTexts.title"] = "Colorer le nom du groupe"
L["settings.coloredGroupTexts.tooltip"] = "Afficher le groupe en vert si il est récent et en rouge si vous avez été refusé. Si cette instance possède un verrouillage, l’afficher également en rouge."
L["settings.classBar.title"] = "Barre de classe en couleur"
L["settings.classBar.tooltip"] = "Afficher une barre de couleur en dessous de la classe pour chaque rôle."
L["settings.classCircle.title"] = "Colorer le cercle des classes"
L["settings.classCircle.tooltip"] = "Afficher un cercle de couleur en arrière-plan pour chaque rôle."
L["settings.leaderCrown.title"] = "Couronne sur le chef du groupe"
L["settings.leaderCrown.tooltip"] = "Afficher une couronne au-dessus du chef de groupe."
L["settings.ratingInfo.title"] = "Classement du chef de groupe"
L["settings.ratingInfo.tooltip"] = "Afficher le classement Mythique + ou JcJ du chef de groupe."
L["settings.oneClickSignUp.title"] = "Inscription en un clic"
L["settings.oneClickSignUp.tooltip"] = "Cliquer sur un groupe vous inscrira automatiquement."

L["settings.persistSignUpNote.title"] = "Persister la note d’inscription"
L["settings.persistSignUpNote.tooltip"] = "Conserver la « Note au chef de groupe » lors de l’inscription à différents groupes. Par défaut, la note est supprimée lorsqu’un nouveau groupe est sélectionné."
L["settings.signupOnEnter.title"] = "S’inscre avec Entrée"
L["settings.signupOnEnter.tooltip"] = "Activer automatiquement la zone de texte « Note au chef de groupe » lors de votre inscription à un nouveau groupe et confirmez votre candidature en appuyant sur Entrée."
L["settings.skipSignUpDialog.title"] = "Ignorer la vérification des rôles"
L["settings.skipSignUpDialog.tooltip"] = "Ignorer la sélection du rôle et s’inscire immédiatement dans le groupe. Appuyez sur la touche Majuscule pour ajouter une note au chef de groupe."
L["settings.coloredApplications.title"] = "Colorer les candidatures"
L["settings.coloredApplications.tooltip"] = "Afficher un fond rouge pour les candidatures en attente si le groupe n’a plus de place pour votre rôle."
