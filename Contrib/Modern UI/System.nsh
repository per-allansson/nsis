;NSIS Modern User Interface version 1.66
;Macro System
;Written by Joost Verburg

;Copyright � 2002-2003 Joost Verburg

;Documentation: Readme.html
;License: License.txt
;Examples: Examples\Modern UI

!echo "NSIS Modern User Interface version 1.66 - � 2002-2003 Joost Verburg"

;--------------------------------
;DECLARES

!ifndef MUI_MANUALVERBOSE
  !verbose 3
!endif

!ifndef MUI_INCLUDED

!define MUI_INCLUDED

!include "WinMessages.nsh"

Var MUI_TEMP1
Var MUI_TEMP2

;--------------------------------
;INTERFACE

!macro MUI_INTERFACE
  
  Name "$(MUI_NAME)"
  
  !ifndef MUI_UI
    !define MUI_UI "${NSISDIR}\Contrib\UIs\modern.exe"
  !endif
  
  !ifndef MUI_UI_HEADERBITMAP
    !define MUI_UI_HEADERBITMAP "${NSISDIR}\Contrib\UIs\modern_headerbmp.exe"
  !endif

  !ifndef MUI_UI_HEADERBITMAP_RIGHT
    !define MUI_UI_HEADERBITMAP_RIGHT "${NSISDIR}\Contrib\UIs\modern_headerbmpr.exe"
  !endif
  
  !ifndef MUI_UI_SMALLDESCRIPTION
    !define MUI_UI_SMALLDESCRIPTION "${NSISDIR}\Contrib\UIs\modern_smalldesc.exe"
  !endif

  !ifndef MUI_UI_NODESCRIPTION
    !define MUI_UI_NODESCRIPTION "${NSISDIR}\Contrib\UIs\modern_nodesc.exe"
  !endif

  !ifndef MUI_ICON
    !define MUI_ICON "${NSISDIR}\Contrib\Icons\modern-install.ico"
  !endif

  !ifndef MUI_UNICON
    !define MUI_UNICON "${NSISDIR}\Contrib\Icons\modern-uninstall.ico"
  !endif

  !ifndef MUI_CHECKBITMAP
    !define MUI_CHECKBITMAP "${NSISDIR}\Contrib\Icons\modern.bmp"
  !endif
  
  !ifndef MUI_LICENSEBKCOLOR
    !define MUI_LICENSEBKCOLOR "/windows"
  !endif
  
  !ifndef MUI_INSTALLCOLORS
    !define MUI_INSTALLCOLORS "/windows"
  !endif

  !ifndef MUI_PROGRESSBAR
    !define MUI_PROGRESSBAR "smooth"
  !endif

  !ifndef MUI_BGCOLOR
    !define MUI_BGCOLOR "FFFFFF"
  !endif

  !ifndef MUI_SPECIALINI
    !define MUI_SPECIALINI "${NSISDIR}\Contrib\Modern UI\ioSpecial.ini"
  !endif
  
  !ifndef MUI_SPECIALBITMAP
    !define MUI_SPECIALBITMAP "${NSISDIR}\Contrib\Icons\modern-wizard.bmp"
  !endif

  XPStyle On
  
  ChangeUI all "${MUI_UI}"
  !ifdef MUI_HEADERBITMAP
    !ifndef MUI_HEADERBITMAP_RIGHT
      ChangeUI IDD_INST "${MUI_UI_HEADERBITMAP}"
    !else
      ChangeUI IDD_INST "${MUI_UI_HEADERBITMAP_RIGHT}"
    !endif
  !endif
  !ifdef MUI_COMPONENTSPAGE_SMALLDESC
    ChangeUI IDD_SELCOM "${MUI_UI_SMALLDESCRIPTION}"
  !else ifdef MUI_COMPONENTSPAGE_NODESC
     ChangeUI IDD_SELCOM "${MUI_UI_NODESCRIPTION}"
  !endif
  
  Icon "${MUI_ICON}"
  
  !ifdef MUI_UNINSTALLER
    UninstallIcon "${MUI_UNICON}"
  !endif
  
  CheckBitmap "${MUI_CHECKBITMAP}"
  LicenseBkColor "${MUI_LICENSEBKCOLOR}"
  InstallColors ${MUI_INSTALLCOLORS}
  InstProgressFlags ${MUI_PROGRESSBAR}
  
!macroend

!macro MUI_INNERDIALOG_TEXT CONTROL TEXT

  !verbose push
  !verbose 3

  FindWindow $MUI_TEMP1 "#32770" "" $HWNDPARENT
  GetDlgItem $MUI_TEMP1 $MUI_TEMP1 ${CONTROL}
  SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:${TEXT}"

  !verbose pop

!macroend

!macro MUI_HEADER_TEXT TEXT SUBTEXT

  !verbose push
  !verbose 3

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1037
  SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:${TEXT}"
  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1038
  SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:${SUBTEXT}"

  !verbose pop

!macroend

!macro MUI_HEADER_TEXT_PAGE TEXT SUBTEXT

  !ifdef MUI_PAGE_HEADER_TEXT
    !ifndef MUI_PAGE_HEADER_SUBTEXT
      !insertmacro MUI_HEADER_TEXT "${MUI_PAGE_HEADER_TEXT}" "${SUBTEXT}"
    !else
      !insertmacro MUI_HEADER_TEXT "${MUI_PAGE_HEADER_TEXT}" "${MUI_PAGE_HEADER_SUBTEXT}"
      !undef MUI_PAGE_HEADER_SUBTEXT
    !endif
    !undef MUI_PAGE_HEADER_TEXT
  !else
    !insertmacro MUI_HEADER_TEXT "${TEXT}" "${SUBTEXT}"
  !endif

!macroend

!macro MUI_DESCRIPTION_BEGIN

  FindWindow $MUI_TEMP1 "#32770" "" $HWNDPARENT
  GetDlgItem $MUI_TEMP1 $MUI_TEMP1 1043

  StrCmp $0 -1 0 mui.description_begin_done
    SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:"
    EnableWindow $MUI_TEMP1 0
    SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:$(MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO)"
    Goto mui.description_done
  mui.description_begin_done:

!macroend

!macro MUI_DESCRIPTION_TEXT VAR TEXT

  !verbose push
  !verbose 3

  StrCmp $0 ${VAR} 0 mui.description_${VAR}_done
    SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:"
    EnableWindow $MUI_TEMP1 1
    SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:${TEXT}"
    Goto mui.description_done
  mui.description_${VAR}_done:

  !verbose pop

!macroend

!macro MUI_DESCRIPTION_END

  !verbose push
  !verbose 3

  mui.description_done:

  !verbose pop

!macroend

!macro MUI_FINISHHEADER

  IfAbort mui.finishheader_abort
  
    !insertmacro MUI_HEADER_TEXT $(MUI_TEXT_FINISH_TITLE) $(MUI_TEXT_FINISH_SUBTITLE)
  
  Goto mui.finishheader_done
  
  mui.finishheader_abort:
  !insertmacro MUI_HEADER_TEXT $(MUI_TEXT_ABORT_TITLE) $(MUI_TEXT_ABORT_SUBTITLE)
  
  mui.finishheader_done:
  
!macroend

!macro MUI_UNFINISHHEADER
  
  IfAbort mui.finishheader_abort
  
  !insertmacro MUI_HEADER_TEXT $(MUI_UNTEXT_FINISH_TITLE) $(MUI_UNTEXT_FINISH_SUBTITLE)
  Goto mui.finishheader_done

  mui.finishheader_abort:
  !insertmacro MUI_HEADER_TEXT $(MUI_UNTEXT_ABORT_TITLE) $(MUI_UNTEXT_ABORT_SUBTITLE)
  
  mui.finishheader_done:

!macroend

!macro MUI_ABORTWARNING

  MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(MUI_TEXT_ABORTWARNING)" IDYES quit
    Abort
    quit:

!macroend

!macro MUI_GUIINIT
  
  !insertmacro MUI_WELCOMEFINISHPAGE_INIT
  !insertmacro MUI_HEADERBITMAP_INIT

  !insertmacro MUI_GUIINIT_BASIC
  
