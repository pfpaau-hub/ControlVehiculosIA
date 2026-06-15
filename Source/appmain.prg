#include 'source\appdefs.h'
LPARAMETER cParameter
*++
* Standard CodeMine Application Main Program
*--
  * Store parameter where it will survive the CLEAR ALL
  _SCREEN.AddProperty('uCodeMineAppParameter', IIF(NOT EMPTY(m.cParameter), m.cParameter, ''))
  SET TALK OFF
  CLEAR ALL

  * Clear any pre-existing libraries and handlers that are not part of our app.
  SET LIBRARY TO
  SET CLASSLIB TO
  SET PROCEDURE TO
  ON SHUTDOWN

  * If developer ran appMain.prg outside the APP/EXE file, get path to core components.
  LOCAL cRootKey, cPath
  m.cPath = IIF('...' $ SYS(16, 1), SYS(16, 2), SYS(16,1))
  IF VERSION(2) != 0 AND RIGHT(m.cPath, 4) == '.FXP'   
    IF PEMSTATUS(_SCREEN, 'cCodemineCommonPath', 5)
      CD LEFT(m.cPath, RAT('\', m.cPath, 2) - 1)
      SET PATH TO 'Source\,' + _SCREEN.cCodemineCommonPath
    ENDIF
  ENDIF

  * Build root system registry key for this application. Passed as parameter to application object.
  m.cRootKey = VERSION_LOC
  IF OCCURS('.', m.cRootKey) > 1
    m.cRootKey = LEFT(m.cRootKey, AT('.', m.cRootkey, 2) - 1)
  ENDIF
  m.cRootKey = 'Software\' + COMPANYNAME_LOC + '\' + APPNAME_LOC + '\' + m.cRootKey

  * Load core CodeMine support classes, and main application class library.
  SET PROCEDURE TO Codemine
  SET CLASSLIB TO AppMain, AppForms

  * Create the main application object and start it running.
  PUBLIC goApp         && Make this available for global access by menus and ON SHUTDOWN handler.
  m.goApp = CreateGlobalObject('appApplication',, m.cRootKey)
  IF VARTYPE(m.goApp) = 'O'
    m.goApp.Start(_SCREEN.uCodeMineAppParameter)
  ENDIF

  * Release all remaining shared global service objects before exit.
  ReleaseGlobalObject()

  CLEAR ALL
  SET LIBRARY TO
  SET CLASSLIB TO
  SET PROCEDURE TO
  RETURN .T.
