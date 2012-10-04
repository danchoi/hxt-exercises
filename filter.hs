module Main
where
 
import Text.XML.HXT.Core
-- import Text.XML.HXT....   -- further HXT packages
 
import System.IO
import System.Environment
import System.Console.GetOpt
import System.Exit
 
main :: IO ()
main
    = do
      argv <- getArgs
      (al, src) <- cmdlineOpts argv
      [rc]  <- runX (application al src)
      if rc >= c_err
	 then exitWith (ExitFailure (0-1))
	 else exitWith ExitSuccess
 
-- | the dummy for the boring stuff of option evaluation,
-- usually done with 'System.Console.GetOpt'
 
cmdlineOpts 	:: [String] -> IO (SysConfigList, String)
cmdlineOpts argv
    = return ([withValidate no], argv!!0)
 
-- | the main arrow
 
application	:: SysConfigList -> String -> IOSArrow b Int
application cfg src 
    = configSysVars cfg                                           -- (0)
      >>>
      readDocument [] src
      >>>
      processChildren (processDocumentRootElement `when` isElem)  -- (1)
      >>>
      writeDocument [] "-"
      >>>
      getErrStatus
 
 
-- | the dummy for the real processing: the identity filter
 
processDocumentRootElement	:: IOSArrow XmlTree XmlTree
processDocumentRootElement
    = selectAllText         -- substitute this by the real application

selectAllText :: ArrowXml a => a XmlTree XmlTree
selectAllText 
  = deep isText


selectAllTextAndAltValues	:: ArrowXml a => a XmlTree XmlTree
selectAllTextAndAltValues
    = deep
      ( isText                       -- (1)
	<+>
	( isElem >>> hasName "img"   -- (2)
	  >>>
	  getAttrValue "alt"         -- (3)
	  >>>
	  mkText                     -- (4)
	)
      )