!macroend

!macro MUI_UNGUIINIT

  !insertmacro MUI_HEADERBITMAP_INIT

  !insertmacro MUI_UNGUIINIT_BASIC
  
!macroend

!macro MUI_GUIINIT_BASIC

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1037
  CreateFont $MUI_TEMP2 "$(MUI_FONT_HEADER)" "$(MUI_FONTSIZE_HEADER)" "$(MUI_FONTSTYLE_HEADER)"
  SendMessage $MUI_TEMP1 ${WM_SETFONT} $MUI_TEMP2 0
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1038
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1034
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1039
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
  
  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1028
  SetCtlColors $MUI_TEMP1 "branding"
  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1256
  SetCtlColors $MUI_TEMP1 "branding"
  SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:$(^Branding) "

!macroend

!macro MUI_UNGUIINIT_BASIC

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1037
  CreateFont $MUI_TEMP2 "$(MUI_FONT_HEADER)" "$(MUI_FONTSIZE_HEADER)" "$(MUI_FONTSTYLE_HEADER)"
  SendMessage $MUI_TEMP1 ${WM_SETFONT} $MUI_TEMP2 0
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1038
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1034
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"

  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1039
  SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
  
  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1028
  SetCtlColors $MUI_TEMP1 "" "transparent"
  GetDlgItem $MUI_TEMP1 $HWNDPARENT 1256
  SetCtlColors $MUI_TEMP1 "branding"
  SendMessage $MUI_TEMP1 ${WM_SETTEXT} 0 "STR:$(^Branding) "

!macroend

!macro MUI_WELCOMEFINISHPAGE_INIT

  !ifdef MUI_WELCOMEPAGE | MUI_FINISHPAGE

    !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "${MUI_SPECIALINI}" "ioSpecial.ini"
    File "/oname=$PLUGINSDIR\modern-wizard.bmp" "${MUI_SPECIALBITMAP}"
    
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 1" "Text" "$PLUGINSDIR\modern-wizard.bmp"
    
    !ifdef MUI_SPECIALBITMAP_NOSTRETCH
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 1" "Flags" ""
    !endif
    
  !endif

!macroend

!macro MUI_HEADERBITMAP_INIT

  !ifdef MUI_HEADERBITMAP
    InitPluginsDir
    File "/oname=$PLUGINSDIR\modern-header.bmp" "${MUI_HEADERBITMAP}"
    !ifndef MUI_HEADERBITMAP_NOSTRETCH
      SetBrandingImage /IMGID=1046 /RESIZETOFIT "$PLUGINSDIR\modern-header.bmp"
    !else
      SetBrandingImage /IMGID=1046 "$PLUGINSDIR\modern-header.bmp"
    !endif
  !endif

!macroend

!macro MUI_LANGUAGE LANGUAGE

  !verbose push
  !verbose 3
  
  !include "${NSISDIR}\Contrib\Modern UI\Language files\${LANGUAGE}.nsh"
  
  !verbose pop
  
!macroend


!macro MUI_STARTMENU_GETFOLDER VAR

  !ifdef MUI_STARTMENUPAGE_REGISTRY_ROOT & MUI_STARTMENUPAGE_REGISTRY_KEY & MUI_STARTMENUPAGE_REGISTRY_VALUENAME

    ReadRegStr $MUI_TEMP1 "${MUI_STARTMENUPAGE_REGISTRY_ROOT}" "${MUI_STARTMENUPAGE_REGISTRY_KEY}" "${MUI_STARTMENUPAGE_REGISTRY_VALUENAME}"
      StrCmp $MUI_TEMP1 "" +3
        StrCpy "${VAR}" $MUI_TEMP1
        Goto +2
      
        StrCpy "${VAR}" "${MUI_STARTMENUPAGE_DEFAULTFOLDER}"
 
   !else
   
     StrCpy "${VAR}" "${MUI_STARTMENUPAGE_DEFAULTFOLDER}"
  
   !endif
  
!macroend

!macro MUI_STARTMENU_GETFOLDER_IFEMPTY VAR
  
  StrCmp ${VAR} "" 0 mui.startmenu_writebegin_notempty

    !insertmacro MUI_STARTMENU_GETFOLDER ${VAR}
    
  mui.startmenu_writebegin_notempty:
  
!macroend

!macro MUI_STARTMENU_WRITE_BEGIN

  !verbose push
  !verbose 3
  
  StrCpy $MUI_TEMP1 "${MUI_STARTMENUPAGE_VARIABLE}" 1
  StrCmp $MUI_TEMP1 ">" mui.startmenu_write_done
    
  !insertmacro MUI_STARTMENU_GETFOLDER_IFEMPTY "${MUI_STARTMENUPAGE_VARIABLE}"
  
  !verbose pop

!macroend

!macro MUI_STARTMENU_WRITE_END

  !verbose push
  !verbose 3
  
  !ifdef MUI_STARTMENUPAGE_REGISTRY_ROOT & MUI_STARTMENUPAGE_REGISTRY_KEY & MUI_STARTMENUPAGE_REGISTRY_VALUENAME
    WriteRegStr "${MUI_STARTMENUPAGE_REGISTRY_ROOT}" "${MUI_STARTMENUPAGE_REGISTRY_KEY}" "${MUI_STARTMENUPAGE_REGISTRY_VALUENAME}" "${MUI_STARTMENUPAGE_VARIABLE}"
  !endif

  mui.startmenu_write_done:
  
  !verbose pop

!macroend

!macro MUI_LANGDLL_DISPLAY

  !verbose push
  !verbose 3

  !ifndef MUI_TEXT_LANGDLL_WINDOWTITLE
    !define MUI_TEXT_LANGDLL_WINDOWTITLE "Installer Language"
  !endif

  !ifndef MUI_TEXT_LANGDLL_INFO
    !define MUI_TEXT_LANGDLL_INFO "Please select a language."
  !endif
  
  !ifdef MUI_LANGDLL_REGISTRY_ROOT & MUI_LANGDLL_REGISTRY_KEY & MUI_LANGDLL_REGISTRY_VALUENAME
    
    ReadRegStr $MUI_TEMP1 "${MUI_LANGDLL_REGISTRY_ROOT}" "${MUI_LANGDLL_REGISTRY_KEY}" "${MUI_LANGDLL_REGISTRY_VALUENAME}"
    StrCmp $MUI_TEMP1 "" mui.langdll_show
      StrCpy $LANGUAGE $MUI_TEMP1
      !ifndef MUI_LANGDLL_ALWAYSSHOW
        Goto mui.langdll_done
      !endif
    mui.langdll_show:
  
  !endif
  
  LangDLL::LangDialog "${MUI_TEXT_LANGDLL_WINDOWTITLE}" "${MUI_TEXT_LANGDLL_INFO}" A ${MUI_LANGDLL_PUSHLIST} ""

  Pop $LANGUAGE
  StrCmp $LANGUAGE "cancel" 0 +2
    Abort
  
  !ifndef MUI_LANGDLL_ALWAYSSHOW
    !ifdef MUI_LANGDLL_REGISTRY_ROOT & MUI_LANGDLL_REGISTRY_KEY & MUI_LANGDLL_REGISTRY_VALUENAME
      mui.langdll_done:
    !endif
  !endif
    
  !verbose pop
    
!macroend

!macro MUI_LANGDLL_SAVELANGUAGE

  !ifdef MUI_LANGDLL_REGISTRY_ROOT & MUI_LANGDLL_REGISTRY_KEY & MUI_LANGDLL_REGISTRY_VALUENAME
    WriteRegStr "${MUI_LANGDLL_REGISTRY_ROOT}" "${MUI_LANGDLL_REGISTRY_KEY}" "${MUI_LANGDLL_REGISTRY_VALUENAME}" $LANGUAGE
  !endif
  
!macroend

