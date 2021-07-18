#tag Menu
Begin Menu MenuMenus
   Begin MenuItem EditMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "&Edit"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem EditRedo
         SpecialMenu = 0
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
         Index = -2147483648
         Text = "Select"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditUndo
         SpecialMenu = 0
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
         Index = -2147483648
         Text = "Reselect"
         Style = 2
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditLink
         SpecialMenu = 0
         Index = -2147483648
         Text = "Lier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditUnlink
         SpecialMenu = 0
         Index = -2147483648
         Text = "Délier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditCopy
         SpecialMenu = 0
         Index = -2147483648
         Text = "Copier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditPaste
         SpecialMenu = 0
         Index = -2147483648
         Text = "Coller"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditDelete
         SpecialMenu = 0
         Index = -2147483648
         Text = "Supprimer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem ToolsMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Outils"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem ToolsLabel
         SpecialMenu = 0
         Index = -2147483648
         Text = "Label"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsColorTransparent
         SpecialMenu = 0
         Index = -2147483648
         Text = "Transparence"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsOpq
            SpecialMenu = 0
            Index = -2147483648
            Text = "Opaque"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsSTsp
            SpecialMenu = 0
            Index = -2147483648
            Text = "SemiTsp"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsTsp
            SpecialMenu = 0
            Index = -2147483648
            Text = "Tsp"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsThickness
         SpecialMenu = 0
         Index = -2147483648
         Text = "Epaisseur trait"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem ToolsThick1
            SpecialMenu = 0
            Index = -2147483648
            Text = "1"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem ToolsThick2
            SpecialMenu = 0
            Index = -2147483648
            Text = "2"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem ToolsRigid
         SpecialMenu = 0
         Index = -2147483648
         Text = "Rigidifier/Dérigidifier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsHide
         SpecialMenu = 0
         Index = -2147483648
         Text = "Cacher"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsAVPlan
         SpecialMenu = 0
         Index = -2147483648
         Text = "Avant-Plan"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsARPlan
         SpecialMenu = 0
         Index = -2147483648
         Text = "Arrière-Plan"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsGrid
         SpecialMenu = 0
         Index = -2147483648
         Text = "Grille"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ToolsHisto
         SpecialMenu = 0
         Index = -2147483648
         Text = "Historique"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem OperaMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Opérations"
      AutoEnabled = True
      AutoEnable = True
      Visible = False
      Begin MenuItem OperaDivide
         SpecialMenu = 0
         Index = -2147483648
         Text = "Diviser"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaCut
         SpecialMenu = 0
         Index = -2147483648
         Text = "Decouper"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaMerge
         SpecialMenu = 0
         Index = -2147483648
         Text = "Fusionner"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaClone
         SpecialMenu = 0
         Index = -2147483648
         Text = "Dupliquer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaProl
         SpecialMenu = 0
         Index = -2147483648
         Text = "Prolonger"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaCreateCenter
         SpecialMenu = 0
         Index = -2147483648
         Text = "Creer Centre"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem OperaIdentify
         SpecialMenu = 0
         Index = -2147483648
         Text = "Identify"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem UntitledMenu0
         SpecialMenu = 0
         Index = -2147483648
         Text = ""
         AutoEnabled = False
         AutoEnable = False
         Visible = False
      End
   End
   Begin MenuItem TransfosMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Transformations"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem TransfosDefine
         SpecialMenu = 0
         Index = -2147483648
         Text = "Définir"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem DefinirTranslation
            SpecialMenu = 0
            Index = -2147483648
            Text = "Translation"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirRotation
            SpecialMenu = 0
            Index = -2147483648
            Text = "Rotation"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirDemiTour
            SpecialMenu = 0
            Index = -2147483648
            Text = "Demi-tour"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirQuartG
            SpecialMenu = 0
            Index = -2147483648
            Text = "Quart de tour à gauche"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirQuartD
            SpecialMenu = 0
            Index = -2147483648
            Text = "Quart de tour à droite"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirDeplacement
            SpecialMenu = 0
            Index = -2147483648
            Text = "Déplacement"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirSymetrieaxiale
            SpecialMenu = 0
            Index = -2147483648
            Text = "Symétrie axiale"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem DefinirHomothetie
            SpecialMenu = 0
            Index = -2147483648
            Text = "Homothétie"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem DefinirSimilitude
            SpecialMenu = 0
            Index = -2147483648
            Text = "Similitude directe"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem DefinirEtirement
            SpecialMenu = 0
            Index = -2147483648
            Text = "Etirement"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem DefinirCisaillement
            SpecialMenu = 0
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
         Index = -2147483648
         Text = "Appliquer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem TransfosFixedPoints
         SpecialMenu = 0
         Index = -2147483648
         Text = "Points fixes"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem TransfosHide
         SpecialMenu = 0
         Index = -2147483648
         Text = "HideTsf"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem InvCurve
         SpecialMenu = 0
         Index = -2147483648
         Text = "CourbeInvariante"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem MacrosMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Macros"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem MacrosLoad
         SpecialMenu = 0
         Index = -2147483648
         Text = "Charger"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosCreate
         SpecialMenu = 0
         Index = -2147483648
         Text = "Creer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosFinaux
         SpecialMenu = 0
         Index = -2147483648
         Text = "Choix final"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosSave
         SpecialMenu = 0
         Index = -2147483648
         Text = "Sauvegarder"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosQuit
         SpecialMenu = 0
         Index = -2147483648
         Text = "Abandonner"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacSeparator
         SpecialMenu = 0
         Index = -2147483648
         Text = "-"
         Style = 4
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem MacrosDescri
         SpecialMenu = 0
         Index = 0
         Text = "Afficher la description d'une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosDescri2
            SpecialMenu = 0
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosExecute
         SpecialMenu = 0
         Index = 0
         Text = "Exécuter une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosChoose
            SpecialMenu = 0
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
         Index = 0
         Text = "Fermer une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosClose2
            SpecialMenu = 0
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosErase
         SpecialMenu = 0
         Index = 0
         Text = "Supprimer une macro"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosErase2
            SpecialMenu = 0
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem MacrosCopy
         SpecialMenu = 0
         Index = 0
         Text = "Copier une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem MacrosCopy2
            SpecialMenu = 0
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
      Index = -2147483648
      Text = "Préférences"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem Fonds
         SpecialMenu = 0
         Index = -2147483648
         Text = "Fonds d'écran"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem Install
            SpecialMenu = 0
            Index = -2147483648
            Text = "Installer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem FondEcranConfigurer
            SpecialMenu = 0
            Index = -2147483648
            Text = "Configurer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem UnInstall
            SpecialMenu = 0
            Index = -2147483648
            Text = "Retirer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsStdForms
         SpecialMenu = 0
         Index = -2147483648
         Text = "StdForms"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsColor
         SpecialMenu = 0
         Index = -2147483648
         Text = "Couleurs par défaut"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsColorBorder
            SpecialMenu = 0
            Index = -2147483648
            Text = "Couleur du bord"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsColorFill
            SpecialMenu = 0
            Index = -2147483648
            Text = "Couleur du fond"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsColorStdFam
            SpecialMenu = 0
            Index = -2147483648
            Text = "Couleur des formes standard"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsMagDist
         SpecialMenu = 0
         Index = -2147483648
         Text = "Mag Dist"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsThickness
         SpecialMenu = 0
         Index = -2147483648
         Text = "Epaisseur des traits"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsTrace
         SpecialMenu = 0
         Index = -2147483648
         Text = "Trajectoires"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsAjust
         SpecialMenu = 0
         Index = -2147483648
         Text = "Ajustement automatique"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsPolyg
         SpecialMenu = 0
         Index = -2147483648
         Text = "Formes pointées"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsFleches
         SpecialMenu = 0
         Index = -2147483648
         Text = "Formes fléchées"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsBiface
         SpecialMenu = 0
         Index = -2147483648
         Text = "Formes bifaces"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem PrefsArea
         SpecialMenu = 0
         Index = -2147483648
         Text = "Aire"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsAreaArith
            SpecialMenu = 0
            Index = -2147483648
            Text = "Aire arithmétique"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsAreaAlg
            SpecialMenu = 0
            Index = -2147483648
            Text = "Aire algébrique"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsUL
         SpecialMenu = 0
         Index = -2147483648
         Text = "UL"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsULDef
            SpecialMenu = 0
            Index = -2147483648
            Text = "Defaut"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsULChoix
            SpecialMenu = 0
            Index = -2147483648
            Text = "Choisir"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsUA
         SpecialMenu = 0
         Index = -2147483648
         Text = "UA"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsUADef
            SpecialMenu = 0
            Index = -2147483648
            Text = "Defaut"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem PrefsUAChoix
            SpecialMenu = 0
            Index = -2147483648
            Text = "Choisir"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem PrefsPolice
         SpecialMenu = 0
         Index = 1
         Text = "Polices de caractères"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem PrefsPolNom
            SpecialMenu = 0
            Index = -2147483648
            Text = "Nom"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
            Begin MenuItem UntitledItem0
               SpecialMenu = 0
               Index = -2147483648
               Text = "Untitled"
               AutoEnabled = True
               AutoEnable = True
               SubMenu = True
               Visible = True
               Begin MenuItem Untitled
                  SpecialMenu = 0
                  Index = -2147483648
                  Text = ""
                  AutoEnabled = False
                  AutoEnable = False
                  Visible = True
               End
            End
            Begin MenuItem UntitledItem1
               SpecialMenu = 0
               Index = -2147483648
               Text = "Untitled"
               AutoEnabled = True
               AutoEnable = True
               Visible = True
            End
         End
         Begin MenuItem PrefsPolItal
            SpecialMenu = 0
            Index = -2147483648
            Text = "Aspect"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin MenuItem PrefsPolTai
            SpecialMenu = 0
            Index = -2147483648
            Text = "Taille"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
            Begin MenuItem UntitledItem2
               SpecialMenu = 0
               Index = -2147483648
               Text = "Untitled"
               AutoEnabled = True
               AutoEnable = True
               SubMenu = True
               Visible = True
               Begin MenuItem UntitledSeparator
                  SpecialMenu = 0
                  Index = -2147483648
                  Text = "-"
                  AutoEnabled = True
                  AutoEnable = True
                  Visible = True
               End
               Begin MenuItem UntitledItem3
                  SpecialMenu = 0
                  Index = -2147483648
                  Text = "Untitled"
                  AutoEnabled = True
                  AutoEnable = True
                  Visible = True
               End
            End
         End
         Begin MenuItem PrefsPolFin
            SpecialMenu = 0
            Index = -2147483648
            Text = "Finesse"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
      End
   End
   Begin MenuItem NotesMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Notes"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem NotesOpen
         SpecialMenu = 0
         Index = -2147483648
         Text = "Ouvrir"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem HelpMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Aide"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem HelpView
         SpecialMenu = 0
         Index = -2147483648
         Text = "Aide"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpUG
         SpecialMenu = 0
         Index = -2147483648
         Text = "Guide Utilisateur"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpVisit
         SpecialMenu = 0
         Index = -2147483648
         Text = "CREM"
         Style = 4
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem HelpAbout
         SpecialMenu = 0
         Index = -2147483648
         Text = "A propos"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem UntitledItem
      SpecialMenu = 0
      Index = -2147483648
      Text = "Untitled"
      AutoEnabled = False
      AutoEnable = False
      Visible = False
   End
End
#tag EndMenu
