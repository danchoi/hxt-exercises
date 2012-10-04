module Main
where
 
import Text.XML.HXT.Core
import Text.XML.HXT.Curl -- use libcurl for HTTP access
import System.IO
 
import System.Environment
 
main :: IO ()
main
    = do
      src <- getContents
      runX ( readString [withParseHTML no] src
	     >>>
	     writeDocument [withIndent yes ,withOutputEncoding isoLatin1 ] "-"
	   )
      return ()