!macro MUI_UNGETLANGUAGE

  !verbose pop

  !ifdef MUI_LANGDLL_REGISTRY_ROOT & MUI_LANGDLL_REGISTRY_KEY & MUI_LANGDLL_REGISTRY_VALUENAME
  
    ReadRegStr $MUI_TEMP1 "${MUI_LANGDLL_REGISTRY_ROOT}" "${MUI_LANGDLL_REGISTRY_KEY}" "${MUI_LANGDLL_REGISTRY_VALUENAME}"
    StrCmp $MUI_TEMP1 "" 0 mui.ungetlanguage_setlang
  
  !endif
    
  !insertmacro MUI_LANGDLL_DISPLAY
      
  !ifdef MUI_LANGDLL_REGISTRY_ROOT & MUI_LANGDLL_REGISTRY_KEY & MUI_LANGDLL_REGISTRY_VALUENAME
  
    Goto mui.ungetlanguage_done
   
    mui.ungetlanguage_setlang:
      StrCpy $LANGUAGE $MUI_TEMP1
        
    mui.ungetlanguage_done:

  !endif
  
  !verbose pop

!macroend

;--------------------------------
;PAGE COMMANDS

!macro MUI_UNIQUEID

  !ifdef MUI_UNIQUEID
    !undef MUI_UNIQUEID
  !endif
  
  !define MUI_UNIQUEID ${__LINE__}

!macroend

!macro MUI_PAGE_WELCOME

  !verbose push
  !verbose 3

  !ifndef MUI_WELCOMEPAGE
    !define MUI_WELCOMEPAGE
  !endif
  
  !ifndef MUI_BGCOLOR
    !define MUI_BGCOLOR "FFFFFF"
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx custom
  
    PageCallbacks mui.WelcomePre_${MUI_UNIQUEID} mui.WelcomeLeave_${MUI_UNIQUEID}
    
  PageExEnd
  
  !ifndef MUI_HWND_DEFINED
    Var MUI_HWND
    !define MUI_HWND_DEFINED
  !endif
  
  !insertmacro MUI_FUNCTION_WELCOMEPAGE mui.WelcomePre_${MUI_UNIQUEID} mui.WelcomeLeave_${MUI_UNIQUEID}

  !verbose pop
  
!macroend

!macro MUI_PAGE_LICENSE LICENSEDATA

  !verbose push
  !verbose 3

  !ifndef MUI_LICENSEPAGE
    !define MUI_LICENSEPAGE
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx license
  
    PageCallbacks mui.LicensePre_${MUI_UNIQUEID} mui.LicenseShow_${MUI_UNIQUEID} mui.LicenseLeave_${MUI_UNIQUEID}
    
    Caption " "
    
    LicenseData "${LICENSEDATA}"
    
    !ifdef MUI_LICENSEPAGE_TEXT
      LicenseText ${MUI_LICENSEPAGE_TEXT}
      !undef MUI_LICENSEPAGE_TEXT
    !endif
    
    !ifdef MUI_LICENSEPAGE_CHECKBOX
      !ifndef MUI_LICENSEPAGE_CHECKBOX_USED
        !define MUI_LICENSEPAGE_CHECKBOX_USED
      !endif
      LicenseForceSelection checkbox
      !undef MUI_LICENSEPAGE_CHECKBOX
    !else ifdef MUI_LICENSEPAGE_RADIOBUTTONS
      !ifndef MUI_LICENSEPAGE_RADIOBUTTONS_USED
        !define MUI_LICENSEPAGE_RADIOBUTTONS_USED
      !endif
      LicenseForceSelection radiobuttons
      !undef MUI_LICENSEPAGE_RADIOBUTTONS
    !endif
    
  PageExEnd
  
  !insertmacro MUI_FUNCTION_LICENSEPAGE mui.LicensePre_${MUI_UNIQUEID} mui.LicenseShow_${MUI_UNIQUEID} mui.LicenseLeave_${MUI_UNIQUEID}
  
  !verbose pop
  
!macroend

!macro MUI_PAGE_COMPONENTS

  !verbose push
  !verbose 3

  !ifndef MUI_COMPONENTSPAGE
    !define MUI_COMPONENTSPAGE
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx components
  
    PageCallbacks mui.ComponentsPre_${MUI_UNIQUEID} mui.ComponentsShow_${MUI_UNIQUEID} mui.ComponentsLeave_${MUI_UNIQUEID}
    
    Caption " "
    
    !ifdef MUI_COMPONENTSPAGE_TEXT
      LicenseText ${MUI_COMPONENTSPAGE_TEXT}
      !undef MUI_COMPONENTSPAGE_TEXT
    !endif
  
  PageExEnd
  
  !insertmacro MUI_FUNCTION_COMPONENTSPAGE mui.ComponentsPre_${MUI_UNIQUEID} mui.ComponentsShow_${MUI_UNIQUEID} mui.ComponentsLeave_${MUI_UNIQUEID}
  
  !verbose pop
  
!macroend

!macro MUI_PAGE_DIRECTORY

  !verbose push
  !verbose 3

  !ifndef MUI_DIRECTORYPAGE
    !define MUI_DIRECTORYPAGE
  !endif
    
  !insertmacro MUI_UNIQUEID
    
  PageEx directory
  
    PageCallbacks mui.DirectoryPre_${MUI_UNIQUEID} mui.DirectoryShow_${MUI_UNIQUEID} mui.DirectoryLeave_${MUI_UNIQUEID}
    
    Caption " "
    
    !ifdef MUI_DIRECTORYPAGE_TEXT
      LicenseText ${MUI_DIRECTORYPAGE_TEXT}
      !undef MUI_DIRECTORYPAGE_TEXT
    !endif
    
    !ifdef MUI_DIRECTORYPAGE_VARIABLE
      LicenseText "${MUI_DIRECTORYPAGE_VARIABLE}"
      !undef "MUI_DIRECTORYPAGE_VARAIBLE"
    !endif
    
  PageExEnd
  
  !insertmacro MUI_FUNCTION_DIRECTORYPAGE mui.DirectoryPre_${MUI_UNIQUEID} mui.DirectoryShow_${MUI_UNIQUEID} mui.DirectoryLeave_${MUI_UNIQUEID}
  
  !verbose pop
  
!macroend

!macro MUI_PAGE_STARTMENU

  !verbose push
  !verbose 3

  !ifndef MUI_STARTMENUPAGE
    !define MUI_STARTMENUPAGE
  !endif
  
  !ifndef MUI_STARTMENUPAGE_VARIABLE
    Var MUI_STARTMENU_FOLDER
    !define MUI_STARTMENUPAGE_VARIABLE "$MUI_STARTMENU_FOLDER"
  !endif
  
  !ifndef MUI_STARTMENUPAGE_DEFAULTFOLDER
    !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${MUI_PRODUCT}"
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx custom
  
    PageCallbacks mui.StartmenuPre_${MUI_UNIQUEID} mui.StartmenuLeave_${MUI_UNIQUEID}
    
    Caption " "
    
  PageExEnd
  
  !insertmacro MUI_FUNCTION_STARTMENUPAGE mui.StartmenuPre_${MUI_UNIQUEID} mui.StartmenuLeave_${MUI_UNIQUEID}
  
  !verbose pop
  
!macroend

!macro MUI_PAGE_INSTFILES

  !verbose push
  !verbose 3
  
  !ifndef MUI_INSTFILESPAGE
    !define MUI_INSTFILESPAGE
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx instfiles
  
    PageCallbacks mui.InstFilesPre_${MUI_UNIQUEID} mui.InstFilesShow_${MUI_UNIQUEID} mui.InstFilesLeave_${MUI_UNIQUEID}
    
    Caption " "
    
  PageExEnd
  
  !insertmacro MUI_FUNCTION_INSTFILESPAGE mui.InstFilesPre_${MUI_UNIQUEID} mui.InstFilesShow_${MUI_UNIQUEID} mui.InstFilesLeave_${MUI_UNIQUEID}
   
  !verbose pop
   
!macroend

