#tag Menu
Begin Menu MenuMenus
   Begin MenuItem EditMenu
      SpecialMenu = 0
      Text = "&Edit"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem EditUndo
         SpecialMenu = 0
         Text = "Annuler"
         Index = -2147483648
         ShortcutKey = "Z"
         Shortcut = "Cmd+Z"
         MenuModifier = True
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem EditRedo
         SpecialMenu = 0
         Text = "Refaire"
         Index = -2147483648
         ShortcutKey = "Y"
         Shortcut = "Cmd+Y"
         MenuModifier = True
         Help = "Refaire"
         DisabledHelp = "False"
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditSelection
         SpecialMenu = 0
         Text = "Select"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditSelectall
         SpecialMenu = 0
         Text = "Selectall"
         Index = -2147483648
         ShortcutKey = "A"
         Shortcut = "Cmd+A"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditReselect
         SpecialMenu = 0
         Text = "Reselect"
         Index = -2147483648
         Style = 2
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditLink
         SpecialMenu = 0
         Text = "Lier"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditUnlink
         SpecialMenu = 0
         Text = "Délier"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditCopy
         SpecialMenu = 0
         Text = "Copier"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditPaste
         SpecialMenu = 0
         Text = "Coller"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditDelete
         SpecialMenu = 0
         Text = "Supprimer"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem ToolsMenu
      SpecialMenu = 0
      Text = "Outils"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem ToolsLabel
         SpecialMenu = 0
         Text = "Label"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsColor
         SpecialMenu = 0
         Text = "Couleurs"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsColorBorder
            SpecialMenu = 0
            Text = "Border"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsColorFill
            SpecialMenu = 0
            Text = "Fill"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsColorStdFam
            SpecialMenu = 0
            Text = "StdForms"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsColorTransparent
         SpecialMenu = 0
         Text = "Transparence"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsOpq
            SpecialMenu = 0
            Text = "Opaque"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsSTsp
            SpecialMenu = 0
            Text = "SemiTsp"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsTsp
            SpecialMenu = 0
            Text = "Tsp"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsThickness
         SpecialMenu = 0
         Text = "Epaisseur trait"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsThick1
            SpecialMenu = 0
            Text = "1"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsThick2
            SpecialMenu = 0
            Text = "2"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsRigid
         SpecialMenu = 0
         Text = "Rigidifier/Dérigidifier"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsHide
         SpecialMenu = 0
         Text = "Cacher"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsAVPlan
         SpecialMenu = 0
         Text = "Avant-Plan"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsARPlan
         SpecialMenu = 0
         Text = "Arrière-Plan"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsGrid
         SpecialMenu = 0
         Text = "Grille"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsHisto
         SpecialMenu = 0
         Text = "Historique"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem OperaMenu
      SpecialMenu = 0
      Text = "Opérations"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem OperaDivide
         SpecialMenu = 0
         Text = "Diviser"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaCut
         SpecialMenu = 0
         Text = "Decouper"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaMerge
         SpecialMenu = 0
         Text = "Fusionner"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaClone
         SpecialMenu = 0
         Text = "Dupliquer"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaProl
         SpecialMenu = 0
         Text = "Prolonger"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaCreateCenter
         SpecialMenu = 0
         Text = "Creer Centre"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaIdentify
         SpecialMenu = 0
         Text = "Identify"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem TransfosMenu
      SpecialMenu = 0
      Text = "Transformations"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem TransfosDefine
         SpecialMenu = 0
         Text = "Définir"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem DefinirIso
            SpecialMenu = 0
            Text = "Isometries"
            Index = -2147483648
            AutoEnable = True
            SubMenu = True
            Visible = True
            Begin MenuItem DefinirTranslation
               SpecialMenu = 0
               Text = "Translation"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirRotation
               SpecialMenu = 0
               Text = "Rotation"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirDemiTour
               SpecialMenu = 0
               Text = "Demi-tour"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirQuartG
               SpecialMenu = 0
               Text = "Quart de tour à gauche"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirQuartD
               SpecialMenu = 0
               Text = "Quart de tour à droite"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirDeplacement
               SpecialMenu = 0
               Text = "Déplacement"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirSymetrieaxiale
               SpecialMenu = 0
               Text = "Symétrie axiale"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
         End
         Begin MenuItem DefinirSimi
            SpecialMenu = 0
            Text = "Similitudes"
            Index = -2147483648
            AutoEnable = True
            SubMenu = True
            Visible = True
            Begin MenuItem DefinirHomothetie
               SpecialMenu = 0
               Text = "Homothétie"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirSimilitude
               SpecialMenu = 0
               Text = "Similitude directe"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
         End
         Begin MenuItem DefinirAffi
            SpecialMenu = 0
            Text = "Affinités"
            Index = -2147483648
            AutoEnable = True
            SubMenu = True
            Visible = True
            Begin MenuItem DefinirEtirement
               SpecialMenu = 0
               Text = "Etirement"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
            Begin MenuItem DefinirCisaillement
               SpecialMenu = 0
               Text = "Cisaillement"
               Index = -2147483648
               AutoEnable = True
               SubMenu = True
               Visible = True
            End
         End
      End
      Begin MenuItem TransfosAppliquer
         SpecialMenu = 0
         Text = "Appliquer"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem TransfosFixedPoints
         SpecialMenu = 0
         Text = "Points fixes"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem TransfosHide
         SpecialMenu = 0
         Text = "HideTsf"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem InvCurve
         SpecialMenu = 0
         Text = "CourbeInvariante"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuBar MacrosMenu
      SpecialMenu = 0
      Text = "Macros"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem MacrosLoad
         SpecialMenu = 0
         Text = "Charger"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosCreate
         SpecialMenu = 0
         Text = "Creer"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosFinaux
         SpecialMenu = 0
         Text = "Choix final"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosSave
         SpecialMenu = 0
         Text = "Sauvegarder"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosQuit
         SpecialMenu = 0
         Text = "Abandonner"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacSeparator
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         Style = 4
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosDescri
         SpecialMenu = 0
         Text = "Afficher la description d'une macro"
         Index = 0
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosDescri2
            SpecialMenu = 0
            Text = "Sans_titre"
            Index = 0
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosExecute
         SpecialMenu = 0
         Text = "Exécuter une macro"
         Index = 0
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosChoose
            SpecialMenu = 0
            Text = "Sans_titre"
            Index = 0
            Style = 4
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosClose
         SpecialMenu = 0
         Text = "Fermer une macro"
         Index = 0
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosClose2
            SpecialMenu = 0
            Text = "Sans_titre"
            Index = 0
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosErase
         SpecialMenu = 0
         Text = "Supprimer une macro"
         Index = 0
         MenuModifier = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosErase2
            SpecialMenu = 0
            Text = "Sans_titre"
            Index = 0
            AutoEnable = True
            Visible = True
         End
      End
   End
   Begin MenuItem PrefsMenu
      SpecialMenu = 0
      Text = "Préférences"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem Fonds
         SpecialMenu = 0
         Text = "Fonds d'écran"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem Install
            SpecialMenu = 0
            Text = "Installer"
            Index = -2147483648
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem UnInstall
            SpecialMenu = 0
            Text = "Retirer"
            Index = -2147483648
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
      End
      Begin MenuItem PrefsStdForms
         SpecialMenu = 0
         Text = "StdForms"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsMagDist
         SpecialMenu = 0
         Text = "Mag Dist"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsAjust
         SpecialMenu = 0
         Text = "Ajustement automatique"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsTrace
         SpecialMenu = 0
         Text = "Trajectoires"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsPolyg
         SpecialMenu = 0
         Text = "Formes pointées"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsFleches
         SpecialMenu = 0
         Text = "Formes fléchées"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsBiface
         SpecialMenu = 0
         Text = "Formes bifaces"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsUL
         SpecialMenu = 0
         Text = "UL"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsULDef
            SpecialMenu = 0
            Text = "Defaut"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsULChoix
            SpecialMenu = 0
            Text = "Choisir"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsUA
         SpecialMenu = 0
         Text = "UA"
         Index = -2147483648
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsUADef
            SpecialMenu = 0
            Text = "Defaut"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsUAChoix
            SpecialMenu = 0
            Text = "Choisir"
            Index = -2147483648
            AutoEnable = True
            Visible = True
         End
      End
   End
   Begin MenuItem NotesMenu
      SpecialMenu = 0
      Text = "Notes"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem NotesOpen
         SpecialMenu = 0
         Text = "Ouvrir"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem HelpMenu
      SpecialMenu = 0
      Text = "Aide"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem HelpView
         SpecialMenu = 0
         Text = "Aide"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpUG
         SpecialMenu = 0
         Text = "Guide Utilisateur"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpVisit
         SpecialMenu = 0
         Text = "CREM"
         Index = -2147483648
         Style = 4
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpAbout
         SpecialMenu = 0
         Text = "A propos"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
   End
End
#tag EndMenu
