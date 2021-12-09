curPath = createobject("Scripting.FileSystemObject").GetFile(Wscript.ScriptFullName).ParentFolder.Path + "\StartExe.bat"

createobject("wscript.shell").run curPath , 0