!macro MUI_PAGE_FINISH

  !verbose push
  !verbose 3
  
  !ifndef MUI_FINISHPAGE
    !define MUI_FINISHPAGE
  !endif
  
  !ifdef MUI_FINISHPAGE
    !ifndef MUI_FINISHPAGE_NOAUTOCLOSE
      AutoCloseWindow true
    !endif
    !ifdef MUI_FINISHPAGE_LINK
      !ifndef MUI_FINISHPAGE_LINK_COLOR
        !define MUI_FINISHPAGE_LINK_COLOR "0x800000"
      !endif
    !endif
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx custom
  
    PageCallbacks mui.FinishPre_${MUI_UNIQUEID} mui.FinishLeave_${MUI_UNIQUEID}
    
    Caption " "
    
  PageExEnd
  
  !ifndef MUI_HWND_DEFINED
    Var MUI_HWND
    !define MUI_HWND_DEFINED
  !endif
  
  !insertmacro MUI_FUNCTION_FINISHPAGE mui.FinishPre_${MUI_UNIQUEID} mui.FinishLeave_${MUI_UNIQUEID}
  
  !ifdef MUI_FINISHPAGE_RUN
    !undef MUI_FINISHPAGE_RUN
  !endif
    !ifdef MUI_FINISHPAGE_RUN_PARAMETERS
      !undef MUI_FINISHPAGE_RUN_PARAMETERS
    !endif
    !ifdef MUI_FINISHPAGE_RUN_NOTCHECKED
      !undef MUI_FINISHPAGE_RUN_NOTCHECKED
    !endif
    !ifdef MUI_FINISHPAGE_RUN_FUNCTION
      !undef MUI_FINISHPAGE_RUN_FUNCTION
    !endif
  !ifdef MUI_FINISHPAGE_SHOWREADME
    !undef MUI_FINISHPAGE_SHOWREADME
  !endif
    !ifdef MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
      !undef MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
    !endif
    !ifdef MUI_FINISHPAGE_SHOWREADME_FUNCTION
      !undef MUI_FINISHPAGE_SHOWREADME_FUNCTION
    !endif
  !ifdef MUI_FINISHPAGE_LINK
    !undef MUI_FINISHPAGE_LINK
  !endif
    !ifdef MUI_FINISHPAGE_LINK_LOCATION
      !undef MUI_FINISHPAGE_LINK_LOCATION
    !endif
  !ifdef MUI_FINISHPAGE_NOAUTOCLOSE
    !undef MUI_FINISHPAGE_NOAUTOCLOSE
  !endif
  !ifdef MUI_FINISHPAGE_NOREBOOTSUPPORT
    !undef MUI_FINISHPAGE_NOREBOOTSUPPORT
  !endif

  !verbose pop
  
!macroend

!macro MUI_UNPAGE_CONFIRM

  !verbose push
  !verbose 3

  !ifndef MUI_UNINSTALLER
    !define MUI_UNINSTALLER
  !endif

  !ifndef MUI_UNCONFIRMPAGE
    !define MUI_UNCONFIRMPAGE
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx un.uninstConfirm
  
    PageCallbacks un.mui.ConfirmPre_${MUI_UNIQUEID} un.mui.ConfirmShow_${MUI_UNIQUEID} un.mui.ConfirmLeave_${MUI_UNIQUEID}
    
    Caption " "
    
  PageExEnd
  
  !insertmacro MUI_UNFUNCTION_CONFIRMPAGE un.mui.ConfirmPre_${MUI_UNIQUEID} un.mui.ConfirmShow_${MUI_UNIQUEID} un.mui.ConfirmLeave_${MUI_UNIQUEID}
  
  !verbose pop
   
!macroend

!macro MUI_UNPAGE_COMPONENTS

  !verbose push
  !verbose 3

  !ifndef MUI_UNINSTALLER
    !define MUI_UNINSTALLER
  !endif

  !ifndef MUI_UNCOMPONENTSPAGE
    !define MUI_UNCOMPONENTSPAGE
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx un.components
  
    PageCallbacks un.mui.ComponentsPre_${MUI_UNIQUEID} un.mui.ComponentsShow_${MUI_UNIQUEID} un.mui.ComponentsLeave_${MUI_UNIQUEID}
    
    Caption " "
    
  PageExEnd
  
  !insertmacro MUI_UNFUNCTION_COMPONENTSPAGE un.mui.ComponentsPre_${MUI_UNIQUEID} un.mui.ComponentsShow_${MUI_UNIQUEID} un.mui.ComponentsLeave_${MUI_UNIQUEID}
  
  !verbose pop
   
!macroend

!macro MUI_UNPAGE_INSTFILES

  !verbose push
  !verbose 3

  !ifndef MUI_UNINSTALLER
    !define MUI_UNINSTALLER
  !endif
  
  !ifndef MUI_UNINSTFILESPAGE
    !define MUI_UNINSTFILESPAGE
  !endif
  
  !insertmacro MUI_UNIQUEID
  
  PageEx un.instfiles
  
    PageCallbacks un.mui.InstFilesPre_${MUI_UNIQUEID} un.mui.InstFilesShow_${MUI_UNIQUEID} un.mui.InstFilesLeave_${MUI_UNIQUEID}
    
    Caption " "
    
  PageExEnd
  
  !insertmacro MUI_UNFUNCTION_INSTFILESPAGE un.mui.InstFilesPre_${MUI_UNIQUEID} un.mui.InstFilesShow_${MUI_UNIQUEID} un.mui.InstFilesLeave_${MUI_UNIQUEID}
   
  !verbose pop
   
!macroend

;--------------------------------
;INSTALL OPTIONS

!macro MUI_INSTALLOPTIONS_EXTRACT FILE

  !verbose push
  !verbose 3

  InitPluginsDir

  File "/oname=$PLUGINSDIR\${FILE}" "${FILE}"
  
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${FILE}" "Settings" "RTL" "$(^RTL)"

  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_EXTRACT_AS FILE FILENAME

  !verbose push
  !verbose 3

  InitPluginsDir

  File "/oname=$PLUGINSDIR\${FILENAME}" "${FILE}"
  
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${FILENAME}" "Settings" "RTL" "$(^RTL)"
  
  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_DISPLAY FILE

  !verbose push
  !verbose 3
  
  InstallOptions::dialog "$PLUGINSDIR\${FILE}"
  Pop $MUI_TEMP1

  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_DISPLAY_RETURN FILE

  !verbose push
  !verbose 3
  
  InstallOptions::dialog "$PLUGINSDIR\${FILE}"

  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_INITDIALOG FILE

  !verbose push
  !verbose 3
  
  InstallOptions::initDialog /NOUNLOAD "$PLUGINSDIR\${FILE}"

  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_SHOW

  !verbose push
  !verbose 3

  InstallOptions::show
  Pop $MUI_TEMP1

  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_SHOW_RETURN

  !verbose push
  !verbose 3
  
  InstallOptions::show

  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_READ VAR FILE SECTION KEY

  !verbose push
  !verbose 3

  ReadIniStr ${VAR} "$PLUGINSDIR\${FILE}" "${SECTION}" "${KEY}"

  !verbose pop

!macroend

!macro MUI_INSTALLOPTIONS_WRITE FILE SECTION KEY VALUE

  !verbose push
  !verbose 3

  WriteIniStr "$PLUGINSDIR\${FILE}" "${SECTION}" "${KEY}" "${VALUE}"

  !verbose pop

!macroend

;--------------------------------
;FUNCTIONS

!macro MUI_FUNCTION_CUSTOM TYPE

  !ifdef MUI_PAGE_CUSTOMFUNCTION_${TYPE}
    Call "${MUI_PAGE_CUSTOMFUNCTION_${TYPE}}"
    !undef MUI_PAGE_CUSTOMFUNCTION_${TYPE}
  !endif
  
!macroend

!macro MUI_FUNCTION_GUIINIT

  Function .onGUIInit
     
    !insertmacro MUI_GUIINIT
    
    !ifdef MUI_CUSTOMFUNCTION_GUIINIT
      Call "${MUI_CUSTOMFUNCTION_GUIINIT}"
    !endif

  FunctionEnd

!macroend

