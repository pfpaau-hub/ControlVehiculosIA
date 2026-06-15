#include 'source\appdefs.h'
*++
* The serial number incorporates the company name and application name into the hash
* algorithm, so valid serial numbers will be different for every application.
*
* Generated serial numbers are case-independent.
*--
LOCAL cRootKey, cLeft, cRight, cSerialNo

  * Build root system registry key, minus version number.
  * Used to create unique serial numbers for each application.
  m.cRootKey = 'Software\' + COMPANYNAME_LOC + '\' + APPNAME_LOC + '\'

  DO WHILE .T.
    ACCEPT 'Enter first six characters of a serial number (empty to exit): ' TO cLeft
    IF EMPTY(m.cLeft)
      EXIT
    ELSE
      m.cLeft = LEFT(m.cLeft, 6)
      m.cRight = m.cRootKey + STRTRAN(STRTRAN(m.cLeft, ' ', ''), '-', '')
      m.cSerialNo = m.cLeft + '-' + PADL(SYS(2007, UPPER(m.cRight) + LOWER(m.cRight)), 5, '0')
      ?'Complete serial number is: ' + PROPER(m.cSerialNo)   && Case doesnt matter
      ?''
    ENDIF
  ENDDO
