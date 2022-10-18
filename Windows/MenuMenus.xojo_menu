#tag Menu
Begin Menu MenuMenus
   Begin DesktopMenuItem EditMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "&Edit"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin DesktopMenuItem EditRedo
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
      Begin DesktopMenuItem EditSelection
         SpecialMenu = 0
         Index = -2147483648
         Text = "Select"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem EditUndo
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
      Begin DesktopMenuItem EditSelectall
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
      Begin DesktopMenuItem EditReselect
         SpecialMenu = 0
         Index = -2147483648
         Text = "Reselect"
         Style = 2
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem EditLink
         SpecialMenu = 0
         Index = -2147483648
         Text = "Lier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem EditUnlink
         SpecialMenu = 0
         Index = -2147483648
         Text = "Délier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem EditCopy
         SpecialMenu = 0
         Index = -2147483648
         Text = "Copier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem EditPaste
         SpecialMenu = 0
         Index = -2147483648
         Text = "Coller"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem EditDelete
         SpecialMenu = 0
         Index = -2147483648
         Text = "Supprimer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin DesktopMenuItem ToolsMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Outils"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin DesktopMenuItem ToolsLabel
         SpecialMenu = 0
         Index = -2147483648
         Text = "Label"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem ToolsColorTransparent
         SpecialMenu = 0
         Index = -2147483648
         Text = "Transparence"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem ToolsOpq
            SpecialMenu = 0
            Index = -2147483648
            Text = "Opaque"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem ToolsSTsp
            SpecialMenu = 0
            Index = -2147483648
            Text = "SemiTsp"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem ToolsTsp
            SpecialMenu = 0
            Index = -2147483648
            Text = "Tsp"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem ToolsThickness
         SpecialMenu = 0
         Index = -2147483648
         Text = "Epaisseur trait"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem ToolsThick1
            SpecialMenu = 0
            Index = -2147483648
            Text = "1"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem ToolsThick2
            SpecialMenu = 0
            Index = -2147483648
            Text = "2"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem ToolsRigid
         SpecialMenu = 0
         Index = -2147483648
         Text = "Rigidifier/Dérigidifier"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem ToolsHide
         SpecialMenu = 0
         Index = -2147483648
         Text = "Cacher"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem ToolsAVPlan
         SpecialMenu = 0
         Index = -2147483648
         Text = "Avant-Plan"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem ToolsARPlan
         SpecialMenu = 0
         Index = -2147483648
         Text = "Arrière-Plan"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem ToolsGrid
         SpecialMenu = 0
         Index = -2147483648
         Text = "Grille"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem ToolsHisto
         SpecialMenu = 0
         Index = -2147483648
         Text = "Historique"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin DesktopMenuItem OperaMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Opérations"
      AutoEnabled = True
      AutoEnable = True
      Visible = False
      Begin DesktopMenuItem OperaDivide
         SpecialMenu = 0
         Index = -2147483648
         Text = "Diviser"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem OperaCut
         SpecialMenu = 0
         Index = -2147483648
         Text = "Decouper"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem OperaMerge
         SpecialMenu = 0
         Index = -2147483648
         Text = "Fusionner"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem OperaClone
         SpecialMenu = 0
         Index = -2147483648
         Text = "Dupliquer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem OperaProl
         SpecialMenu = 0
         Index = -2147483648
         Text = "Prolonger"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem OperaCreateCenter
         SpecialMenu = 0
         Index = -2147483648
         Text = "Creer Centre"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem OperaIdentify
         SpecialMenu = 0
         Index = -2147483648
         Text = "Identify"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem UntitledMenu0
         SpecialMenu = 0
         Index = -2147483648
         Text = ""
         AutoEnabled = False
         AutoEnable = False
         Visible = False
      End
   End
   Begin DesktopMenuItem TransfosMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Transformations"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin DesktopMenuItem TransfosDefine
         SpecialMenu = 0
         Index = -2147483648
         Text = "Définir"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem DefinirTranslation
            SpecialMenu = 0
            Index = -2147483648
            Text = "Translation"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirRotation
            SpecialMenu = 0
            Index = -2147483648
            Text = "Rotation"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirDemiTour
            SpecialMenu = 0
            Index = -2147483648
            Text = "Demi-tour"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirQuartG
            SpecialMenu = 0
            Index = -2147483648
            Text = "Quart de tour à gauche"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirQuartD
            SpecialMenu = 0
            Index = -2147483648
            Text = "Quart de tour à droite"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirDeplacement
            SpecialMenu = 0
            Index = -2147483648
            Text = "Déplacement"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirSymetrieaxiale
            SpecialMenu = 0
            Index = -2147483648
            Text = "Symétrie axiale"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirHomothetie
            SpecialMenu = 0
            Index = -2147483648
            Text = "Homothétie"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirSimilitude
            SpecialMenu = 0
            Index = -2147483648
            Text = "Similitude directe"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirEtirement
            SpecialMenu = 0
            Index = -2147483648
            Text = "Etirement"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin DesktopMenuItem DefinirCisaillement
            SpecialMenu = 0
            Index = -2147483648
            Text = "Cisaillement"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
      End
      Begin DesktopMenuItem TransfosAppliquer
         SpecialMenu = 0
         Index = -2147483648
         Text = "Appliquer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem TransfosFixedPoints
         SpecialMenu = 0
         Index = -2147483648
         Text = "Points fixes"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem TransfosHide
         SpecialMenu = 0
         Index = -2147483648
         Text = "HideTsf"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem InvCurve
         SpecialMenu = 0
         Index = -2147483648
         Text = "CourbeInvariante"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin DesktopMenuItem MacrosMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Macros"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin DesktopMenuItem MacrosLoad
         SpecialMenu = 0
         Index = -2147483648
         Text = "Charger"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem MacrosCreate
         SpecialMenu = 0
         Index = -2147483648
         Text = "Creer"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem MacrosFinaux
         SpecialMenu = 0
         Index = -2147483648
         Text = "Choix final"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem MacrosSave
         SpecialMenu = 0
         Index = -2147483648
         Text = "Sauvegarder"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem MacrosQuit
         SpecialMenu = 0
         Index = -2147483648
         Text = "Abandonner"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem MacSeparator
         SpecialMenu = 0
         Index = -2147483648
         Text = "-"
         Style = 4
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem MacrosDescri
         SpecialMenu = 0
         Index = 0
         Text = "Afficher la description d'une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem MacrosDescri2
            SpecialMenu = 0
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem MacrosExecute
         SpecialMenu = 0
         Index = 0
         Text = "Exécuter une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem MacrosChoose
            SpecialMenu = 0
            Index = 0
            Text = "Sans_titre"
            Style = 4
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem MacrosClose
         SpecialMenu = 0
         Index = 0
         Text = "Fermer une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem MacrosClose2
            SpecialMenu = 0
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem MacrosErase
         SpecialMenu = 0
         Index = 0
         Text = "Supprimer une macro"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem MacrosErase2
            SpecialMenu = 0
            Index = 0
            Text = "Sans_titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem MacrosCopy
         SpecialMenu = 0
         Index = 0
         Text = "Copier une macro"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem MacrosCopy2
            SpecialMenu = 0
            Index = 0
            Text = "Sans Titre"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
   End
   Begin DesktopMenuItem PrefsMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Préférences"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin DesktopMenuItem Fonds
         SpecialMenu = 0
         Index = -2147483648
         Text = "Fonds d'écran"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem Install
            SpecialMenu = 0
            Index = -2147483648
            Text = "Installer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem FondEcranConfigurer
            SpecialMenu = 0
            Index = -2147483648
            Text = "Configurer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem UnInstall
            SpecialMenu = 0
            Index = -2147483648
            Text = "Retirer"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem PrefsStdForms
         SpecialMenu = 0
         Index = -2147483648
         Text = "StdForms"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsColor
         SpecialMenu = 0
         Index = -2147483648
         Text = "Couleurs par défaut"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem PrefsColorBorder
            SpecialMenu = 0
            Index = -2147483648
            Text = "Couleur du bord"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem PrefsColorFill
            SpecialMenu = 0
            Index = -2147483648
            Text = "Couleur du fond"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem PrefsColorStdFam
            SpecialMenu = 0
            Index = -2147483648
            Text = "Couleur des formes standard"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem PrefsMagDist
         SpecialMenu = 0
         Index = -2147483648
         Text = "Mag Dist"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsThickness
         SpecialMenu = 0
         Index = -2147483648
         Text = "Epaisseur des traits"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsTrace
         SpecialMenu = 0
         Index = -2147483648
         Text = "Trajectoires"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsAjust
         SpecialMenu = 0
         Index = -2147483648
         Text = "Ajustement automatique"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsPolyg
         SpecialMenu = 0
         Index = -2147483648
         Text = "Formes pointées"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsFleches
         SpecialMenu = 0
         Index = -2147483648
         Text = "Formes fléchées"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsBiface
         SpecialMenu = 0
         Index = -2147483648
         Text = "Formes bifaces"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem PrefsArea
         SpecialMenu = 0
         Index = -2147483648
         Text = "Aire"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem PrefsAreaArith
            SpecialMenu = 0
            Index = -2147483648
            Text = "Aire arithmétique"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem PrefsAreaAlg
            SpecialMenu = 0
            Index = -2147483648
            Text = "Aire algébrique"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem PrefsUL
         SpecialMenu = 0
         Index = -2147483648
         Text = "UL"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem PrefsULDef
            SpecialMenu = 0
            Index = -2147483648
            Text = "Defaut"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem PrefsULChoix
            SpecialMenu = 0
            Index = -2147483648
            Text = "Choisir"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem PrefsUA
         SpecialMenu = 0
         Index = -2147483648
         Text = "UA"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem PrefsUADef
            SpecialMenu = 0
            Index = -2147483648
            Text = "Defaut"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin DesktopMenuItem PrefsUAChoix
            SpecialMenu = 0
            Index = -2147483648
            Text = "Choisir"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin DesktopMenuItem PrefsPolice
         SpecialMenu = 0
         Index = 1
         Text = "Polices de caractères"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin DesktopMenuItem PrefsPolNom
            SpecialMenu = 0
            Index = -2147483648
            Text = "Nom"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
            Begin DesktopMenuItem UntitledItem0
               SpecialMenu = 0
               Index = -2147483648
               Text = "Untitled"
               AutoEnabled = True
               AutoEnable = True
               SubMenu = True
               Visible = True
               Begin DesktopMenuItem Untitled
                  SpecialMenu = 0
                  Index = -2147483648
                  Text = ""
                  AutoEnabled = False
                  AutoEnable = False
                  Visible = True
               End
            End
            Begin DesktopMenuItem UntitledItem1
               SpecialMenu = 0
               Index = -2147483648
               Text = "Untitled"
               AutoEnabled = True
               AutoEnable = True
               Visible = True
            End
         End
         Begin DesktopMenuItem PrefsPolItal
            SpecialMenu = 0
            Index = -2147483648
            Text = "Aspect"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
         End
         Begin DesktopMenuItem PrefsPolTai
            SpecialMenu = 0
            Index = -2147483648
            Text = "Taille"
            AutoEnabled = True
            AutoEnable = True
            SubMenu = True
            Visible = True
            Begin DesktopMenuItem UntitledItem2
               SpecialMenu = 0
               Index = -2147483648
               Text = "Untitled"
               AutoEnabled = True
               AutoEnable = True
               SubMenu = True
               Visible = True
               Begin DesktopMenuItem UntitledSeparator
                  SpecialMenu = 0
                  Index = -2147483648
                  Text = "-"
                  AutoEnabled = True
                  AutoEnable = True
                  Visible = True
               End
               Begin DesktopMenuItem UntitledItem3
                  SpecialMenu = 0
                  Index = -2147483648
                  Text = "Untitled"
                  AutoEnabled = True
                  AutoEnable = True
                  Visible = True
               End
            End
         End
         Begin DesktopMenuItem PrefsPolFin
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
   Begin DesktopMenuItem NotesMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Notes"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin DesktopMenuItem NotesOpen
         SpecialMenu = 0
         Index = -2147483648
         Text = "Ouvrir"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin DesktopMenuItem HelpMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Aide"
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin DesktopMenuItem HelpView
         SpecialMenu = 0
         Index = -2147483648
         Text = "Aide"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem HelpUG
         SpecialMenu = 0
         Index = -2147483648
         Text = "Guide Utilisateur"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem HelpVisit
         SpecialMenu = 0
         Index = -2147483648
         Text = "CREM"
         Style = 4
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin DesktopMenuItem HelpAbout
         SpecialMenu = 0
         Index = -2147483648
         Text = "A propos"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
End
#tag EndMenu