!macro MUI_FUNCTION_WELCOMEPAGE PRE LEAVE

  Function "${PRE}"
  
    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1028
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1256
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1035
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1037
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1038
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1045
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    !ifndef MUI_WELCOMEPAGE_TITLE
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 2" "Text" "$(MUI_TEXT_WELCOME_INFO_TITLE)"
    !else
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 2" "Text" "${MUI_WELCOMEPAGE_TITLE}"
      !undef MUI_WELCOMEPAGE_TITLE
    !endif
    
    !ifndef MUI_WELCOMEPAGE_TEXT
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Text" "$(MUI_TEXT_WELCOME_INFO_TEXT)"
    !else
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Text" "${MUI_WELCOMEPAGE_TEXT}"
      !undef MUI_WELCOMEPAGE_TEXT
    !endif

    !insertmacro MUI_FUNCTION_CUSTOM PRE
    
    !insertmacro MUI_INSTALLOPTIONS_INITDIALOG "ioSpecial.ini"
    Pop $MUI_HWND
    SetCtlColors $MUI_HWND "" "${MUI_BGCOLOR}"
      
    GetDlgItem $MUI_TEMP1 $MUI_HWND 1201
    SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
    CreateFont $MUI_TEMP2 "$(MUI_FONT_TITLE)" "$(MUI_FONTSIZE_TITLE)" "$(MUI_FONTSTYLE_TITLE)"
    SendMessage $MUI_TEMP1 ${WM_SETFONT} $MUI_TEMP2 0
        
    GetDlgItem $MUI_TEMP1 $MUI_HWND 1202
    SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
        
    GetDlgItem $MUI_TEMP1 $MUI_HWND 1200
    SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"

    !insertmacro MUI_FUNCTION_CUSTOM SHOW
  
    !insertmacro MUI_INSTALLOPTIONS_SHOW
     
    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1028
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1256
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1035
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1037
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1038
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1045
    ShowWindow $MUI_TEMP1 ${SW_HIDE}
    
  FunctionEnd
  
  Function "${LEAVE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
  
  FunctionEnd
  
!macroend

!macro MUI_FUNCTION_LICENSEPAGE PRE SHOW LEAVE

  Function "${PRE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM PRE
    !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_TEXT_LICENSE_TITLE) $(MUI_TEXT_LICENSE_SUBTITLE)
    
  FunctionEnd

  Function "${SHOW}"
  
    !ifndef MUI_LICENSEPAGE_TEXT_TOP
      !insertmacro MUI_INNERDIALOG_TEXT 1040 $(MUI_INNERTEXT_LICENSE_TOP)
    !else
      !insertmacro MUI_INNERDIALOG_TEXT 1040 "${MUI_LICENSEPAGE_TEXT_TOP}"
      !undef MUI_LICENSEPAGE_TEXT_TOP
    !endif
    !insertmacro MUI_FUNCTION_CUSTOM SHOW
    
  FunctionEnd
  
  Function "${LEAVE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
    
  FunctionEnd

!macroend

!macro MUI_FUNCTION_COMPONENTSPAGE PRE SHOW LEAVE

  Function "${PRE}"
    !insertmacro MUI_FUNCTION_CUSTOM PRE
    !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_TEXT_COMPONENTS_TITLE) $(MUI_TEXT_COMPONENTS_SUBTITLE)
  FunctionEnd

  Function "${SHOW}"
  
    !insertmacro MUI_INNERDIALOG_TEXT 1042 $(MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE)
    FindWindow $MUI_TEMP1 "#32770" "" $HWNDPARENT
    GetDlgItem $MUI_TEMP1 $MUI_TEMP1 1043
    EnableWindow $MUI_TEMP1 0
    !insertmacro MUI_INNERDIALOG_TEXT 1043 $(MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO)
    !insertmacro MUI_FUNCTION_CUSTOM SHOW
   
  FunctionEnd

  Function "${LEAVE}"
  
    !ifdef MUI_CUSTOMFUNCTION_COMPONENTS_LEAVE
      Call "${MUI_CUSTOMFUNCTION_COMPONENTS_LEAVE}"
    !endif
  FunctionEnd
  
    
!macroend

!macro MUI_FUNCTION_DIRECTORYPAGE PRE SHOW LEAVE

  Function "${PRE}"
    !insertmacro MUI_FUNCTION_CUSTOM PRE
    !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_TEXT_DIRECTORY_TITLE) $(MUI_TEXT_DIRECTORY_SUBTITLE)
  FunctionEnd

  Function "${SHOW}"
    !insertmacro MUI_FUNCTION_CUSTOM SHOW
  FunctionEnd
  
  Function "${LEAVE}"
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
  FunctionEnd

!macroend

!macro MUI_FUNCTION_STARTMENUPAGE PRE LEAVE
  
  Function "${PRE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM PRE

     !ifdef MUI_STARTMENUPAGE_REGISTRY_ROOT & MUI_STARTMENUPAGE_REGISTRY_KEY & MUI_STARTMENUPAGE_REGISTRY_VALUENAME

      StrCmp "${MUI_STARTMENUPAGE_VARIABLE}" "" 0 +4

      ReadRegStr $MUI_TEMP1 "${MUI_STARTMENUPAGE_REGISTRY_ROOT}" "${MUI_STARTMENUPAGE_REGISTRY_KEY}" "${MUI_STARTMENUPAGE_REGISTRY_VALUENAME}"
        StrCmp $MUI_TEMP1 "" +2
          StrCpy "${MUI_STARTMENUPAGE_VARIABLE}" $MUI_TEMP1
    
    !endif
  
    !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_TEXT_STARTMENU_TITLE) $(MUI_TEXT_STARTMENU_SUBTITLE)
    
    StrCmp $(^RTL) 0 mui.startmenu_nortl
      !ifndef MUI_STARTMENUPAGE_NODISABLE
        StartMenu::Select /rtl /noicon /autoadd /text "$(MUI_INNERTEXT_STARTMENU_TOP)" /lastused "${MUI_STARTMENUPAGE_VARIABLE}" /checknoshortcuts "$(MUI_INNERTEXT_STARTMENU_CHECKBOX)" "${MUI_STARTMENUPAGE_DEFAULTFOLDER}"
      !else
        StartMenu::Select /rtl /noicon /autoadd /text "$(MUI_INNERTEXT_STARTMENU_TOP)" /lastused "${MUI_STARTMENUPAGE_VARIABLE}" "${MUI_STARTMENUPAGE_DEFAULTFOLDER}"
      !endif
      Goto mui.startmenu_calldone
    mui.startmenu_nortl:
      !ifndef MUI_STARTMENUPAGE_NODISABLE
        StartMenu::Select /noicon /autoadd /text "$(MUI_INNERTEXT_STARTMENU_TOP)" /lastused "${MUI_STARTMENUPAGE_VARIABLE}" /checknoshortcuts "$(MUI_INNERTEXT_STARTMENU_CHECKBOX)" "${MUI_STARTMENUPAGE_DEFAULTFOLDER}"
      !else
        StartMenu::Select /noicon /autoadd /text "$(MUI_INNERTEXT_STARTMENU_TOP)" /lastused "${MUI_STARTMENUPAGE_VARIABLE}" "${MUI_STARTMENUPAGE_DEFAULTFOLDER}"
      !endif
    mui.startmenu_calldone:

    Pop $MUI_TEMP1
    StrCmp $MUI_TEMP1 "success" 0 +2
      Pop "${MUI_STARTMENUPAGE_VARIABLE}"
      
  FunctionEnd

  Function "${LEAVE}"

    !insertmacro MUI_FUNCTION_CUSTOM LEAVE

  FunctionEnd

!macroend

!macro MUI_FUNCTION_INSTFILESPAGE PRE SHOW LEAVE

  Function "${PRE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM PRE
    !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_TEXT_INSTALLING_TITLE) $(MUI_TEXT_INSTALLING_SUBTITLE)
    
  FunctionEnd

  Function "${SHOW}"
  
    !insertmacro MUI_FUNCTION_CUSTOM SHOW
    
  FunctionEnd

  Function "${LEAVE}"
    
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
      
    !insertmacro MUI_FINISHHEADER
    !insertmacro MUI_LANGDLL_SAVELANGUAGE
    
  FunctionEnd
  
!macroend

