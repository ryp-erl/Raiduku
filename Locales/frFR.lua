local L = LibStub("AceLocale-3.0"):NewLocale("Raiduku", "frFR")

if not L then
    return
end

-- Commands
L["cmd-configure-desc"] = "Personnalise les paramètres de l'addon"
L["cmd-export-desc"] = "Exporte les attributions de butin au format CSV pour |cff1eff00thatsmybis.com|r"
L["cmd-prios-desc"] = "Importe les priorités de butin au format CSV depuis |cff1eff00thatsmybis.com|r"
L["cmd-softres-desc"] = "Importe les réservations de butin au format CSV depuis |cff1eff00softres.it|r"

-- Infos
L["export-data-reminder"] =
    "Tu peux exporter les attributions de butin pour |cff1eff00thatsmybis.com|r en utilisant |cffffe600/rdk export|r"
L["saved-for-tmb"] = "Enregistré pour |cff1eff00thatsmybis.com|r que %s a reçu %s pour sa %s"
L["waiting-for-roll"] = "|cffffffffen attente...|r"
L["loot-method-is"] = "Le mode de butin est |cff00ddff%s|r"
L["not-in-charge"] = "Le node de butin est |cff00ddff%s|r but mais tu n'es |cffffe600pas responsable du butin|r"
L["loot-helper-is"] = "L'aide à la gestion du butin est |cff33ff00%s|r"
L["recycler-is"] = "Le responsable du recyclage est |cffff8000%s|r"
L["recycler-is-now"] = "Le responsable du recyclage est maintenant |cffff8000%s|r"
L["change-recycler"] = "Le responsable du recyclage est |cffff8000%s|r. Est-ce que tu veux le changer?"
L["to-change-recycler-run"] = "Pour changer de responsable du recyclage, lance |cffffe600/rdk config|r"
L["cannot-award-to"] = "|cffff0000Impossible d'attribuer le butin à |r %s"
L["confirm-manual-award-save-for-tmb"] =
    "%s a été attribué manuellement à |cffff8000%s|r.\nEst-ce que tu veux quand même sauvegarder l'information pour |cff1eff00thatsmybis.com|r ?"
L["prios-saved"] = "priorités |cff33ff00enregistrées|r"
L["softres-saved"] = "réservations |cff33ff00enregistrées|r"
L["prios-found"] = "priorités |cff33ff00trouvées|r"
L["softres-found"] = "réservations |cff33ff00trouvées|r"
L["prios-invalid-import"] =
    "|cffff0000Import erroné|r: la première ligne n'est pas un en-tête valide ou supporté de |cff1eff00thatsmybis.com|r"
L["softres-invalid-import"] =
    "|cffff0000Import erroné|r: la première ligne n'est pas un en-tête valide ou supporté de |cff1eff00softres.it|r"
L["loot-later"] = "{rt6} Attribution du butin plus tard {rt6}"
L["x-come-trade-on-me"] = "%s ==> ÉCHANGE avec moi"
L["removed-x-from-prios-for-x"] = "%s a été retiré des prios importées pour %s"
L["trade-back-loot-history"] = "%s t'a rendu %s. Veux-tu mettre à jour l'historique de loot ?"
L["removed-data-from-x-dates"] = "Données supprimées pour les dates suivantes: %s"

-- Labels
L["configuration"] = "Configuration"
L["prios-paste-and-override"] = "Copie et écrase les priorités:"
L["prios-paste-and-override"] = "Copie et écrase les réservations:"
L["prios-import"] = "Import des priorités de |cff1eff00thatsmybis.com|r"
L["softres-import"] = "Import des réservations de |cff1eff00softres.it|r"
L["copy-following-data"] = "Copie les données suivantes:"
L["managing-loots"] = "Gestion du butin"
L["open-recycler-popup-reminder"] = "Ouvrir une alerte pour mettre à jour le responsable du recyclage"
L["choose-dates"] = "Choisis une ou plusieurs dates:"
L["choose-recycler"] = "Choisis un responsable pour recycler le butin:"
L["auto-award-common"] = "Auto-attribuer le butin |c1eff00Commun|r"
L["auto-award-rare"] = "Auto-attribuer le butin |c0070ddRare|r"
L["import-and-override"] = "Importe et écrase"
L["remove-all"] = "Tout supprimer"
L["delete-selected-dates"] = "Supprimer les dates selectionnées"
L["x-dates-selected"] = "%s date(s) selectionnée(s)"
L["activate-soft-prio"] = "Active un mode soft-prio (utilise les prios de TMB comme du softres)"
L["reverse-roll-order"] = "Inverse l'ordre du rand (1 est le plus fort)"

-- Buttons
L["now"] = "Maintenant"
L["later"] = "Plus tard"
L["ask-for-rolls"] = "Demander\nun jet de dé"
L["award-loot"] = "Attribuer"
L["recycle-loot"] = "Recycler"
L["award-prio"] = "Attribuer la prio"
L["award-softres"] = "Attribuer la softres"
L["remove-record"] = "Retirer l'info"
L["remove-last-player"] = "Retirer le dernier joueur"
L["change-award-ownership-to-me"] = "Me mettre receveur du butin"

-- Wording
L["main-spec"] = "spé principale"
L["off-spec"] = "spé secondaire"
L["auto-awarding"] = "Attribution automatique"
L["enabled"] = "activée"
L["disabled"] = "désactivée"
L["yes"] = "Oui"
L["no"] = "Non"
L["auto-win"] = "|cFF00FF00(Victoire automatique)|r"
L["auto-pass"] = "|cff9C9C9C(Passe automatique)|r"
