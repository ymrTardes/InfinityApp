
### Тестирование ansi-terminal

```haskell
hSetBuffering stdout NoBuffering
hSetBuffering stdin NoBuffering

tsize <- getTerminalSize
print tsize

setSGR [SetColor Foreground Vivid Red]
setSGR [SetColor Background Vivid Blue]
putStrLn "---APP---"
putStrLn "|#######|"
putStrLn "|#######|"
putStrLn "|#######|"
putStrLn "---------"
setSGR [Reset]

saveCursor
cursorUp 3
cursorForward 2
putStrLn "hello"
restoreCursor

putStrLn "---AA---"
hFlush stdout
```