!macro MUI_FUNCTION_FINISHPAGE PRE LEAVE

  Function "${PRE}"
    
    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1028
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1256
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1035
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1037
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1038
    ShowWindow $MUI_TEMP1 ${SW_HIDE}
      
    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1045
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}
    
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "NextButtonText" "$(MUI_BUTTONTEXT_FINISH)"
    
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 2" "Text" "$(MUI_TEXT_FINISH_INFO_TITLE)"
    
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Top" "45"
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Bottom" "85"
    
    !ifndef MUI_FINISHPAGE_NOREBOOTSUPPORT
  
      IfRebootFlag "" mui.finish_noreboot_init
    
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Text" "$(MUI_TEXT_FINISH_INFO_REBOOT)"
    
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "Numfields" "5"
        
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Type" "RadioButton"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Text" "$(MUI_TEXT_FINISH_REBOOTNOW)"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Left" "120"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Right" "321"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Top" "90"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Bottom" "100"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "State" "1"
        
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "Type" "RadioButton"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "Text" "$(MUI_TEXT_FINISH_REBOOTLATER)"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "Left" "120"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "Right" "321"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "Top" "110"
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "Bottom" "120"
    
        Goto mui.finish_load
     
      mui.finish_noreboot_init:
      
    !endif
       
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Text" "$(MUI_TEXT_FINISH_INFO_TEXT)"
      
    !ifdef MUI_FINISHPAGE_RUN
      
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Type" "CheckBox"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Text" "$(MUI_TEXT_FINISH_RUN)"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Left" "120"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Right" "315"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Top" "90"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Bottom" "100"
      !ifndef MUI_FINISHPAGE_RUN_NOTCHECKED
        !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "State" "1"
      !endif
    
    !endif
          
    !ifdef MUI_FINISHPAGE_SHOWREADME
    
      !ifdef MUI_FINISHPAGE_CURFIELD_NO
        !undef MUI_FINISHPAGE_CURFIELD_NO
      !endif
    
      !ifndef MUI_FINISHPAGE_RUN
        !define MUI_FINISHPAGE_CURFIELD_NO 4
        !define MUI_FINISHPAGE_CURFIELD_TOP 90
        !define MUI_FINISHPAGE_CURFIELD_BOTTOM 100
      !else
        !define MUI_FINISHPAGE_CURFIELD_NO 5
        !define MUI_FINISHPAGE_CURFIELD_TOP 110
        !define MUI_FINISHPAGE_CURFIELD_BOTTOM 120
      !endif
      
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Type" "CheckBox"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Text" "$(MUI_TEXT_FINISH_SHOWREADME)"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Left" "120"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Right" "315"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Top" "${MUI_FINISHPAGE_CURFIELD_TOP}"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Bottom" "${MUI_FINISHPAGE_CURFIELD_BOTTOM}"
      !ifndef MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
         !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "State" "1"
      !endif
            
    !endif

    !ifdef MUI_FINISHPAGE_LINK
    
      !ifdef MUI_FINISHPAGE_CURFIELD_NO
        !undef MUI_FINISHPAGE_CURFIELD_NO
      !endif
    
      !ifdef MUI_FINISHPAGE_RUN & MUI_FINISHPAGE_SHOWREADME
        !define MUI_FINISHPAGE_CURFIELD_NO 6
      !else ifdef MUI_FINISHPAGE_RUN | MUI_FINISHPAGE_SHOWREADME
        !define MUI_FINISHPAGE_CURFIELD_NO 5
      !else
        !define MUI_FINISHPAGE_CURFIELD_NO 4
      !endif
    
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Type" "Link"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Text" "${MUI_FINISHPAGE_LINK}"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Left" "120"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Right" "315"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Top" "175"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "Bottom" "185"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "State" "${MUI_FINISHPAGE_LINK_LOCATION}"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field ${MUI_FINISHPAGE_CURFIELD_NO}" "TxtColor" "${MUI_FINISHPAGE_LINK_COLOR}"
            
    !endif
    
    !ifdef MUI_FINISHPAGE_RUN & MUI_FINISHPAGE_SHOWREADME & MUI_FINISHPAGE_LINK
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "Numfields" "6"
    !else ifdef MUI_FINISHPAGE_RUN & MUI_FINISHPAGE_SHOWREADME
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "Numfields" "5"
    !else ifdef MUI_FINISHPAGE_RUN & MUI_FINISHPAGE_LINK
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "Numfields" "5"
    !else ifdef MUI_FINISHPAGE_SHOWREADME & MUI_FINISHPAGE_LINK
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "Numfields" "5"
    !else ifdef MUI_FINISHPAGE_RUN | MUI_FINISHPAGE_SHOWREADME | MUI_FINISHPAGE_LINK
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "Numfields" "4"
    !endif
    
    !ifndef MUI_FINISHPAGE_NOREBOOTSUPPORT
       mui.finish_load:
    !endif
      
    !insertmacro MUI_FUNCTION_CUSTOM PRE
    
    !insertmacro MUI_INSTALLOPTIONS_INITDIALOG "ioSpecial.ini"
    Pop $MUI_HWND
    
    SetCtlColors $MUI_HWND "" "${MUI_BGCOLOR}"
    
    GetDlgItem $MUI_TEMP1 $MUI_HWND 1201
    SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
    CreateFont $MUI_TEMP2 "$(MUI_FONT_TITLE)" "$(MUI_FONTSIZE_TITLE)" "$(MUI_FONTSTYLE_TITLE)"
    SendMessage $MUI_TEMP1 ${WM_SETFONT} $MUI_TEMP2 0
    
    GetDlgItem $MUI_TEMP1 $MUI_HWND 1202
    SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
    
    !ifndef MUI_FINISHPAGE_NOREBOOTSUPPORT
        
      IfRebootFlag 0 mui.finish_noreboot_show
        
        GetDlgItem $MUI_TEMP1 $MUI_HWND 1203
        SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
        
        GetDlgItem $MUI_TEMP1 $MUI_HWND 1204
        SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
          
        Goto mui.finish_show
        
      mui.finish_noreboot_show:
        
    !endif
    
    !ifdef MUI_FINISHPAGE_RUN
      GetDlgItem $MUI_TEMP1 $MUI_HWND 1203
      SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
    !endif
           
    !ifdef MUI_FINISHPAGE_SHOWREADME
      !ifndef MUI_FINISHPAGE_RUN
        GetDlgItem $MUI_TEMP1 $MUI_HWND 1203
      !else
        GetDlgItem $MUI_TEMP1 $MUI_HWND 1204
      !endif
      SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"  
    !endif
    
    !ifdef MUI_FINISHPAGE_LINK
      !ifdef MUI_FINISHPAGE_RUN & MUI_FINISHPAGE_SHOWREADME
        GetDlgItem $MUI_TEMP1 $MUI_HWND 1205
      !else ifdef MUI_FINISHPAGE_RUN | MUI_FINISHPAGE_SHOWREADME
        GetDlgItem $MUI_TEMP1 $MUI_HWND 1204
      !else
        GetDlgItem $MUI_TEMP1 $MUI_HWND 1203
      !endif
      SetCtlColors $MUI_TEMP1 "" "${MUI_BGCOLOR}"
    !endif
     
    !ifndef MUI_FINISHPAGE_NOREBOOTSUPPORT
      mui.finish_show:
    !endif

    !insertmacro MUI_FUNCTION_CUSTOM SHOW

    !insertmacro MUI_INSTALLOPTIONS_SHOW_RETURN
    
    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1028
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1256
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1035
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1037
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1038
    ShowWindow $MUI_TEMP1 ${SW_NORMAL}

    GetDlgItem $MUI_TEMP1 $HWNDPARENT 1045
    ShowWindow $MUI_TEMP1 ${SW_HIDE}

    Pop $MUI_TEMP1
    StrCmp $MUI_TEMP1 "success" 0 mui.finish_done
      
    !ifndef MUI_FINISHPAGE_NOREBOOTSUPPORT
    
      IfRebootFlag "" mui.finish_noreboot_end
      
        !insertmacro MUI_INSTALLOPTIONS_READ $MUI_TEMP1 "ioSpecial.ini" "Field 4" "State"
       
          StrCmp $MUI_TEMP1 "1" 0 +2
            Reboot
            
          Goto mui.finish_done
      
      mui.finish_noreboot_end:
        
    !endif
      
    !ifdef MUI_FINISHPAGE_RUN
  
      !insertmacro MUI_INSTALLOPTIONS_READ $MUI_TEMP1 "ioSpecial.ini" "Field 4" "State"
      
      StrCmp $MUI_TEMP1 "1" 0 mui.finish_norun
        !ifndef MUI_FINISHPAGE_RUN_FUNCTION
          !ifndef MUI_FINISHPAGE_RUN_PARAMETERS
            StrCpy $MUI_TEMP1 "$\"${MUI_FINISHPAGE_RUN}$\""
          !else
            StrCpy $MUI_TEMP1 "$\"${MUI_FINISHPAGE_RUN}$\" ${MUI_FINISHPAGE_RUN_PARAMETERS}"
          !endif
          Exec "$MUI_TEMP1"
        !else
          Call "${MUI_FINISHPAGE_RUN_FUNCTION}"
        !endif
            
        mui.finish_norun:
           
    !endif
             
    !ifdef MUI_FINISHPAGE_SHOWREADME
       
      !ifndef MUI_FINISHPAGE_RUN
        !insertmacro MUI_INSTALLOPTIONS_READ $MUI_TEMP1 "ioSpecial.ini" "Field 4" "State"
      !else
        !insertmacro MUI_INSTALLOPTIONS_READ $MUI_TEMP1 "ioSpecial.ini" "Field 5" "State"
      !endif

      StrCmp $MUI_TEMP1 "1" 0 mui.finish_noshowreadme
        !ifndef MUI_FINISHPAGE_SHOWREADME_FUNCTION
           ExecShell "open" "${MUI_FINISHPAGE_SHOWREADME}"
        !else
          Call "${MUI_FINISHPAGE_SHOWREADME_FUNCTION}"
        !endif
        
        mui.finish_noshowreadme:
               
    !endif
        
    mui.finish_done:

  FunctionEnd
  
  Function "${LEAVE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
  
  FunctionEnd
  
