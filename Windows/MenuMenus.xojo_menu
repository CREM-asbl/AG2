#tag Menu
Begin Menu MenuMenus
   Begin MenuItem EditMenu
      SpecialMenu = 0
      Value = "&Edit"
      Index = -2147483648
      Text = "&Edit"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem EditRedo
         SpecialMenu = 0
         Value = "Refaire"
         Index = -2147483648
         Text = "Refaire"
         ShortcutKey = "Y"
         Shortcut = "Cmd+Y"
         MenuModifier = True
         Help = "Refaire"
         DisabledHelp = "False"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditSelection
         SpecialMenu = 0
         Value = "Select"
         Index = -2147483648
         Text = "Select"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditUndo
         SpecialMenu = 0
         Value = "Annuler"
         Index = -2147483648
         Text = "Annuler"
         ShortcutKey = "Z"
         Shortcut = "Cmd+Z"
         MenuModifier = True
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem EditSelectall
         SpecialMenu = 0
         Value = "Selectall"
         Index = -2147483648
         Text = "Selectall"
         ShortcutKey = "A"
         Shortcut = "Cmd+A"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditReselect
         SpecialMenu = 0
         Value = "Reselect"
         Index = -2147483648
         Text = "Reselect"
         Style = 2
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditLink
         SpecialMenu = 0
         Value = "Lier"
         Index = -2147483648
         Text = "Lier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditUnlink
         SpecialMenu = 0
         Value = "Délier"
         Index = -2147483648
         Text = "Délier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditCopy
         SpecialMenu = 0
         Value = "Copier"
         Index = -2147483648
         Text = "Copier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditPaste
         SpecialMenu = 0
         Value = "Coller"
         Index = -2147483648
         Text = "Coller"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditDelete
         SpecialMenu = 0
         Value = "Supprimer"
         Index = -2147483648
         Text = "Supprimer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem ToolsMenu
      SpecialMenu = 0
      Value = "Outils"
      Index = -2147483648
      Text = "Outils"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem ToolsLabel
         SpecialMenu = 0
         Value = "Label"
         Index = -2147483648
         Text = "Label"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsColor
         SpecialMenu = 0
         Value = "Couleurs"
         Index = -2147483648
         Text = "Couleurs"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsColorBorder
            SpecialMenu = 0
            Value = "Border"
            Index = -2147483648
            Text = "Border"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsColorFill
            SpecialMenu = 0
            Value = "Fill"
            Index = -2147483648
            Text = "Fill"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsColorStdFam
            SpecialMenu = 0
            Value = "StdForms"
            Index = -2147483648
            Text = "StdForms"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsColorTransparent
         SpecialMenu = 0
         Value = "Transparence"
         Index = -2147483648
         Text = "Transparence"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsOpq
            SpecialMenu = 0
            Value = "Opaque"
            Index = -2147483648
            Text = "Opaque"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsSTsp
            SpecialMenu = 0
            Value = "SemiTsp"
            Index = -2147483648
            Text = "SemiTsp"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsTsp
            SpecialMenu = 0
            Value = "Tsp"
            Index = -2147483648
            Text = "Tsp"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsThickness
         SpecialMenu = 0
         Value = "Epaisseur trait"
         Index = -2147483648
         Text = "Epaisseur trait"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsThick1
            SpecialMenu = 0
            Value = "1"
            Index = -2147483648
            Text = "1"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsThick2
            SpecialMenu = 0
            Value = "2"
            Index = -2147483648
            Text = "2"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsRigid
         SpecialMenu = 0
         Value = "Rigidifier/Dérigidifier"
         Index = -2147483648
         Text = "Rigidifier/Dérigidifier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsHide
         SpecialMenu = 0
         Value = "Cacher"
         Index = -2147483648
         Text = "Cacher"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsAVPlan
         SpecialMenu = 0
         Value = "Avant-Plan"
         Index = -2147483648
         Text = "Avant-Plan"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsARPlan
         SpecialMenu = 0
         Value = "Arrière-Plan"
         Index = -2147483648
         Text = "Arrière-Plan"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsGrid
         SpecialMenu = 0
         Value = "Grille"
         Index = -2147483648
         Text = "Grille"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsHisto
         SpecialMenu = 0
         Value = "Historique"
         Index = -2147483648
         Text = "Historique"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem OperaMenu
      SpecialMenu = 0
      Value = "Opérations"
      Index = -2147483648
      Text = "Opérations"
      AutoEnabled = True
      AutoEnable = True
      Visible = False
      Begin MenuItem OperaDivide
         SpecialMenu = 0
         Value = "Diviser"
         Index = -2147483648
         Text = "Diviser"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaCut
         SpecialMenu = 0
         Value = "Decouper"
         Index = -2147483648
         Text = "Decouper"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaMerge
         SpecialMenu = 0
         Value = "Fusionner"
         Index = -2147483648
         Text = "Fusionner"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaClone
         SpecialMenu = 0
         Value = "Dupliquer"
         Index = -2147483648
         Text = "Dupliquer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaProl
         SpecialMenu = 0
         Value = "Prolonger"
         Index = -2147483648
         Text = "Prolonger"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaCreateCenter
         SpecialMenu = 0
         Value = "Creer Centre"
         Index = -2147483648
         Text = "Creer Centre"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaIdentify
         SpecialMenu = 0
         Value = "Identify"
         Index = -2147483648
         Text = "Identify"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem UntitledMenu0
         SpecialMenu = 0
         Value = ""
         Index = -2147483648
         Text = ""
         AutoEnabled = False
         AutoEnable = False
         Visible = False
      End
   End
   Begin MenuItem TransfosMenu
      SpecialMenu = 0
      Value = "Transformations"
      Index = -2147483648
      Text = "Transformations"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem TransfosDefine
         SpecialMenu = 0
         Value = "Définir"
         Index = -2147483648
         Text = "Définir"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem DefinirTranslation
            SpecialMenu = 0
            Value = "Translation"
            Index = -2147483648
            Text = "Translation"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirRotation
            SpecialMenu = 0
            Value = "Rotation"
            Index = -2147483648
            Text = "Rotation"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirDemiTour
            SpecialMenu = 0
            Value = "Demi-tour"
            Index = -2147483648
            Text = "Demi-tour"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirQuartG
            SpecialMenu = 0
            Value = "Quart de tour à gauche"
            Index = -2147483648
            Text = "Quart de tour à gauche"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirQuartD
            SpecialMenu = 0
            Value = "Quart de tour à droite"
            Index = -2147483648
            Text = "Quart de tour à droite"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirDeplacement
            SpecialMenu = 0
            Value = "Déplacement"
            Index = -2147483648
            Text = "Déplacement"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirSymetrieaxiale
            SpecialMenu = 0
            Value = "Symétrie axiale"
            Index = -2147483648
            Text = "Symétrie axiale"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirHomothetie
            SpecialMenu = 0
            Value = "Homothétie"
            Index = -2147483648
            Text = "Homothétie"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem DefinirSimilitude
            SpecialMenu = 0
            Value = "Similitude directe"
            Index = -2147483648
            Text = "Similitude directe"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem DefinirEtirement
            SpecialMenu = 0
            Value = "Etirement"
            Index = -2147483648
            Text = "Etirement"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem DefinirCisaillement
            SpecialMenu = 0
            Value = "Cisaillement"
            Index = -2147483648
            Text = "Cisaillement"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
      End
      Begin MenuItem TransfosAppliquer
         SpecialMenu = 0
         Value = "Appliquer"
         Index = -2147483648
         Text = "Appliquer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem TransfosFixedPoints
         SpecialMenu = 0
         Value = "Points fixes"
         Index = -2147483648
         Text = "Points fixes"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem TransfosHide
         SpecialMenu = 0
         Value = "HideTsf"
         Index = -2147483648
         Text = "HideTsf"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem InvCurve
         SpecialMenu = 0
         Value = "CourbeInvariante"
         Index = -2147483648
         Text = "CourbeInvariante"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem MacrosMenu
      SpecialMenu = 0
      Value = "Macros"
      Index = -2147483648
      Text = "Macros"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem MacrosLoad
         SpecialMenu = 0
         Value = "Charger"
         Index = -2147483648
         Text = "Charger"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosCreate
         SpecialMenu = 0
         Value = "Creer"
         Index = -2147483648
         Text = "Creer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosFinaux
         SpecialMenu = 0
         Value = "Choix final"
         Index = -2147483648
         Text = "Choix final"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosSave
         SpecialMenu = 0
         Value = "Sauvegarder"
         Index = -2147483648
         Text = "Sauvegarder"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosQuit
         SpecialMenu = 0
         Value = "Abandonner"
         Index = -2147483648
         Text = "Abandonner"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacSeparator
         SpecialMenu = 0
         Value = "-"
         Index = -2147483648
         Text = "-"
         Style = 4
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosDescri
         SpecialMenu = 0
         Value = "Afficher la description d'une macro"
         Index = 0
         Text = "Afficher la description d'une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosDescri2
            SpecialMenu = 0
            Value = "Sans_titre"
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosExecute
         SpecialMenu = 0
         Value = "Exécuter une macro"
         Index = 0
         Text = "Exécuter une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosChoose
            SpecialMenu = 0
            Value = "Sans_titre"
            Index = 0
            Text = "Sans_titre"
            Style = 4
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosClose
         SpecialMenu = 0
         Value = "Fermer une macro"
         Index = 0
         Text = "Fermer une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosClose2
            SpecialMenu = 0
            Value = "Sans_titre"
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosErase
         SpecialMenu = 0
         Value = "Supprimer une macro"
         Index = 0
         Text = "Supprimer une macro"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosErase2
            SpecialMenu = 0
            Value = "Sans_titre"
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosCopy
         SpecialMenu = 0
         Value = "Copier une macro"
         Index = 0
         Text = "Copier une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosCopy2
            SpecialMenu = 0
            Value = "Sans Titre"
            Index = 0
            Text = "Sans Titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
   End
   Begin MenuItem PrefsMenu
      SpecialMenu = 0
      Value = "Préférences"
      Index = -2147483648
      Text = "Préférences"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem Fonds
         SpecialMenu = 0
         Value = "Fonds d'écran"
         Index = -2147483648
         Text = "Fonds d'écran"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem Install
            SpecialMenu = 0
            Value = "Installer"
            Index = -2147483648
            Text = "Installer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem FondEcranConfigurer
            SpecialMenu = 0
            Value = "Configurer"
            Index = -2147483648
            Text = "Configurer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem UnInstall
            SpecialMenu = 0
            Value = "Retirer"
            Index = -2147483648
            Text = "Retirer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsStdForms
         SpecialMenu = 0
         Value = "StdForms"
         Index = -2147483648
         Text = "StdForms"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsMagDist
         SpecialMenu = 0
         Value = "Mag Dist"
         Index = -2147483648
         Text = "Mag Dist"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsThickness
         SpecialMenu = 0
         Value = "Epaisseur des traits"
         Index = -2147483648
         Text = "Epaisseur des traits"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsTrace
         SpecialMenu = 0
         Value = "Trajectoires"
         Index = -2147483648
         Text = "Trajectoires"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsAjust
         SpecialMenu = 0
         Value = "Ajustement automatique"
         Index = -2147483648
         Text = "Ajustement automatique"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsPolyg
         SpecialMenu = 0
         Value = "Formes pointées"
         Index = -2147483648
         Text = "Formes pointées"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsFleches
         SpecialMenu = 0
         Value = "Formes fléchées"
         Index = -2147483648
         Text = "Formes fléchées"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsBiface
         SpecialMenu = 0
         Value = "Formes bifaces"
         Index = -2147483648
         Text = "Formes bifaces"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsArea
         SpecialMenu = 0
         Value = "Aire"
         Index = -2147483648
         Text = "Aire"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsAreaArith
            SpecialMenu = 0
            Value = "Aire arithmétique"
            Index = -2147483648
            Text = "Aire arithmétique"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsAreaAlg
            SpecialMenu = 0
            Value = "Aire algébrique"
            Index = -2147483648
            Text = "Aire algébrique"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsUL
         SpecialMenu = 0
         Value = "UL"
         Index = -2147483648
         Text = "UL"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsULDef
            SpecialMenu = 0
            Value = "Defaut"
            Index = -2147483648
            Text = "Defaut"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsULChoix
            SpecialMenu = 0
            Value = "Choisir"
            Index = -2147483648
            Text = "Choisir"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsUA
         SpecialMenu = 0
         Value = "UA"
         Index = -2147483648
         Text = "UA"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsUADef
            SpecialMenu = 0
            Value = "Defaut"
            Index = -2147483648
            Text = "Defaut"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsUAChoix
            SpecialMenu = 0
            Value = "Choisir"
            Index = -2147483648
            Text = "Choisir"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
   End
   Begin MenuItem NotesMenu
      SpecialMenu = 0
      Value = "Notes"
      Index = -2147483648
      Text = "Notes"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem NotesOpen
         SpecialMenu = 0
         Value = "Ouvrir"
         Index = -2147483648
         Text = "Ouvrir"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem HelpMenu
      SpecialMenu = 0
      Value = "Aide"
      Index = -2147483648
      Text = "Aide"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem HelpView
         SpecialMenu = 0
         Value = "Aide"
         Index = -2147483648
         Text = "Aide"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpUG
         SpecialMenu = 0
         Value = "Guide Utilisateur"
         Index = -2147483648
         Text = "Guide Utilisateur"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpVisit
         SpecialMenu = 0
         Value = "CREM"
         Index = -2147483648
         Text = "CREM"
         Style = 4
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpAbout
         SpecialMenu = 0
         Value = "A propos"
         Index = -2147483648
         Text = "A propos"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
End
#tag EndMenu