!macroend

!macro MUI_FUNCTION_DESCRIPTION_BEGIN

  !verbose push
  !verbose 3

  Function .onMouseOverSection
    !insertmacro MUI_DESCRIPTION_BEGIN
  
  !verbose pop
  
!macroend

!macro MUI_FUNCTION_DESCRIPTION_END

  !verbose push
  !verbose 3

    !insertmacro MUI_DESCRIPTION_END
  FunctionEnd

  !verbose pop
  
!macroend

!macro MUI_FUNCTIONS_DESCRIPTION_BEGIN

  ;1.65 compatibility

  !warning "Modern UI macro name has changed. Please change MUI_FUNCTIONS_DESCRIPTION_BEGIN to MUI_FUNCTION_DESCRIPTION_BEGIN."

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  
!macroend

!macro MUI_FUNCTIONS_DESCRIPTION_END

  ;1.65 compatibility

  !warning "Modern UI macro name has changed. Please change MUI_FUNCTIONS_DESCRIPTION_END to MUI_FUNCTION_DESCRIPTION_END."

  !insertmacro MUI_FUNCTION_DESCRIPTION_END
  
!macroend

!macro MUI_UNFUNCTION_DESCRIPTION_BEGIN

  !verbose push
  !verbose 3

  Function un.onMouseOverSection
    !insertmacro MUI_DESCRIPTION_BEGIN
  
  !verbose pop
  
!macroend

!macro MUI_UNFUNCTION_DESCRIPTION_END

  !verbose push
  !verbose 3

    !insertmacro MUI_DESCRIPTION_END
  FunctionEnd

  !verbose pop
  
!macroend

!macro MUI_FUNCTION_ABORTWARNING

  !ifdef MUI_ABORTWARNING
    Function .onUserAbort
      !insertmacro MUI_ABORTWARNING
      !ifdef MUI_CUSTOMFUNCTION_ABORT
        Call "${MUI_CUSTOMFUNCTION_ABORT}"
      !endif
    FunctionEnd
  !endif

!macroend

!macro MUI_UNFUNCTION_GUIINIT
  
  Function un.onGUIInit
  
  !insertmacro MUI_UNGUIINIT
  
  !ifdef MUI_CUSTOMFUNCTION_UNGUIINIT
    Call "${MUI_CUSTOMFUNCTION_UNGUIINIT}"
  !endif
  
  FunctionEnd

!macroend

!macro MUI_UNFUNCTION_CONFIRMPAGE PRE SHOW LEAVE

  Function "${PRE}"
  
   !insertmacro MUI_FUNCTION_CUSTOM PRE
   !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_UNTEXT_INTRO_TITLE) $(MUI_UNTEXT_INTRO_SUBTITLE)
  
  FunctionEnd
  
  Function "${SHOW}"
  
    !insertmacro MUI_FUNCTION_CUSTOM SHOW
  
  FunctionEnd
  
  Function "${LEAVE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
    
  FunctionEnd
  
!macroend

!macro MUI_UNFUNCTION_COMPONENTSPAGE PRE SHOW LEAVE

  Function "${PRE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM PRE
    
    !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_UNTEXT_COMPONENTS_TITLE) $(MUI_UNTEXT_COMPONENTS_SUBTITLE)
    
  FunctionEnd
  
  Function "${SHOW}"
  
    !insertmacro MUI_INNERDIALOG_TEXT 1042 $(MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE)
    FindWindow $MUI_TEMP1 "#32770" "" $HWNDPARENT
    GetDlgItem $MUI_TEMP1 $MUI_TEMP1 1043
    EnableWindow $MUI_TEMP1 0
    !insertmacro MUI_INNERDIALOG_TEXT 1043 $(MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO)
    !insertmacro MUI_FUNCTION_CUSTOM SHOW
   
  FunctionEnd
  
  Function "${LEAVE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
  
  FunctionEnd
  
!macroend

!macro MUI_UNFUNCTION_INSTFILESPAGE PRE SHOW LEAVE

  Function ${PRE}
  
    !insertmacro MUI_FUNCTION_CUSTOM PRE
    !insertmacro MUI_HEADER_TEXT_PAGE $(MUI_UNTEXT_UNINSTALLING_TITLE) $(MUI_UNTEXT_UNINSTALLING_SUBTITLE)
  
  FunctionEnd

  Function "${SHOW}"
  
    !insertmacro MUI_FUNCTION_CUSTOM SHOW
  
  FunctionEnd
  
  Function "${LEAVE}"
  
    !insertmacro MUI_FUNCTION_CUSTOM LEAVE
    !insertmacro MUI_UNFINISHHEADER
  
  FunctionEnd
  
!macroend

;--------------------------------
;RESERVE FILES

!macro MUI_RESERVEFILE_WELCOMEFINISHPAGE

  !verbose push
  !verbose 3

  !insertmacro MUI_RESERVEFILE_SPECIALINI
  !insertmacro MUI_RESERVEFILE_SPECIALBITMAP
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
    
  !verbose pop
    
!macroend

!macro MUI_RESERVEFILE_INSTALLOPTIONS

  !verbose push
  !verbose 3
  
  ReserveFile "${NSISDIR}\Plugins\InstallOptions.dll"
  
  !verbose pop
  
!macroend

!macro MUI_RESERVEFILE_SPECIALINI

  !verbose push
  !verbose 3

  ReserveFile "${NSISDIR}\Contrib\Modern UI\ioSpecial.ini"
  
  !verbose pop
  
!macroend

!macro MUI_RESERVEFILE_SPECIALBITMAP

  !verbose push
  !verbose 3

  ReserveFile "${NSISDIR}\Contrib\Icons\modern-wizard.bmp"
  
  !verbose pop
  
!macroend

!macro MUI_RESERVEFILE_LANGDLL

  !verbose push
  !verbose 3
  
  ReserveFile "${NSISDIR}\Plugins\LangDLL.dll"
  
  !verbose pop
  
!macroend

!macro MUI_RESERVEFILE_STARTMENU

  !verbose push
  !verbose 3
  
  ReserveFile "${NSISDIR}\Plugins\StartMenu.dll"
  
  !verbose pop
  
!macroend

;--------------------------------
;INSERT ALL CODE

!macro MUI_INSERT
  
  !insertmacro MUI_INTERFACE
  
  !insertmacro MUI_FUNCTION_GUIINIT
  !insertmacro MUI_FUNCTION_ABORTWARNING
  
  !ifdef MUI_UNINSTALLER
    !insertmacro MUI_UNFUNCTION_GUIINIT
  !endif
  
!macroend

;--------------------------------
;LANGUAGE FILES

!macro MUI_LANGUAGEFILE_BEGIN LANGUAGE

  !ifndef MUI_INSERT
    !define MUI_INSERT
    !insertmacro MUI_INSERT
  !endif
  
  !ifndef "MUI_LANGUAGEFILE_${LANGUAGE}_USED"
  
    !define "MUI_LANGUAGEFILE_${LANGUAGE}_USED"

    LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LANGUAGE}.nlf"

  !else

    !error "Modern UI language file ${LANGUAGE} included twice!"

  !endif
  
!macroend

!macro MUI_LANGUAGEFILE_STRING NAME VALUE

  !ifndef "${NAME}"
    !define "${NAME}" "${VALUE}"
  !endif

!macroend

!macro MUI_LANGUAGEFILE_LANGSTRING NAME

  LangString "${NAME}" 0 "${${NAME}}"
  !undef "${NAME}"
  
!macroend

!macro MUI_LANGUAGEFILE_LANGSTRING_NOUNDEF NAME

  LangString "${NAME}" 0 "${${NAME}}"
  
!macroend

!macro MUI_LANGUAGEFILE_LANGSTRING_CUSTOMDEFINE NAME DEFINE

  LangString "${NAME}" 0 "${${DEFINE}}"
  !undef "${NAME}"

!macroend

!macro MUI_LANGUAGEFILE_LANGSTRING_CUSTOMSTRING NAME STRING

  LangString "${STRING}" 0 "${${NAME}}"
  !undef "${NAME}"

!macroend

!macro MUI_LANGUAGEFILE_LANGSTRING_CUSTOMDEFINE_NOUNDEF NAME DEFINE

  LangString "${NAME}" 0 "${${DEFINE}}"

!macroend

!macro MUI_LANGUAGEFILE_DEFINE DEFINE NAME

  !ifndef "${DEFINE}"
    !define "${DEFINE}" "${${NAME}}"
  !endif
  !undef "${NAME}"
  
!macroend

!macro MUI_LANGUAGEFILE_LANGSTRING_INSTFONT NAME DEFAULT

  !ifdef "${NAME}"
    Langstring "${NAME}" 0 "${${NAME}}"
    !undef "${NAME}"
  !else
    Langstring "${NAME}" 0 "${DEFAULT}"
  !endif
  
!macroend

!macro MUI_LANGUAGEFILE_LANGSTRING_FONT NAME DEFAULT

  !ifdef "${NAME}"
    Langstring "${NAME}" 0 "${${NAME}}"
    !undef "${NAME}"
  !else
    Langstring "${NAME}" 0 "${DEFAULT}"
  !endif
  
!macroend

!macro MUI_LANGUAGEFILE_END

  !insertmacro MUI_LANGUAGEFILE_DEFINE "MUI_${LANGUAGE}_LANGNAME" "MUI_LANGNAME"
    
  !ifndef MUI_LANGDLL_PUSHLIST
    !define MUI_LANGDLL_PUSHLIST "'${MUI_${LANGUAGE}_LANGNAME}' ${LANG_${LANGUAGE}} "
  !else
    !ifdef MUI_LANGDLL_PUSHLIST_TEMP
      !undef MUI_LANGDLL_PUSHLIST_TEMP
    !endif
    !define MUI_LANGDLL_PUSHLIST_TEMP "${MUI_LANGDLL_PUSHLIST}"
    !undef MUI_LANGDLL_PUSHLIST
    !define MUI_LANGDLL_PUSHLIST "'${MUI_${LANGUAGE}_LANGNAME}' ${LANG_${LANGUAGE}} ${MUI_LANGDLL_PUSHLIST_TEMP}"
  !endif
  
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING_FONT "MUI_FONT_HEADER" "MS Shell Dlg"
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING_FONT "MUI_FONTSIZE_HEADER" "8"
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING_FONT "MUI_FONTSTYLE_HEADER" "700"
  
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING_INSTFONT "MUI_FONT_TITLE" "Verdana"
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING_INSTFONT "MUI_FONTSIZE_TITLE" "12"
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING_INSTFONT "MUI_FONTSTYLE_TITLE" "700"
  
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING_NOUNDEF "MUI_BGCOLOR"
    
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_NAME"
  
  !ifdef MUI_WELCOMEPAGE
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_WELCOME_INFO_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_WELCOME_INFO_TEXT"
  !endif

  !ifdef MUI_LICENSEPAGE
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_LICENSE_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_LICENSE_SUBTITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_INNERTEXT_LICENSE_TOP"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING_CUSTOMSTRING "MUI_INNERTEXT_LICENSE_BOTTOM" "^LicenseText"
    !ifdef MUI_LICENSEPAGE_CHECKBOX_USED
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING_CUSTOMSTRING "MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX" "^LicenseTextCB"
    !endif
    !ifdef MUI_LICENSEPAGE_RADIOBUTTONS_USED
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING_CUSTOMSTRING "MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS" "^LicenseTextRB"
    !endif
  !endif
  
  !ifdef MUI_COMPONENTSPAGE
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_COMPONENTS_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_COMPONENTS_SUBTITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO"
  !endif
  
  !ifdef MUI_DIRECTORYPAGE
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_DIRECTORY_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_DIRECTORY_SUBTITLE"
  !endif
  
  !ifdef MUI_STARTMENUPAGE
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_STARTMENU_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_STARTMENU_SUBTITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_INNERTEXT_STARTMENU_TOP"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_INNERTEXT_STARTMENU_CHECKBOX"
  !endif
  
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_TITLE"
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_SUBTITLE"

  
  !ifdef MUI_TEXT_ABORT_TITLE
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_ABORT_TITLE"
  !endif
  
  !ifdef MUI_TEXT_ABORT_SUBTITLE
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_ABORT_SUBTITLE"
  !endif
  
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_INSTALLING_TITLE"
  !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_INSTALLING_SUBTITLE"
    
  !ifdef MUI_FINISHPAGE
    !ifdef MUI_BUTTONTEXT_FINISH
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_BUTTONTEXT_FINISH"
    !endif
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_INFO_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_INFO_TEXT"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_INFO_REBOOT"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_REBOOTNOW"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_REBOOTLATER"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_RUN"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_FINISH_SHOWREADME"
  !else
    !ifndef MUI_BUTTONTEXT_CLOSE
      !define MUI_BUTTONTEXT_CLOSE " "
    !endif
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_BUTTONTEXT_CLOSE"
  !endif
  
  !ifdef MUI_ABORTWARNING
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_TEXT_ABORTWARNING"
  !endif
  
  
  !ifdef MUI_UNINSTALLER
    
    !ifdef MUI_UNCONFIRMPAGE
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_INTRO_TITLE"
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_INTRO_SUBTITLE"
    !endif
    
    !ifdef MUI_UNCOMPONENTSPAGE
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_COMPONENTS_TITLE"
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_COMPONENTS_SUBTITLE"
    !endif
     
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_FINISH_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_FINISH_SUBTITLE"
    
    !ifdef MUI_UNTEXT_ABORT_TITLE
       !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_ABORT_TITLE"
    !endif
    
    !ifdef MUI_UNTEXT_ABORT_SUBTITLE
      !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_ABORT_SUBTITLE"
    !endif
    
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_UNINSTALLING_TITLE"
    !insertmacro MUI_LANGUAGEFILE_LANGSTRING "MUI_UNTEXT_UNINSTALLING_SUBTITLE"
  
  !endif
    
!macroend

;--------------------------------
;END

!endif

!ifndef MUI_MANUALVERBOSE
  !verbose 4
!endif